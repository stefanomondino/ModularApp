//
//  environments.swift
//  ProjectDescriptionHelpers
//
//  Created by Stefano Mondino on 02/01/23.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

private let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return encoder
}()

@MainActor private let items = appModules.map { app in
    let data = try! encoder.encode(app)
    let string = String(data: data,
                        encoding: .utf8)!
    let path = "Sources/Apps/\(app.folder)/Sources/Environments/\(app.name)/Environment.environment"
    return ProjectDescription.Template.Item
        .string(path: path,
                contents: string)
}

@MainActor let environments = Template(description: "custom template",
                                       items: items)
