//
//  GameScene.swift
//  MazeRoller
//
//  Created by Eren Buyru on 02/12/15.
//  Copyright (c) 2015 ErenBuyru. All rights reserved.
//

import SpriteKit
import CoreMotion


enum CollisionTypes: UInt32 {
    case Hero = 1
    case Wall = 2
    case Token = 4
    case Finish = 8
    //add vortex token enum
}

class GameScene: SKScene {
    var hero = SKSpriteNode!()
    var spriteView = SKView!()
    
    var wallSize: CGSize {
        let width = CGRectGetWidth(self.frame) / 32
        let height = CGRectGetHeight(self.frame) / 24
        print(width, height)
        return CGSize(width: width, height: height)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        spriteView = view
        constructScene()
        //createPlayer()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    func createPlayer() {
        hero = SKSpriteNode(imageNamed: "ball")
        hero.physicsBody = SKPhysicsBody(circleOfRadius: hero.size.width / 2)
        hero.physicsBody?.categoryBitMask = CollisionTypes.Hero.rawValue
        hero.physicsBody?.collisionBitMask = CollisionTypes.Wall.rawValue
        hero.physicsBody?.contactTestBitMask = CollisionTypes.Token.rawValue | CollisionTypes.Finish.rawValue
        
        
        hero.position = CGPoint(x: 64, y: 640)
        
        addChild(hero)
        
    }
    
    func constructScene() {
        self.backgroundColor = UIColor.whiteColor()
        
        if let scenePath = NSBundle.mainBundle().pathForResource("level2", ofType: "txt"){
            if let levelString = try? NSString(contentsOfFile: scenePath, encoding: NSUTF8StringEncoding){
                let lines = levelString.componentsSeparatedByString("\n") as [String]
                
                for (row,line) in lines.reverse().enumerate() {
                    let line2 = line.characters
                    var numberColumn = 0
                    for (column,letter) in line2.enumerate() {
                        print(++numberColumn)
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
                            
                        } else if letter == "s"{
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
                        }//end of if letter s
                        else if letter == "f"{
                            //load finish point
                            
                        }//end of if letter f
                    }//end of letter load
                }
            }
        }//end of if scenePath
    }
    
}
