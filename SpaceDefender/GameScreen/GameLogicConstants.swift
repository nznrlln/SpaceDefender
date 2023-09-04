//
//  GameLogicConstants.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 22.08.2023.
//

import Foundation

enum GameLogicConstants {
    // Bit masks
    static let defaultCategory: UInt32 = 0x1 << 0 // no custom object with such mask
    static let heroCategory: UInt32 = 0x1 << 1
    static let heroBulletCategory: UInt32 = 0x1 << 2
    static let asteroidCategory: UInt32 = 0x1 << 3
    static let enemyCategory: UInt32 = 0x1 << 4
    static let enemyBulletCategory: UInt32 = 0x1 << 5

    // Controls speed
    static let controlSpeed: CGFloat = 1.3
    static var gameSpeed: CGFloat {
        CGFloat(UserDefaultsManager.shared.currentGameSpeed)
    }

    // entities specs
    static let heroName = "Hero"

    static let heroBulletName = "HeroBullet"
    static let heroBulletsPerSecond: Double = 1
    static let heroBulletBaseSpeed: CGFloat = 400

    static let asteroidName = "Asteroid"
    static let asteroidsPerSecond: Double = 0.5
    static var asteroidBaseSpeed: CGFloat {
        CGFloat.random(in: (-400 ... -200))
    }

    static let enemyName = "Enemy"
    static let enemiesPerSecond: Double = 0.3
    static let enemyBaseSpeed: CGFloat = -100

    static let enemyBulletName = "EnemyBullet"
    static let enemyBulletsPerSecond: Double = 0.5
    static let enemyBulletBaseSpeed: CGFloat = -300

    // points
    static let pointsPerAsteroid: UInt = 1
    static let pointsPerEnemy: UInt = 2
}
