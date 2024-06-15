//
//  MainViewModelProtocol.swift
//  Capstone Project Cem
//
//  Created by Can on 13.06.2024.
//

import Foundation

protocol MainViewModelProtocol {
    var chatList: [MainModel] { get set }
    var delegate: MainViewModelDelegate? { get set }
    func generateTextForPrompt(text : String) async -> ResultType
}

enum MainViewNotify {
    case reloadTableView
}

protocol MainViewModelDelegate {
    func handle(notify: MainViewNotify)
}

enum ResultType {
    case error
    case success
    case empty
}
