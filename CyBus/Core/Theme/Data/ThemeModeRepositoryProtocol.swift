//
//  ThemeRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

protocol ThemeModeRepositoryProtocol {
    func save(_ mode: ThemeMode)
    func load() -> ThemeMode?
}

