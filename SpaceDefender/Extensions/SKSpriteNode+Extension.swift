//
//  1.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 23.08.2023.
//

import SpriteKit

extension SKSpriteNode {

    func aspectFitToSize(fillSize: CGSize) {
        if let texture = self.texture {
            let horizontalRatio = fillSize.width / texture.size().width
            let verticalRatio = fillSize.height / texture.size().height
            let finalRatio = horizontalRatio < verticalRatio ? horizontalRatio : verticalRatio
            size = CGSize(width: texture.size().width * finalRatio, height: texture.size().height * finalRatio)
        }
    }

}
