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
    
    // we use Nodes instead of labels because they move and don't stay static
    var logo: SKLabelNode! // logo label reference
    var highScore: SKLabelNode! // high Score reference
    var btnPlay: SKShapeNode! // play Button reference
    var game: GameManager! // instance of our GameManager.swift class
    var score: SKLabelNode! // current score node
    var snakePosition: [(Int, Int)] = [] // array of cells that make up our Snake, increases with each target hit
    var gameBackground: SKShapeNode! // background
    var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = [] // array of nodes and coordinates
    var targetPosition: CGPoint? // the point that the snake needs to hit to increase score
    
    
    override func didMove(to view: SKView) {
        // initialize menu, game, and game View
        createMenu();
        game = GameManager(scene: self); // initialize gameManager class and set to local variable
        createGameView();
        
        // UI GestureRecognizers for controlling the snake
        let rightSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight));
        rightSwipe.direction = .right;
        view.addGestureRecognizer(rightSwipe);
        let leftSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft));
        leftSwipe.direction = .left;
        view.addGestureRecognizer(leftSwipe);
        let upSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp));
        upSwipe.direction = .up;
        view.addGestureRecognizer(upSwipe);
        let downSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown));
        downSwipe.direction = .down;
        view.addGestureRecognizer(downSwipe);
    }
    
    // IBO Actions for each swipe direction (objc = objective-C function for use with the #selector function in didMove)
    // each calls the gameManager's handleSwipe function with a direction parameter (corresponds to the same direction numbers as gameManager's direction variable)
    @objc func swipeRight() {
        game.handleSwipe(swipeDirection: 3);
    }
    @objc func swipeLeft() {
        game.handleSwipe(swipeDirection: 1);
    }
    @objc func swipeUp() {
        game.handleSwipe(swipeDirection: 2);
    }
    @objc func swipeDown() {
        game.handleSwipe(swipeDirection: 4);
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // call the gameManager update function to update
        game.update(time: currentTime);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                // start the Game when the big play button is clicked
                if node.name == "btnPlay" {
                    startGame()
                }
            }
        }
    }

    private func createMenu() {
        // Create the logo node for Snake
        logo = SKLabelNode()
        logo.zPosition = 1
        // position is 200 px bel
        logo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        logo.fontSize = 60
        logo.text = "SNAKE"
        logo.fontColor = SKColor.red // make labels RED
        self.addChild(logo) // add to the gameScene
        
        // Create the triangular play button to start the game
        btnPlay = SKShapeNode()
        btnPlay.name = "btnPlay"
        btnPlay.zPosition = 1
        btnPlay.position = CGPoint(x: 0, y: logo.position.y - 500)
        btnPlay.fillColor = SKColor.red
        let path = CGMutablePath(); // path to add our lines to
        path.addLine(to: CGPoint(x: -50, y: 50)) // top corner of our starting point for drawing the triangular play button
        path.addLines(between: [CGPoint(x: -50, y: 50), CGPoint(x: -50, y: -50), CGPoint(x: 50, y: 0)]) // draws the triangle lines
        btnPlay.path = path;
        self.addChild(btnPlay) // add to the gameScene
        
        // Create the high score label node
        highScore = SKLabelNode()
        highScore.zPosition = 1
        highScore.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        highScore.fontSize = 40
        highScore.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "highScore")); // load high score into high score label
        highScore.fontColor = SKColor.red
        self.addChild(highScore) // add to the gameScene
    }
    
    
    private func startGame() {
        print("Start the Snake Game!") // output to console that the play button has been clicked
        // did some research to find that the Node.run() function can make trainsitions moving nodes around so there is a smooth transition when starting the game
        logo.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
            self.logo.isHidden = true // hide logo once game starts
        }
        btnPlay.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.btnPlay.isHidden = true // hide play button once game starts
        }
        // set a point 20px above the bottom of the screen to move the highScore label to
        let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 20)
        highScore.run(SKAction.move(to: bottomCorner, duration: 0.4))
        
        highScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
            self.gameBackground.setScale(0)
            self.score.setScale(0)
            self.gameBackground.isHidden = false // don't hide high score label node, but move it to the bottom of the screen
            self.score.isHidden = false // show the previously hidden current score label node
            self.gameBackground.run(SKAction.scale(to: 1, duration: 0.4))
            self.score.run(SKAction.scale(to: 1, duration: 0.4))
            
            // start the game by calling the GameManager startGame() function
            self.game.startGame();
        }
    }
    
    
    private func createGameView() {
        // initalize current score label and place at the bottom of the screen 40px above the high score label
        score = SKLabelNode()
        score.zPosition = 1
        score.position = CGPoint(x: 0, y: (frame.size.height / -2) + 60)
        score.fontSize = 40
        score.isHidden = true
        score.text = "Score: 0"
        score.fontColor = SKColor.red
        self.addChild(score) // addChild adds the Node to the game Scene
        
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
    
    // this function will create the playing area of cells
    private func createPlayingArea(width: Int, height: Int) {
        // need to use CGFloat instead of float because the graphics won't work with just Float => CGFloat actually converts to Double not Float
        let cellWidth: CGFloat = 27.5
        let numRows = 40
        let numCols = 20
        // doesn't work using Float or Double, need to cast to CGFLoat to create Nodes and shapes
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)
        // loop through 40 rows and 20 columns, create a 40x20 board of cells for our game playing area
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                // create a cell with size 27.5x27.5 => this value was found through trial and error to best fit the screen with a board size of 40x20 cells
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
