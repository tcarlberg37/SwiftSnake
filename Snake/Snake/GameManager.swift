//
//  GameManager.swift
//  Snake
//
//  Created by Tech on 2020-03-10.
//  Copyright © 2020 Carlberg. All rights reserved.
//
// COMP3097 Mobile Apps iOS Development Final Project - SNAKE GAME
// Thomas Carlberg 101155271
// Sahara Panna 101145593

import SpriteKit

class GameManager {
    var scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene;
    }
    
    func startGame() {
        // starting position in the upper middle of the playing area
        scene.snakePosition.append((10, 10))
        scene.snakePosition.append((10, 11))
        scene.snakePosition.append((10, 12))
        makeChange()
    }
    
    // call this function every time we move the Snake
    func makeChange() {
        for (cell, x, y) in scene.gameArray {
            if contains(a: scene.snakePosition, v: (x,y)) {
                // change all cells in the gameArray where the snakePosition is to green to create the consecutive cells that is the Snake
                cell.fillColor = SKColor.green
            } else {
                // if the snake's Position is not on a cell, make sure it is clear
                cell.fillColor = SKColor.clear
            }
        }
    }
    
    func contains(a:[(Int, Int)], v:(Int,Int)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
}
