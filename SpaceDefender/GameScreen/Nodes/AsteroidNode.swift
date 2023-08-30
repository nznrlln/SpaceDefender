//
//  Asteroid.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 23.08.2023.
//

import SpriteKit

final class AsteroidNode: SKSpriteNode {

    func setupNode(at position: CGPoint) {
        // Set texture, size and position and name
        self.texture = GameTextureConstants.asteroidTexture
        self.size = GameUIConstants.asteroidSize
        self.position = position
        // Add it to group of nodes with same name
        self.name = GameLogicConstants.asteroidName

        // Set physical body
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0.0
        // Set bit mask
        self.physicsBody?.categoryBitMask = GameLogicConstants.asteroidCategory
        self.physicsBody?.collisionBitMask = GameLogicConstants.asteroidCategory
        self.physicsBody?.contactTestBitMask = GameLogicConstants.heroCategory
    }

     func startActions() {
        startMoving()
    }

    private func startMoving() {
        self.physicsBody?.velocity = CGVector(
            dx: 0,
            dy: GameLogicConstants.asteroidBaseSpeed * GameLogicConstants.gameSpeed
        )
    }

}
