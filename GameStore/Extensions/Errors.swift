//
//  Errors.swift
//  GameStore
//
//  Created by Deanu Haratinu on 07/10/23.
//

import Foundation

enum GeneralError: Error {
    case error(errorMessage: String)
    case unknownError
}
