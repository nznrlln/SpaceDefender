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
        startGame()
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

    deinit {
        debugPrint("GameVC deinit")
    }

    private func startGame() {
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
}

extension GameViewController: GameSceneDelegate {
    func gameDidEnd(with score: UInt) {

        if score > 1 {
            let nick = UserDefaultsManager.shared.currentUserNickname
            let scoreNick = (nick.trimmingCharacters(in: .whitespacesAndNewlines) != "") ? nick : "no name"
            let scoreModel = ScoreModel(
                spaceshipModel: UserDefaultsManager.shared.currentSpaceshipModel,
                userNickname: scoreNick,
                userScore: score
            )
            UserDefaultsManager.shared.scores.append(scoreModel)
        }

       let alert = AlertHelper.showGameOverAlert(score: "Score: \(score)") {
            self.startGame()
        } menuCompletion: {
            self.navigationController?.popToRootViewController(animated: true)
        }

        self.present(alert, animated: true)

    }
    
}
