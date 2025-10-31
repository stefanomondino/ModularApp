//
//  CancellableTask.swift
//  Streams
//
//  Created by Stefano Mondino on 25/06/25.
//
import Foundation

private protocol CancellableTask: Sendable {
    var isCancelled: Bool { get }
    func cancel()
}

extension Task: CancellableTask {}

public actor TaskBag {
    private var tasks: [CancellableTask] = []

    public func add(_ task: Task<some Sendable, some Error>) {
        tasks.append(task)
    }

    public init() {}
    public var isEmpty: Bool {
        tasks.isEmpty
    }

    public func cancel() {
        for task in tasks where !task.isCancelled {
            task.cancel()
        }
    }

    deinit {
        // Cannot call cancel() directly until
        for task in tasks where !task.isCancelled {
            task.cancel()
        }
    }
}

public extension Task {
    func store(in bag: TaskBag) {
        Task<Void, Never> { await bag.add(self) }
    }
}
