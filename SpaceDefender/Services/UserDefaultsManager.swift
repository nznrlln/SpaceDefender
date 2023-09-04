//
//  UserDefaultsManager.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 19.08.2023.
//

import Foundation

/// Ключи для хранения в UserDefaults, через rawValue каждого из case'ов
enum UserDefaultsKeys: String {
    case currentSpaceshipModel
    case currentUserNickname
    case currentGameSpeed

    case scores
}


final class UserDefaultsManager {

    // MARK: let/var

    /// Синглтон
    static let shared = UserDefaultsManager()

    private let userDefaults = UserDefaults.standard

    /// Текущая модель корабля
    var currentSpaceshipModel: String {
        get {
            userDefaults.value(forKey: UserDefaultsKeys.currentSpaceshipModel.rawValue) as? String ?? "Red Spaceship"
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.currentSpaceshipModel.rawValue)
        }
    }

    /// Имя текущего игрока
    var currentUserNickname: String {
        get {
            userDefaults.value(forKey: UserDefaultsKeys.currentUserNickname.rawValue) as? String ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.currentUserNickname.rawValue)
        }
    }

    /// Текущая скорость игры
    var currentGameSpeed: Float {
        get {
            userDefaults.value(forKey: UserDefaultsKeys.currentGameSpeed.rawValue) as? Float ?? 1.0
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.currentGameSpeed.rawValue)
        }
    }

    /// Список результатов, добавленных пользователеми.
    var scores: [ScoreModel] {
        get {
            let array = userDefaults.value([ScoreModel].self, forKey: UserDefaultsKeys.scores.rawValue) ?? []

            return array.sorted(by: {$0.userScore > $1.userScore})
        }
        set {
            userDefaults.set(encodable: newValue, forKey: UserDefaultsKeys.scores.rawValue)
        }
    }


    private init() {}

}
