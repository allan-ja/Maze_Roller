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
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.playbutton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(playbutton)
        
        self.backgroundColor = UIColor(colorLiteralRed: 255, green: 255, blue: 255, alpha: 0)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playbutton {
                let scene = MazeScene(size = self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.size = skView.bounds.size
                skView.presentScene(scene)
                
            }
            
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

}
