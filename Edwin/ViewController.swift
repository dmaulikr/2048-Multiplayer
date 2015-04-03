//
//  ViewController.swift
//  Edwin
//
//  Created by Vegard Solheim Theriault on 28/02/15.
//  Copyright (c) 2015 Wrong Bag. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController, GameBrainDelegate, BoardViewDelegate {

    typealias D = TileValue
    
    var gameBrain: GameBrain<ViewController>!
    var gameView:  SKView?
    var gameBoardScene: BoardView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameBrain = GameBrain<ViewController>(delegate: self, dimension: 4)
    }
    
    func setupSwipes() {
        if let gestureView = self.gameView {
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("leftSwipe"))
            leftSwipe.numberOfTouchesRequired = 1
            leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
            gestureView.addGestureRecognizer(leftSwipe)
        }
        
        if let gestureView = self.gameView {
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("rightSwipe"))
            rightSwipe.numberOfTouchesRequired = 1
            rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
            gestureView.addGestureRecognizer(rightSwipe)
        }
        
        if let gestureView = self.gameView {
            let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("upSwipe"))
            upSwipe.numberOfTouchesRequired = 1
            upSwipe.direction = UISwipeGestureRecognizerDirection.Up
            gestureView.addGestureRecognizer(upSwipe)
        }
        
        if let gestureView = self.gameView {
            let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("downSwipe"))
            downSwipe.numberOfTouchesRequired = 1
            downSwipe.direction = UISwipeGestureRecognizerDirection.Down
            gestureView.addGestureRecognizer(downSwipe)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Geometry is set inside here
        
        let gameViewFrame = CGRectMake(0,
            self.view.frame.size.height - self.view.frame.size.width,
            self.view.frame.size.width,
            self.view.frame.size.width)

        if self.gameView == nil {
            self.gameView = SKView(frame: gameViewFrame)
            self.view.addSubview(self.gameView!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let gameView = self.gameView {
            self.gameBoardScene = BoardView(sizeOfBoard: gameView.frame.size, dimension: 4)
            self.gameBoardScene?.gameViewDelegate = self

            self.gameView?.presentScene(self.gameBoardScene)
            
            self.setupSwipes()
            
            self.gameBrain.startGame()
        }
    }

    
    
    
    // -------------------------------
    // MARK: Swipes
    // -------------------------------
    
    func leftSwipe() {
        if let gameBoardScene = self.gameBoardScene {
            if (gameBoardScene.isDoneAnimating()) {
                MWLog("Done animating so ready to accept new swipe")
                self.gameBrain.moveInDirection(MoveDirection.Left)
            } else {
                MWLog("Not done animating yet")
            }
        }
    }
    
    func rightSwipe() {
        if let gameBoardScene = self.gameBoardScene {
            if (gameBoardScene.isDoneAnimating()) {
                MWLog("Done animating so ready to accept new swipe")
                self.gameBrain.moveInDirection(MoveDirection.Right)
            } else {
                MWLog("Not done animating yet")
            }
        }
    }
    
    func upSwipe() {
        if let gameBoardScene = self.gameBoardScene {
            if (gameBoardScene.isDoneAnimating()) {
                MWLog("Done animating so ready to accept new swipe")
                self.gameBrain.moveInDirection(MoveDirection.Up)
            } else {
                MWLog("Not done animating yet")
            }
        }
    }
    
    func downSwipe() {
        if let gameBoardScene = self.gameBoardScene {
            if (gameBoardScene.isDoneAnimating()) {
                MWLog("Done animating so ready to accept new swipe")
                self.gameBrain.moveInDirection(MoveDirection.Down)
            } else {
                MWLog("Not done animating yet")
            }
        }
    }
    
    
    
    
    // -------------------------------
    // MARK: Board View Delegate
    // -------------------------------
    
    func boardViewDidFinishAnimating() {
        MWLog("Setting userInteractionEnabled to true")
    }
    
    
    
    
    // -------------------------------
    // MARK: Game Brain Delegate Methods
    // -------------------------------

    func gameBrainDidProduceActions(actions: [MoveAction<D>]) {
        MWLog("actions: \(actions)")
        self.gameBoardScene?.performMoveActions(actions)
    }
    
    func gameBrainUserHasNewScore(newUserScore: Int) {
        
    }
    
    func gameBrainOpponentHasNewScore(newOpponentScore: Int) {
        
    }
    
    func gameBrainDidChangeTurnTo(currentTurn: Turn) {
        
    }
    
}

