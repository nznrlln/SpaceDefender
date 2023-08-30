//
//  GameViewController.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 01.08.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        /// Т.к. storyboard не существует - надо создать skView
        let skView = SKView(frame: view.frame)
        view = skView

        if let view = view as? SKView {
            // Create the scene programmatically
            let scene = GameScene(size: view.bounds.size)
            scene.gameDelegate = self

            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true

            // Present the scene
            view.presentScene(scene)
        }

    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: GameSceneDelegate {
    func gameDidEnd(with score: UInt) {
        let score = ScoreModel(
            spaceshipModel: UserDefaultsManager.shared.currentSpaceshipModel,
            userNickname: UserDefaultsManager.shared.currentUserNickname,
            userScore: score
        )
        UserDefaultsManager.shared.scores.append(score)

        navigationController?.popToRootViewController(animated: true)
    }
    
}
