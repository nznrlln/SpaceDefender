//
//  Enemy.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 16.08.2023.
//

import SpriteKit

final class EnemySpaceshipNode: SKSpriteNode {

    func setupNode(at position: CGPoint) {
        // Set texture, size and position and name
        self.texture = GameTextureConstants.enemyTexture
        self.size = GameUIConstants.enemySize
        self.position = position
        // Add it to group of nodes with same name
        self.name = GameLogicConstants.enemyName

        // Set physical body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0.0
        // Set bit mask
        self.physicsBody?.categoryBitMask = GameLogicConstants.enemyCategory
        self.physicsBody?.collisionBitMask = GameLogicConstants.defaultCategory
        self.physicsBody?.contactTestBitMask = GameLogicConstants.heroCategory | GameLogicConstants.heroBulletCategory
    }

     func startActions() {
        startMoving()
        startShooting()
    }

    private func startMoving() {
        self.physicsBody?.velocity = CGVector(
            dx: 0,
            dy: GameLogicConstants.enemyBaseSpeed * GameLogicConstants.gameSpeed
        )
    }

    private func startShooting() {
        // Create bullet and add it to scene
        let creatAction = SKAction.run { [weak self] in
            guard let bullet = self?.createBullet() else { return }
            // !!! add to parent, not self!
            self?.parent?.addChild(bullet)
        }

        // 1 second / numberOfAsteroids = pause duration (because creation almost instant)
        let creationSpeed: Double = 1 / GameLogicConstants.enemyBulletsPerSecond

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
        bullet.color = .red
        bullet.size = GameUIConstants.bulletSize
        bullet.position = CGPoint(
            x: self.position.x,
            y: self.position.y - GameUIConstants.enemySize.height / 2
        )
        bullet.name = GameLogicConstants.enemyBulletName

        // Setup physics body and add starting speed
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.linearDamping = 0.0
        bullet.physicsBody?.velocity = CGVector(
            dx: 0,
            dy: GameLogicConstants.enemyBulletBaseSpeed * GameLogicConstants.gameSpeed
        )

        // bit masks
        bullet.physicsBody?.categoryBitMask = GameLogicConstants.enemyBulletCategory
        bullet.physicsBody?.collisionBitMask = GameLogicConstants.defaultCategory
        bullet.physicsBody?.contactTestBitMask = GameLogicConstants.heroCategory

        return bullet
    }

}
