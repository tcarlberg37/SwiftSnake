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
    var currentScore: Int = 0;
    
    init(scene: GameScene) {
        self.scene = scene;
    }
    
    func startGame() {
        // starting position of 3 squares in the middle of the playing area (20x40)
        scene.snakePosition.append((20, 10));
        scene.snakePosition.append((20, 11));
        scene.snakePosition.append((20, 12));
        makeChange();
        generateTarget();
    }
    
    // call this function every time we move the Snake
    func makeChange() {
        for (cell, x, y) in scene.gameArray {
            if contains(a: scene.snakePosition, v: (x,y)) {
                // change all cells in the gameArray where the snakePosition is to green to create the consecutive cells that is the Snake
                cell.fillColor = SKColor.green;
            } else {
                // if the snake's Position is not on a cell, make sure it is clear
                cell.fillColor = SKColor.clear;
                if scene.targetPosition != nil {
                    // x and y are flipped in cell array so compare target x to cell y and vice-versa
                    if Int((scene.targetPosition?.x)!) == y && Int((scene.targetPosition?.y)!) == x {
                        cell.fillColor = SKColor.red; // fill the cell chosen as random target point red
                    }
                }
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
    
    // randomly generate x,y coordinates within (20, 40) to make a new target point
    private func generateTarget() {
        var rand_x = CGFloat(arc4random_uniform(19));
        var rand_y = CGFloat(arc4random_uniform(39));
        // keep generating a new point if the target was generated in a position the snake is already occupying
        while contains(a: scene.snakePosition, v: (Int(rand_x), Int(rand_y))) {
            rand_x = CGFloat(arc4random_uniform(19));
            rand_y = CGFloat(arc4random_uniform(39));
        }
        scene.targetPosition = CGPoint(x: rand_x, y: rand_y); // assign the scene's target point these random coordinates
    }
    
    func update(time: Double) {
        // to slow game increase time added to newTime
        // to speed up game decrease time added to newTime (must be >0)
        if newTime == nil {
            newTime = time + 0.25;
        } else {
            if time >= newTime! {
                newTime = time + 0.25;
                updatePosition(); // update player's position each time
                updateScore();
                isGameOver(); // check if player has hit itself and game is over
                gameOverAnimation(); // end the game if isGameOver changes direction to 0
            }
        }
    }
    
    private func updatePosition() {
        var xChange = -1;
        var yChange = 0;

        switch direction {
            case 1: // left
                xChange = -1;
                yChange = 0;
                break;
            case 2: // up
                xChange = 0;
                yChange = -1;
                break;
            case 3: // right
                xChange = 1;
                yChange = 0;
                break;
            case 4: // down
                xChange = 0;
                yChange = 1;
                break;
            case 0: // game over
                xChange = 0;
                yChange = 0;
                break;
            default:
                break;
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
    
    private func updateScore() {
        if scene.targetPosition != nil {
            // if the snake and the target position overlap, we've hit the target! increase score, make new target and increase snake length
            if Int((scene.targetPosition?.x)!) == scene.snakePosition[0].1 && Int((scene.targetPosition?.y)!) == scene.snakePosition[0].0 {
                currentScore += 1; // increase score when the snake hits a target cell
                scene.score.text = "Score: " + String(currentScore);
                generateTarget(); // generate new target block
                // increase snake length by 2 at the tail by adding to snakePosition array
                scene.snakePosition.append(scene.snakePosition.last!);
                scene.snakePosition.append(scene.snakePosition.last!);
             }
         }
    }
    
    private func isGameOver() {
        if scene.snakePosition.count > 0 {
            var positionArray = scene.snakePosition;
            let head = positionArray[0]; // head of the snake is the first cell in the snakePosition array
            positionArray.remove(at: 0);
            if contains(a: positionArray, v: head) {
                direction = 0; // player has hit part of its body and game is over
            }
        }
    }
    
    private func gameOverAnimation() {
        if direction == 0 && scene.snakePosition.count > 0 {
            var gameOver = true;
            let head = scene.snakePosition[0]
            // check if snake head has collided with any other part of the snake, end game if so
            for position in scene.snakePosition {
                if head != position {
                    gameOver = false;
                }
             }
             if gameOver {
                print("GAME OVER");
                updateHighScore();
                direction = 1; // reset player direction for new game
                scene.targetPosition = nil; // don't create any more targets
                scene.snakePosition.removeAll() // delete all snake cells
                makeChange(); // render the snake cells removing
                // return to main menu with the same animation that started the game
                scene.score.run(SKAction.scale(to: 0, duration: 0.4)) {
                    self.scene.score.isHidden = true;
                }
                // the run function does animated movement
                scene.gameBackground.run(SKAction.scale(to: 0, duration: 0.4)) {
                    self.scene.gameBackground.isHidden = true; // hide the game board
                    self.scene.logo.isHidden = false;
                    // move the logo to its original position
                    self.scene.logo.run(SKAction.move(to: CGPoint(x: 0, y: (self.scene.frame.size.height / 2) - 200), duration: 0.4)) {
                            // move the play button back into the middle of the screen
                            self.scene.btnPlay.isHidden = false;
                            self.scene.btnPlay.run(SKAction.scale(to: 1, duration: 0.3));
                            self.scene.highScore.run(SKAction.move(to: CGPoint(x: 0, y: self.scene.logo.position.y - 50), duration: 0.3));
                       }
                  }
              }
         }
    }
    
    private func updateHighScore() {
         if currentScore > UserDefaults.standard.integer(forKey: "highScore") {
            UserDefaults.standard.set(currentScore, forKey: "highScore"); // set the high score to the current game score if the current game score is > the userDefaults saved high score
         }
         // reset current score
         currentScore = 0;
         scene.score.text = "Score: 0";
         scene.highScore.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "highScore")); // set high score text
    }
}
