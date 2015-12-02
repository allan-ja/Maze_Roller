//
//  GameScene.swift
//  MazeRoller
//
//  Created by Eren Buyru on 02/12/15.
//  Copyright (c) 2015 ErenBuyru. All rights reserved.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case Hero = 1
    case Wall = 2
    case Vortex = 8
    case Finish = 16
    //add vortex token enum
}

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
       
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func constructScene() {
        if let scenePath = NSBundle.mainBundle().pathForResource("level1", ofType: "txt"){
            if let levelString = try? NSString(contentsOfFile: scenePath, encoding: NSUTF8StringEncoding){
                let lines = levelString.componentsSeparatedByString("\n") as [String]
                
                for (row,line) in lines.reverse().enumerate() {
                    let line2 = line.characters
                    for (column,letter) in line2.enumerate() {
                        let position = CGPoint(x: (32 * column) + 16 ,y: (32 * row) + 16)
                        
                        if letter == "x" {
                            //load wall
                            let node = SKSpriteNode(imageNamed: "wall")
                            node.position = position
                            
                            node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
                            node.physicsBody?.categoryBitMask = CollisionTypes.Wall.rawValue
                            node.physicsBody?.dynamic = false
                            
                            addChild(node)
                            
                        }else if letter == "v"{
                            //load vortex
                        }//end of if letter v
                    }//end of letter load
                }
            }
        }//end of if scenePath
    }
    
}
