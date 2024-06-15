//
//  MainModel.swift
//  Capstone Project Cem
//
//  Created by Can on 9.06.2024.
//

import Foundation

struct MainModel {
    var response : String
    var type : TableViewResponse
}

enum TableViewResponse {
    case user
    case ai
}
