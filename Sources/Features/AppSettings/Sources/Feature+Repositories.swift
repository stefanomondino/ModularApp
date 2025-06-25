//
//  Feature+Repositories.swift
//  AppSettings
//
//  Created by Stefano Mondino on 24/06/25.
//

extension Feature {
    func setupRepositories() async {
        await register(for: ThemeRepository.self) { [self] in
            await ThemeRepositoryImplementation(networking: unsafeResolve())
        }
    }
}
