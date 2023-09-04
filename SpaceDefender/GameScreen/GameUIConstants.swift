//
//  GameUIConstants.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 17.08.2023.
//

import UIKit

enum GameUIConstants {

    // MARK: - Hero
    static let heroInset: CGFloat = 30
    static let heroSide: CGFloat = 55
    static let heroSize = CGSize(
        width: heroSide,
        height: heroSide
    )

    // MARK: - Asteroid
    static var asteroidSide: CGFloat {
        CGFloat.random(in: 15...40)
    }
    static var asteroidSize: CGSize {
        let side = asteroidSide
        return CGSize(
            width: side,
            height: side
        )
    }


    // MARK: - Enemy
    static let enemySide: CGFloat = 35
    static let enemySize = CGSize(
        width: enemySide,
        height: enemySide
    )

    // MARK: - Common objects
    static let bulletSize = CGSize(
        width: 3,
        height: 10
    )

    static var scoreInset: CGFloat {
        let window = UIApplication.shared.windows.first
        return window?.safeAreaInsets.top ?? 0
    }

}
