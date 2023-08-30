//
//  ScoreModel.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 19.08.2023.
//

import Foundation

/// Модель хранение данных результата игры
/// Будет хранится в UserDefaults, поэтому д.б. Сodable
struct ScoreModel: Codable {
    let spaceshipModel: String
    let userNickname: String
    let userScore: UInt
}
