//
//  MazeScene.swift
//  MazeRoller
//
//  Created by Eren Buyru on 05/12/15.
//  Copyright © 2015 ErenBuyru. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion


enum CollisionTypes: UInt32 {
    case Hero = 1
    case Wall = 2
    case Token = 4
    case Finish = 8
    case Start = 16
    
}

class MazeScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - Variables
    
    var hero: SKSpriteNode!
    var motionManager: CMMotionManager!
    var gameOver = false
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    
    var timer: NSTimer?
    var seconds: Int = 0
    var timeLabel: SKLabelNode!
    
    var wallSize: CGSize {
        let width = CGRectGetWidth(self.frame) / 32
        let height = CGRectGetHeight(self.frame) / 24
        return CGSize(width: width, height: height)
    }
    
    var startingPosition: CGPoint?
    
    
    // MARK:
    override func didMoveToView(view: SKView) {
        /* Setup scene here */
        
        createScene()
        createScoreLabel()
        createTimerLabel()
        createPlayer()
        
        //physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager.startDeviceMotionUpdates()
        //motionManager.startAccelerometerUpdates()
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if !gameOver {
            //keep moving
            if(timer == nil)
            {
                timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:Selector("onUpdateTimer"), userInfo:nil, repeats:true);
            }
        }

        // deviceMotion or simple accelerometerData available
        if let motionData = motionManager.deviceMotion {
            physicsWorld.gravity = CGVector(dx: motionData.gravity.y * -25, dy: motionData.gravity.x * 25)
        }
        
        /*if let motionData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: motionData.acceleration.y * -50, dy: motionData.acceleration.x * 50)
        }*/
        
    }
    
    
    // MARK: - Timer Functions
    func updateTimeLabel()
    {
        if(timeLabel != nil)
        {
            let min:Int = (seconds / 60) % 60;
            let sec:Int = seconds % 60;
            
            let min_p:String = String(format: "%02d", min);
            let sec_p:String = String(format: "%02d", sec);
            
            timeLabel!.text = "\(min_p):\(sec_p)";
        }
    }
    
    func onUpdateTimer() {
        if(seconds >= 0)
        {
            seconds++;
            updateTimeLabel();
        }
        
    }
    //end timer code
    
    // MARK: - Create Functions
    func createPlayer() {
        hero = SKSpriteNode(imageNamed: "ball")
        hero.physicsBody = SKPhysicsBody(circleOfRadius: hero.size.width / 2)
        hero.physicsBody?.categoryBitMask = CollisionTypes.Hero.rawValue
        hero.physicsBody?.collisionBitMask = CollisionTypes.Wall.rawValue
        hero.physicsBody?.contactTestBitMask = CollisionTypes.Token.rawValue | CollisionTypes.Finish.rawValue
        
        
        hero.physicsBody?.linearDamping = 0.5
        
        if let position = startingPosition {
            hero.position = position
        }
        
        //hero.position = CGPoint(x: 64, y: 640)
        
        addChild(hero)
        
    }
    
    func createScoreLabel() {
        scoreLabel = SKLabelNode (fontNamed: "Arial")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.position = CGPoint(x: 10,y: 8)
        scoreLabel.fontColor = UIColor.redColor()
        
        addChild(scoreLabel)
        
    }
    
    func createTimerLabel() {
        timeLabel = SKLabelNode (fontNamed: "Arial")
        timeLabel.horizontalAlignmentMode = .Left
        timeLabel.position = CGPoint(x: 200,y: 8)
        timeLabel.fontColor = UIColor.redColor()
        
        addChild(timeLabel)
    }
    
    func createScene() {
        self.backgroundColor = UIColor.whiteColor()
        
        if let scenePath = NSBundle.mainBundle().pathForResource("level1", ofType: "txt"){
            if let levelString = try? NSString(contentsOfFile: scenePath, encoding: NSUTF8StringEncoding){
                let lines = levelString.componentsSeparatedByString("\n") as [String]
                
                for (row,line) in lines.reverse().enumerate() {
                    let line2 = line.characters
                    for (column,letter) in line2.enumerate() {
                        let xPosition = CGFloat(column) * wallSize.width + wallSize.width/2
                        let yPosition = CGFloat(row) * wallSize.height + wallSize.height/2
                        let position = CGPoint(x: xPosition ,y: yPosition)
                        
                        if letter == "x" {
                            //load wall
                            //let node = SKSpriteNode(imageNamed: "wall")
                            let node = SKSpriteNode(color: UIColor.grayColor(), size: wallSize)
                            node.position = position
                            
                            node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
                            node.physicsBody?.categoryBitMask = CollisionTypes.Wall.rawValue
                            node.physicsBody?.dynamic = false
                            
                            addChild(node)
                            
                        } else if letter == "s" {
                            //load star point token
                            let node = SKSpriteNode(imageNamed: "star")
                            node.name = "star"
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody?.dynamic = false
                            
                            node.physicsBody?.categoryBitMask = CollisionTypes.Token.rawValue
                            node.physicsBody?.collisionBitMask = 0
                            node.physicsBody?.contactTestBitMask = CollisionTypes.Hero.rawValue
                            
                            node.position = position
                            
                            addChild(node)
                        } else if letter == "f" {
                            let node = SKShapeNode(circleOfRadius: wallSize.width/1.5)
                            node.name = "finish"
                            node.fillColor = SKColor.blueColor()
                            
                            let fading = SKAction.fadeAlphaTo(0.1, duration: 1.0)
                            let appearing = SKAction.fadeAlphaTo(1, duration: 1.0)
                            node.runAction(SKAction.repeatActionForever(SKAction.sequence([fading, appearing])))
                            
                            node.physicsBody = SKPhysicsBody(circleOfRadius: 1)
                            node.physicsBody?.dynamic = false
                            node.physicsBody?.categoryBitMask = CollisionTypes.Finish.rawValue
                            node.physicsBody?.collisionBitMask = 0
                            node.physicsBody?.contactTestBitMask = CollisionTypes.Hero.rawValue
                            
                            node.position = CGPoint(x: position.x + wallSize.width/2, y: position.y - wallSize.height/2)
                            
                            addChild(node)
                            
                        } else if letter == "t" {
                            startingPosition = position
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Interaction Management Functions
    
    func didBeginContact(contact: SKPhysicsContact){
        if contact.bodyA.node == hero {
            heroTouchToNode(contact.bodyB.node!)
        }else if contact.bodyB.node == hero {
            heroTouchToNode(contact.bodyA.node!)
        }
    }
    
    
    func heroTouchToNode(node: SKNode) {
        if node == "vortex" {
            hero.physicsBody?.dynamic = false
            gameOver = true
            score -= 1
            
            let move =  SKAction.moveTo(node.position, duration: 0.25)
            let scale = SKAction.scaleTo(0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            
            let sequance = SKAction.sequence([move,scale,remove])
            
            hero.runAction(sequance) { [unowned self] in
                self.createPlayer()
                self.gameOver = false
            }
        }else if node.name == "star" {
            node.removeFromParent()
            ++score
        }else if node.name == "finish" {
            print("game over")
        }
    }
   
}
