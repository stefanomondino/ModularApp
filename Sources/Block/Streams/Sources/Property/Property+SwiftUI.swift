//
//  Property+SwiftUI.swift
//  Streams
//
//  Created by Stefano Mondino on 23/10/25.
//

import Foundation
import SwiftUI

public extension Property {
    var binding: Binding<Element> {
        Binding(get: { self.value },
                set: { self.send($0) })
    }
}
