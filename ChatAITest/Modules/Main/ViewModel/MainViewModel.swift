//
//  MainViewModel.swift
//  Capstone Project Cem
//
//  Created by Can on 13.06.2024.
//

import Foundation
import GoogleGenerativeAI

final class MainViewModel : MainViewModelProtocol {

    var chatList: [MainModel] = []
    var delegate: MainViewModelDelegate?
    
    func generateTextForPrompt(text : String) async -> ResultType{
        let apiKey = Constants.apiKey
        let model = GenerativeModel(name: "gemini-pro", apiKey: apiKey)
        do {
            let response = try await model.generateContent(text)
            if let text = response.text{
                chatList.append(.init(response: text, type: .ai))
                notify(with: .reloadTableView)
                return .success
            } else {
                return .empty
            }
        } catch {
            print("Error generating content: \(error)")
            return .error
        }
    }
    
    private func notify(with notify: MainViewNotify) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.handle(notify: notify)
        }
    }
}
