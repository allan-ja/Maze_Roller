//
//  GameViewController.swift
//  MazeRoller
//
//  Created by Eren Buyru on 02/12/15.
//  Copyright (c) 2015 ErenBuyru. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            // skView.showsFPS = true
            // skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            //print("scence size b4", scene.size.width, scene.size.height)
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFit
            //print("scence size", scene.size.width, scene.size.height)
            
            skView.presentScene(scene)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .LandscapeRight
        } else {
            return .LandscapeRight
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
