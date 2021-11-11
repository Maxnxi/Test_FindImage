//
//  AppError.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 11.11.2021.
//

import Foundation

enum AppError: Error {
    case noDataProvided
    case failedToDecode
    case errorTask
    case notCorrectUrl
    case guardError
    case failToFullArrayWithCoordinates
    case offlineAndNoDataDownloaded
}
