//
//  Piece.swift
//  SushiNeko
//
//  Created by Alan on 6/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Piece: CCNode {
    weak var left: CCSprite!
    weak var right: CCSprite!
    
    var side: Side = .None {
        didSet {
            left.visible = false
            right.visible = false
            if side == .Right {
                right.visible = true
            } else if side == .Left {
                left.visible = true
            }
        }
    }
    func setObstacle(lastSide: Side) -> Side {
        if lastSide == .None {
            var whichSide = CCRANDOM_0_1()
            if whichSide < 0.45 {
                side = .Left
            } else if whichSide < 0.90 {
                side = .Right
            } else {
                side = .None
            }
        }
        else {
            side = .None
        }
        return side
    }
}
