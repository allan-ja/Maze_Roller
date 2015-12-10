//
//  GameScene.swift
//  MazeRoller
//
//  Created by Eren Buyru on 02/12/15.
//  Copyright (c) 2015 ErenBuyru. All rights reserved.
//

import SpriteKit
import CoreMotion


class GameScene: SKScene {
 
    
    let playbutton = SKSpriteNode(imageNamed: "playbutton")
    let logo = SKSpriteNode(imageNamed: "logo")
    var nameLabel: SKLabelNode!

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.playbutton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(playbutton)
        
        //createTitleLabel()
        
        self.logo.position = CGPointMake(CGRectGetMidX(self.frame) * 1,CGRectGetMaxY(self.frame) * 0.80)
        self.addChild(logo)
        
        self.backgroundColor = UIColor(red: 0.502, green: 0.851, blue: 1, alpha: 1.0)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playbutton {
                let scene = MazeScene(size = self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.size = frame.size
                scene.scaleMode = .AspectFit
                skView.presentScene(scene)
                
            }//playbutton tapped
            else if self.nodeAtPoint(location) == self.playbutton {
                //settings menu touch
               /* let scene = MazeScene(size = self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.size = skView.bounds.size
                skView.presentScene(scene)*/
            }
            
            
        }//end of for touch
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

  //add game title function
    func createTitleLabel() {
        nameLabel = SKLabelNode (fontNamed: "Arial")
        nameLabel.text = "MazeRoller"
        nameLabel.horizontalAlignmentMode = .Left
        nameLabel.position = CGPointMake(CGRectGetMidX(self.frame) * 0.85,CGRectGetMaxY(self.frame) * 0.80)
        nameLabel.fontColor = UIColor.purpleColor()
        
        addChild(nameLabel)
        
    }
    
    
}
