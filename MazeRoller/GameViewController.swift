//
//  GameViewController.swift
//  MazeRoller
//
//  Created by Eren Buyru on 02/12/15.
//  Copyright (c) 2015 ErenBuyru. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class GameViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
           }
    override func viewDidLoad() {
        super.viewDidLoad()

        //seedPerson()
        //fetch()
        
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
    
   /* func fetch() {
        let personFetch = NSFetchRequest(entityName: "Person")
        
        do{
            let fetchPerson = try moc.executeFetchRequest(personFetch) as! [Person]
            print(fetchPerson.first!)
        } catch {
            fatalError("Bad things happened")
            
        }
    }
    
    func seedPerson() {
        
        print("seedPerson")
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: moc) as! Person
        
        entity.setValue("Bob", forKey: "name")
        
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }*/
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
