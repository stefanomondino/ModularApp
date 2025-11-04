//
//  CLLocationDataSource.swift
//  Permissions
//
//  Created by Stefano Mondino on 03/11/25.
//

import CoreLocation
import DataStructures
import Foundation
import Streams

public final class CLLocationDataSource: LocationDataSource {
    fileprivate final class Delegate: NSObject, CLLocationManagerDelegate {
        weak var dataSource: CLLocationDataSource?

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            let value = LocationPermissionStatus(manager.authorizationStatus)
            let status = dataSource?.status
            Task { @MainActor in status?.send(value) }
        }

        func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let signal = dataSource?.location else { return }
            Task { @MainActor in
                for newValue in locations {
                    signal.send(newValue)
                }
            }
        }
    }

    public final class LocationStream: AsyncSequence {
        private let signal: Signal<CLLocation>
        private weak var dataSource: CLLocationDataSource?
        private weak var delegate: Delegate?
        fileprivate init(dataSource: CLLocationDataSource, delegate: Delegate) {
            self.dataSource = dataSource
            signal = dataSource.location
            self.delegate = delegate
        }

        public func makeAsyncIterator() -> some AsyncIteratorProtocol {
            let dataSource = dataSource
            Task { @MainActor in
                await dataSource?.askForPermissions(mode: .whenInUse)
                dataSource?.manager.startUpdatingLocation()
            }
            return signal.makeAsyncIterator()
        }

        deinit {
            let dataSource = self.dataSource
            Task { @MainActor in dataSource?.manager.stopUpdatingLocation() }
        }
    }

    let manager: CLLocationManager
    private let status: Property<LocationPermissionStatus> = .init(.unknown)
    private let location: Signal<CLLocation> = .init()
    private let delegate = Delegate()
    private var locationStream: LocationStream?
//    private var locationStream: Box<AsyncShareSequence<AsyncStream<CLLocation>>>?
    public var authorizationStatus: ShareableAsyncStream<LocationPermissionStatus> {
        status.asShareableStream()
    }

    public func shouldAskForPermissions() async -> Bool {
        status.value == .notDetermined
    }

    public init(manager: CLLocationManager = .init()) {
        self.manager = manager
        manager.delegate = delegate
        status.send(.init(manager.authorizationStatus))
        delegate.dataSource = self
    }

    @discardableResult
    public func askForPermissions(mode: LocationPermissionRequestMode) async -> LocationPermissionStatus {
        if status.value.alreadyGranted(for: mode.status) {
            return status.value
        }
        switch mode {
        case .whenInUse: manager.requestWhenInUseAuthorization()
        case .always: manager.requestAlwaysAuthorization()
        }
        for await value in status.filter({ $0 != .notDetermined }).prefix(1) {
            return value
        }
        return .unknown
    }

    public func locations() -> LocationStream {
        if let locationStream {
            return locationStream
        }

        let stream = LocationStream(dataSource: self, delegate: delegate)
        locationStream = stream
        return stream
    }
}
