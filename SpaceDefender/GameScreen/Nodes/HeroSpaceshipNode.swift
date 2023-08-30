//
//  HeroSpaceship.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 23.08.2023.
//

import SpriteKit

final class HeroSpaceshipNode: SKSpriteNode {

    func setupNode(at position: CGPoint) {
        // Set texture, size and position and name
        self.texture = GameTextureConstants.heroTexture
//        self.size = GameUIConstants.heroSize
        self.aspectFitToSize(fillSize: GameUIConstants.heroSize)
        self.position = position
        // Add it to group of nodes with same name
        self.name = GameLogicConstants.heroName

        // Set physical body
        self.physicsBody = SKPhysicsBody(
            texture: self.texture!,
            size: self.size
        )
        self.physicsBody?.isDynamic = false

        // Set bit mask
        self.physicsBody?.categoryBitMask = GameLogicConstants.heroCategory
        self.physicsBody?.collisionBitMask = GameLogicConstants.defaultCategory
        self.physicsBody?.contactTestBitMask = GameLogicConstants.asteroidCategory | GameLogicConstants.enemyCategory | GameLogicConstants.enemyBulletCategory
    }

     func startActions() {
        startShooting()
    }

    private func startShooting() {
        // Create bullet and add it to scene
        let creatAction = SKAction.run { [weak self] in
            guard let bullet = self?.createBullet() else { return }
            // !!! add to parent, not self!
            self?.parent?.addChild(bullet)
        }

        // 1 second / numberOfAsteroids = pause duration (because creation almost instant)
        let creationSpeed: Double = 1 / GameLogicConstants.heroBulletsPerSecond

        // The duration of the idle, in seconds
        let waitAction = SKAction.wait(forDuration: creationSpeed)

        // Create sequence of creation and wait
        let actionSequence = SKAction.sequence([creatAction, waitAction])

        // Loop it and run it
        let actionLoop = SKAction.repeatForever(actionSequence)
        self.run(actionLoop)
    }

    private func createBullet() -> SKSpriteNode  {
        // Create the bullet sprite
        let bullet = SKSpriteNode()
        bullet.color = .green
        bullet.size = GameUIConstants.bulletSize
        bullet.position = CGPoint(
            x: self.position.x,
            y: self.position.y + GameUIConstants.heroSide / 2
        )
        bullet.name = GameLogicConstants.heroBulletName

        // Setup physics body and add starting speed
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.linearDamping = 0.0
        bullet.physicsBody?.velocity = CGVector(
            dx: 0,
            dy: GameLogicConstants.heroBulletBaseSpeed * GameLogicConstants.gameSpeed
        )

        // bit masks
        bullet.physicsBody?.categoryBitMask = GameLogicConstants.heroBulletCategory
        bullet.physicsBody?.collisionBitMask = GameLogicConstants.defaultCategory
        bullet.physicsBody?.contactTestBitMask = GameLogicConstants.enemyCategory

        return bullet
    }
}
