//
//  GameTextures.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 22.08.2023.
//

import SpriteKit

enum GameTextureConstants {
    static var heroTexture: SKTexture {
        SKTexture(imageNamed: UserDefaultsManager.shared.currentSpaceshipModel)
    }
    static let enemyTexture = SKTexture(imageNamed: "Enemy Spaceship")
    static let asteroidTexture = SKTexture(imageNamed: "Asteroid")
    static let starTexture = SKTexture(imageNamed: "Star")
}
