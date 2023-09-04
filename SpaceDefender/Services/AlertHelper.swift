//
//  AlertHelper.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 04.09.2023.
//

import UIKit

final class AlertHelper {

    static func showGameOverAlert(
        score: String,
        restartCompletion: @escaping (() -> Void),
        menuCompletion: @escaping (() -> Void)
    )  -> UIAlertController {
        let alertController = UIAlertController(title: "Game over", message: score, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Try Again", style: .default) { action in
            restartCompletion()
        }
        let menuAction = UIAlertAction(title: "Main Menu", style: .cancel) { action in
            menuCompletion()
        }

        alertController.addAction(restartAction)
        alertController.addAction(menuAction)

        return alertController
    }

}
