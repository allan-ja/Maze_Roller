//
//  LevelSelectionScene.swift
//  MazeRoller
//
//  Created by Allan Jard on 10/12/2015.
//  Copyright © 2015 ErenBuyru. All rights reserved.
//


import SpriteKit

class LevelSelectionScene: SKScene {
    
    var levelButtonLayer: SKNode!
    
    var numberMazesAvailable = Constants.defaultNumberMaze
    
    private struct Constants {
        static let defaultNumberMaze = 2
        static let firstCaseXPosition = CGFloat(166)
        static let spaceBetweenCases = CGFloat(230)
    }
    
   
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor(red: 0.502, green: 0.851, blue: 1, alpha: 1.0)
        
        createLevelsButtons()
    }
    
    func createLevelsButtons() {
        levelButtonLayer = SKNode()
        self.addChild(levelButtonLayer)
        
        var nodeXPosition: CGFloat = Constants.firstCaseXPosition
        for i in 1...numberMazesAvailable {
            let node = SKSpriteNode(imageNamed: "levelIcon")
            node.position = CGPointMake(nodeXPosition, CGRectGetMidY(self.frame))
            node.zPosition = 0
            node.name = "level \(i)"
            node.userData = NSMutableDictionary()
            node.userData?.setObject("level\(i)", forKey: "level")
            
            
            let numberLabelOne = SKLabelNode(fontNamed: "Chalkduster")
            numberLabelOne.text = "\(i)"
            numberLabelOne.fontSize = 100
            numberLabelOne.position = CGPointMake(CGRectGetMidX(node.frame),CGRectGetMidY(node.frame) - node.frame.height/4)
            numberLabelOne.zPosition = 1000
            levelButtonLayer.addChild(numberLabelOne)
            
            levelButtonLayer.addChild(node)
            nodeXPosition += Constants.spaceBetweenCases
        }
        
        if numberMazesAvailable < 4 {
            for _ in numberMazesAvailable+1...4 {
                let node = SKSpriteNode(imageNamed: "levelIcon")
                node.position = CGPointMake(nodeXPosition, CGRectGetMidY(self.frame))
                node.zPosition = 0
                node.alpha = 0.5
                self.addChild(node)
                nodeXPosition += Constants.spaceBetweenCases
            }
        }
        
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if let nodeName = self.nodeAtPoint((location)).name {
               if let node = levelButtonLayer.childNodeWithName(nodeName) {
                    let scene = MazeScene(size = self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    scene.size = frame.size
                    scene.scaleMode = .AspectFit
                    
                    if let level = node.userData?.objectForKey("level") {
                        scene.userData = NSMutableDictionary()
                        scene.userData?.setObject(level as! String, forKey: "level")
                    }
                    
                    let transition = SKTransition.fadeWithDuration(7)
                    self.view?.presentScene(scene, transition: transition)
                    //skView.presentScene(scene)
                }
            }

        }
        
    }
}
