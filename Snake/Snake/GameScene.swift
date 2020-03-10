//
//  GameScene.swift
//  Snake
//
//  Created by Tech on 2020-03-10.
//  Copyright © 2020 Carlberg. All rights reserved.
//
// COMP3097 Mobile Apps iOS Development Final Project - SNAKE GAME
// Thomas Carlberg 101155271
// Sahara Panna 101145593

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var logo: SKLabelNode!
    var highScore: SKLabelNode!
    var btnPlay: SKShapeNode!
    var game: GameManager!
    var score: SKLabelNode!
    var snakePosition: [(Int, Int)] = []
    var gameBackground: SKShapeNode!
    var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = []
    
    
    override func didMove(to view: SKView) {
        createMenu();
        game = GameManager(scene: self); // initialize gameManager class and set to local variable
        createGameView();
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "btnPlay" {
                    startGame()
                }
            }
        }
    }

    private func createMenu() {
        // Create the logo for Snake
        logo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        logo.zPosition = 1
        logo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        logo.fontSize = 60
        logo.text = "SNAKE"
        logo.fontColor = SKColor.red
        self.addChild(logo)
        // Create the triangular play button to start the game
        btnPlay = SKShapeNode()
        btnPlay.name = "btnPlay"
        btnPlay.zPosition = 1
        btnPlay.position = CGPoint(x: 0, y: logo.position.y - 500)
        btnPlay.fillColor = SKColor.cyan
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        btnPlay.path = path
        self.addChild(btnPlay)
        // Create the high score label
        highScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        highScore.zPosition = 1
        highScore.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        highScore.fontSize = 40
        highScore.text = "High Score: 0"
        highScore.fontColor = SKColor.white
        self.addChild(highScore)
    }
    
    
    private func startGame() {
        print("Start the Snake Game!")
        logo.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
            self.logo.isHidden = true
        }
        btnPlay.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.btnPlay.isHidden = true
        }
        let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 20)
        highScore.run(SKAction.move(to: bottomCorner, duration: 0.4))
        
        highScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
            self.gameBackground.setScale(0)
            self.score.setScale(0)
            self.gameBackground.isHidden = false
            self.score.isHidden = false
            self.gameBackground.run(SKAction.scale(to: 1, duration: 0.4))
            self.score.run(SKAction.scale(to: 1, duration: 0.4))
            
            // start the game by calling the GameManager startGame() function
            self.game.startGame();
        }
    }
    
    
    private func createGameView() {
        score = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        score.zPosition = 1
        score.position = CGPoint(x: 0, y: (frame.size.height / -2) + 60)
        score.fontSize = 40
        score.isHidden = true
        score.text = "Score: 0"
        score.fontColor = SKColor.white
        self.addChild(score)
        
        let width = frame.size.width - 200
        let height = frame.size.height - 300
        let rectangle = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        gameBackground = SKShapeNode(rect: rectangle, cornerRadius: 0.02)
        gameBackground.fillColor = SKColor.darkGray
        gameBackground.zPosition = 2
        gameBackground.isHidden = true
        self.addChild(gameBackground)
        
        createPlayingArea(width: Int(width), height: Int(height))
    }
    
    
    private func createPlayingArea(width: Int, height: Int) {
        let cellWidth: CGFloat = 27.5
        let numRows = 40
        let numCols = 20
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)
        // loop through 40 rows and 20 columns, create a 40x20 board of cells for our game playing area
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor = SKColor.black
                cellNode.zPosition = 2
                cellNode.position = CGPoint(x: x, y: y)
                // gameArray will hold all the cells in an array so that we can easily find a specific row/column for each cell
                gameArray.append((node: cellNode, x: i, y: j))
                gameBackground.addChild(cellNode)
                // move x to next cell
                x += cellWidth
            }
            //reset x, move y to next cell
            x = CGFloat(width / -2) + (cellWidth / 2)
            y -= cellWidth
        }
    }
}
