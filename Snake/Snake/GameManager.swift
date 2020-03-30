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
    var newTime: Double?
    var direction: Int = 1; // (1 = left, 2 = up, 3 = right, 4 = down)
    
    init(scene: GameScene) {
        self.scene = scene;
    }
    
    func startGame() {
        // starting position of 3 squares in the middle of the playing area (20x40)
        scene.snakePosition.append((20, 10))
        scene.snakePosition.append((20, 11))
        scene.snakePosition.append((20, 12))
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
        for (v1, v2) in a {
            // check if the coordinates v given are in the array of coordinates a
            if v1 == c1 && v2 == c2 {
                return true
            }
        }
        return false
    }
    
    func update(time: Double) {
        // increase time each update
        // to slow game increase time added to newTime
        // to speed up game decrease time added to newTime (must be >0)
        if newTime == nil {
            newTime = time + 0.25;
        } else {
            if time >= newTime! {
                newTime = time + 0.25;
                updatePosition(); // update player's position each time
            }
        }
    }
    
    private func updatePosition() {
        var xChange = -1;
        var yChange = 0;

        switch direction {
            case 1: // left
                xChange = -1
                yChange = 0
                break
            case 2: // up
                xChange = 0
                yChange = -1
                break
            case 3: // right
                xChange = 1
                yChange = 0
                break
            case 4: // down
                xChange = 0
                yChange = 1
                break
            default:
                break
        }
        
        if scene.snakePosition.count > 0 {
            var snakeStart = scene.snakePosition.count - 1;
            // this loop moves all positions in the snake array forward 1 so that every cell of the snake is moved together
            while snakeStart > 0 {
                scene.snakePosition[snakeStart] = scene.snakePosition[snakeStart - 1]
                snakeStart -= 1
            }
            // move the snake head
            scene.snakePosition[0] = (scene.snakePosition[0].0 + yChange, scene.snakePosition[0].1 + xChange)
        }
        if scene.snakePosition.count > 0 {
            let x = scene.snakePosition[0].1;
            let y = scene.snakePosition[0].0;
            // wrap the snake around the screen once it goes to the edge
            // depending on which edge the snake head went through, reset snaked coords to the opposite side of the screen
            if y > 40 { // bottom of screen
                scene.snakePosition[0].0 = 0;
            } else if y < 0 { // top
                scene.snakePosition[0].0 = 40;
            } else if x > 20 { // right
                scene.snakePosition[0].1 = 0;
            } else if x < 0 { // left
                scene.snakePosition[0].1 = 20;
            }
        }
        makeChange(); // render the snake body to its new position
    }
    
    func handleSwipe(swipeDirection: Int) {
        // make sure that the swipe is not the exact opposite direction of movement
        // the player can only turn left or right, not 180
        if !(swipeDirection == 2 && direction == 4) && !(swipeDirection == 4 && direction == 2) {
            if !(swipeDirection == 1 && direction == 3) && !(swipeDirection == 3 && direction == 1) {
                direction = swipeDirection;
            }
        }
    }
}
