//
//  ViewController.swift
//  Edwin
//
//  Created by Vegard Solheim Theriault on 28/02/15.
//  Copyright (c) 2015 Wrong Bag. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController, GameBrainDelegate {

    typealias D = TileValue
    
    var gameBrain: GameBrain<ViewController>!
    var gameView:  SKView?
    var gameBoardScene: BoardView<TwosPowerView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameBrain = GameBrain<ViewController>(delegate: self, dimension: 4)
    }
    
    func setupSwipes() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("leftSwipe"))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        if let gestureView = self.gameView {
            gestureView.addGestureRecognizer(leftSwipe)
        }
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("rightSwipe"))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        if let gestureView = self.gameView {
            gestureView.addGestureRecognizer(rightSwipe)
        }
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("upSwipe"))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.Up
        if let gestureView = self.gameView {
            gestureView.addGestureRecognizer(upSwipe)
        }
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("downSwipe"))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.Down
        if let gestureView = self.gameView {
            gestureView.addGestureRecognizer(downSwipe)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let gameViewFrame = CGRectMake(0,
            self.view.frame.size.height - self.view.frame.size.width,
            self.view.frame.size.width,
            self.view.frame.size.width)

        if self.gameView == nil {
            self.gameView = SKView(frame: gameViewFrame)
            self.view.addSubview(self.gameView!)
            
            self.gameBoardScene = BoardView<TwosPowerView>(size: gameViewFrame.size, dimension: 4)
            self.gameView?.presentScene(self.gameBoardScene)
            
            self.setupSwipes()
            
            self.gameBrain.startGame()
        }
    }

    
    
    
    // -------------------------------
    // MARK: Swipes
    // -------------------------------
    
    func leftSwipe() {
        println("Left")
        self.gameBrain.moveInDirection(MoveDirection.Left)
    }
    
    func rightSwipe() {
        println("Right")
        self.gameBrain.moveInDirection(MoveDirection.Right)
    }
    
    func upSwipe() {
        println("Up")
        self.gameBrain.moveInDirection(MoveDirection.Up)
    }
    
    func downSwipe() {
        println("Down")
        self.gameBrain.moveInDirection(MoveDirection.Down)
    }
    
    
    
    
    // -------------------------------
    // MARK: Game Brain Delegate Methods
    // -------------------------------

    func gameBrainDidPerformActions(actions: [MoveAction<D>]) {
        
    }
    
    func gameBrainUserHasNewScore(newUserScore: Int) {
        
    }
    
    func gameBrainOpponentHasNewScore(newOpponentScore: Int) {
        
    }
    
    func gameBrainDidChangeTurnTo(currentTurn: Turn) {
        
    }
    
}

