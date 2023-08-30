//
//  GameScene.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 01.08.2023.
//

import SpriteKit
import GameplayKit

protocol GameSceneDelegate: AnyObject {
    func gameDidEnd(with score: UInt)
}

final class GameScene: SKScene {

    // MARK: - lets/vars
    weak var gameDelegate: GameSceneDelegate?

    private var startTouch = CGPoint()
    private var spaceshipPostion = CGPoint()

    private var score: UInt = 0
    private lazy var scoreLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontColor = .white
        label.fontSize = 20
        label.text = "Score: \(score)"

        return label
    }()

    private let heroSpaceship = HeroSpaceshipNode()

    // MARK: - lifecycle
    override func didMove(to view: SKView) {
        viewInitialSettings()
    }

    override func didSimulatePhysics() {
        deleteHiddenNodes()
    }

    // MARK: - touch controls
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            startTouch = location
            spaceshipPostion = heroSpaceship.position
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nextPosition = CGPoint(
                // ships last x position + the diff between start & end of touch
                x: spaceshipPostion.x + (location.x - startTouch.x) * GameLogicConstants.controlSpeed,
                y: spaceshipPostion.y
            )
            if isNextPositionOk(nextPosition) {
                heroSpaceship.run(SKAction.move(to: nextPosition, duration: 0.1))
            }
        }

    }

    // MARK: - methods
    private func viewInitialSettings() {
        // For collision detection
        physicsWorld.contactDelegate = self

        setupNodes()
    }

    private func setupNodes() {

        scoreLabel.position = CGPoint(
            x: frame.maxX - scoreLabel.calculateAccumulatedFrame().width,
            y: frame.maxY - scoreLabel.calculateAccumulatedFrame().height
        )
        addChild(scoreLabel)

        let heroPosition = CGPoint(
            x: view?.center.x ?? 0,
            y: (view?.safeAreaInsets.bottom ?? 0) + (GameUIConstants.heroSide / 2 + GameUIConstants.heroInset)
        )
        heroSpaceship.setupNode(at: heroPosition)
        heroSpaceship.startActions()
        addChild(heroSpaceship)

        startBackground()
        startAsteroidsCreation()
        startEnemiesCreation()
    }

    private func startAsteroidsCreation() {
        // Create asteroid and add it to scene
        let creatAction = SKAction.run { [weak self] in
            guard let asteroid = self?.createAsteroid() else { return }
            self?.addChild(asteroid)
        }

        // 1 second / numberOfAsteroids = pause duration (because creation almost instant)
        let creationSpeed: Double = 1 / (GameLogicConstants.asteroidsPerSecond * GameLogicConstants.gameSpeed)

        // The duration of the idle, in seconds
        let waitAction = SKAction.wait(forDuration: creationSpeed)

        // Create sequence of creation and wait
        let actionSequence = SKAction.sequence([creatAction, waitAction])

        // Loop it and run it
        let actionLoop = SKAction.repeatForever(actionSequence)
        self.run(actionLoop)
    }

    private func createAsteroid() -> SKSpriteNode {
        let enemy = AsteroidNode()
        let position = CGPoint(
            x: CGFloat.random(in: (GameUIConstants.asteroidSide...(self.frame.maxX - GameUIConstants.asteroidSide))),
            y: self.frame.maxY + GameUIConstants.asteroidSize.height
        )
        enemy.setupNode(at: position)
        enemy.startActions()

        return enemy
    }

    private func startEnemiesCreation() {
        // Create asteroid and add it to scene
        let creatAction = SKAction.run { [weak self] in
            guard let enemy = self?.createEnemy() else { return }
            self?.addChild(enemy)
        }

        // 1 second / numberOfAsteroids = pause duration (because creation almost instant)
        let creationSpeed: Double = 1 / (GameLogicConstants.enemiesPerSecond * GameLogicConstants.gameSpeed)

        // The duration of the idle, in seconds
        let waitAction = SKAction.wait(forDuration: creationSpeed)

        // Create sequence of creation and wait
        let actionSequence = SKAction.sequence([creatAction, waitAction])

        // Loop it and run it
        let actionLoop = SKAction.repeatForever(actionSequence)
        self.run(actionLoop)
    }

    private func createEnemy() -> SKSpriteNode {
        let enemy = EnemySpaceshipNode()
        let position = CGPoint(
            x: CGFloat.random(in: (GameUIConstants.enemySide...(self.frame.maxX - GameUIConstants.enemySide))),
            y: self.frame.maxY + GameUIConstants.enemySize.height
        )
        enemy.setupNode(at: position)
        enemy.startActions()

        return enemy
    }

    private func deleteHiddenNodes() {
        // deleting hero's bullet nodes
        enumerateChildNodes(withName: GameLogicConstants.heroBulletName) { [weak self] bullet, stop in
            if bullet.frame.minY > self?.frame.maxY ?? 0 {
                bullet.removeFromParent()
            }
        }

        // deleting asteroid nodes
        enumerateChildNodes(withName: GameLogicConstants.asteroidName) { [weak self] asteroid, stop in
            if asteroid.frame.maxY < self?.frame.minY ?? 0 {
                asteroid.removeFromParent()
                self?.score += 1
                self?.updateScore()
            }
        }

        // deleting enemies nodes
        enumerateChildNodes(withName: GameLogicConstants.enemyName) { [weak self] enemy, stop in
            if enemy.frame.maxY < self?.frame.minY ?? 0 {
                enemy.removeFromParent()
            }
        }

        // deleting enemy's bullet nodes
        enumerateChildNodes(withName: GameLogicConstants.enemyBulletName) { [weak self] bullet, stop in
            if bullet.frame.maxY < self?.frame.minY ?? 0 {
                bullet.removeFromParent()
            }
        }
    }

    private func startBackground() {
        // Add Starfield with 3 emitterNodes for a parallax effect
        // – Stars in top layer: light, fast, big
        // – …
        // – Stars in back layer: dark, slow, small
        var emitterNode = starfieldEmitter(
            color: SKColor.lightGray,
            starSpeedY: 50,
            starsPerSecond: 1,
            starScaleFactor: 0.25
        )
        emitterNode.zPosition = -10
        self.addChild(emitterNode)

        emitterNode = starfieldEmitter(
            color: SKColor.gray,
            starSpeedY: 30,
            starsPerSecond: 2,
            starScaleFactor: 0.2
        )
        emitterNode.zPosition = -11
        self.addChild(emitterNode)

        emitterNode = starfieldEmitter(
            color: SKColor.darkGray,
            starSpeedY: 15,
            starsPerSecond: 4,
            starScaleFactor: 0.15
        )
        emitterNode.zPosition = -12
        self.addChild(emitterNode)
    }

    private func starfieldEmitter(
        color: SKColor,
        starSpeedY: CGFloat,
        starsPerSecond: CGFloat,
        starScaleFactor: CGFloat
    ) -> SKEmitterNode {

        // Determine the time a star is visible on screen
        let lifetime =  frame.size.height * UIScreen.main.scale / starSpeedY

        // Create the emitter node
        let emitterNode = SKEmitterNode()
        emitterNode.particleTexture = GameTextureConstants.starTexture
        emitterNode.particleBirthRate = starsPerSecond
        emitterNode.particleColor = SKColor.lightGray
        emitterNode.particleSpeed = starSpeedY * -1
        emitterNode.particleScale = starScaleFactor
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleLifetime = lifetime

        // Position in the middle at top of the screen
        emitterNode.position = CGPoint(x: frame.size.width/2, y: frame.size.height)
        emitterNode.particlePositionRange = CGVector(dx: frame.size.width, dy: 0)

        // Fast forward the effect to start with a filled screen
        emitterNode.advanceSimulationTime(TimeInterval(lifetime))

        return emitterNode

    }

    private func isNextPositionOk(_ nextPosition: CGPoint) -> Bool{
        (nextPosition.x - GameUIConstants.heroSide / 2) >= self.frame.minX && (nextPosition.x + GameUIConstants.heroSide / 2) <= self.frame.maxX
    }

    private func updateScore() {
        scoreLabel.text = "Score: \(score)"
    }

    private func explosion(pos: CGPoint) {
        guard let emitterNode = SKEmitterNode(fileNamed: "ExplosionParticle.sks") else { return }
        emitterNode.particlePosition = pos
        self.addChild(emitterNode)

        // Don’t forget to remove the emitter node after the explosion
        self.run(SKAction.wait(forDuration: 2)) {
            emitterNode.removeFromParent()
        }
    }

    private func kill(enemy: SKNode, at position: CGPoint) {
        explosion(pos: position)
        enemy.run(SKAction.fadeOut(withDuration: 0.3))
        enemy.removeFromParent()
        score += 2
        updateScore()
    }

    private func gameOver() {
        if self.score > 0 {

        }
        gameDelegate?.gameDidEnd(with: score)

        explosion(pos: heroSpaceship.position)
        self.heroSpaceship.run(SKAction.fadeOut(withDuration: 0.3)) {

        }
        self.score = 0
        updateScore()

    }

}


extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {

        let aMask = contact.bodyA.categoryBitMask
        let bMask = contact.bodyB.categoryBitMask

        // Hero death conditions
        if aMask == GameLogicConstants.heroCategory || bMask == GameLogicConstants.heroCategory {
            if
                (aMask == GameLogicConstants.asteroidCategory || bMask == GameLogicConstants.asteroidCategory) ||
                (aMask == GameLogicConstants.enemyCategory || bMask == GameLogicConstants.enemyCategory) ||
                (aMask == GameLogicConstants.enemyBulletCategory || bMask == GameLogicConstants.enemyBulletCategory)
            {
                gameOver()
            }
        }

        // Enemy death conditions
        if aMask == GameLogicConstants.enemyCategory || bMask == GameLogicConstants.enemyCategory {
            if aMask == GameLogicConstants.heroBulletCategory || bMask == GameLogicConstants.heroBulletCategory {

                guard let enemy = contact.bodyA.node as? EnemySpaceshipNode ?? contact.bodyB.node else { return }
                kill(enemy: enemy, at: enemy.position)
            }

        }
    }

}
