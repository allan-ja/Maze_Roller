//
//  MazeScene.swift
//  MazeRoller
//
//  Created by Eren Buyru on 05/12/15.
//  Copyright © 2015 ErenBuyru. All rights reserved.
//


import SpriteKit
import CoreMotion


enum CollisionTypes: UInt32 {
    case Hero = 1
    case Wall = 2
    case Token = 4
    case Vortex = 32
    case Finish = 8
    case Start = 16
    
}

class MazeScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - Variables
    
    var highScoreLabel: SKLabelNode!
    var highscore = 0
    
    var tokenCounter:Int = 0
    
    var hero: SKSpriteNode!
    var motionManager: CMMotionManager!
    var gameOver = false
    var gamePaused = false {
        didSet {
            if (gamePaused) {
                didPauseGame()
            } else {
                willResumeGame()
            }
        }
    }
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    
    var skView: SKView!
    var timer: NSTimer?
    var seconds: Int = 0
    
    var timeLabel: SKLabelNode!
    var gameLayer: SKEffectNode!
    var menuLayer: SKNode!
    let stopButton = SKSpriteNode(imageNamed: "stopbutton")
    let pauseButton = SKSpriteNode(imageNamed: "pausebutton")
    
    var wallSize: CGSize {
        return CGSize(width: 32, height: 32)
    }
    
    var startingPosition: CGPoint?
    var notificationCenter: NSNotificationCenter!
    
    var currentLevel: String = "level1"
    
    // MARK: - SKScene Functions
    override func didMoveToView(view: SKView) {
        
        /* Setup scene here */
        
        createNodeLayers()
        createScene()
        createScoreLabel()
        createTimerLabel()
        createHero()
        
        registerAppTransitionObservers()
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy:0)
        
        motionManager = CMMotionManager()
        motionManager.startDeviceMotionUpdates()
        
        
       // LoadingOverlay.shared.hideOverlayView()
        
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
            physicsWorld.gravity = CGVector(dx: motionData.gravity.y * -25, dy: motionData.gravity.x * 25 )
        }
        
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
        if(!gamePaused){
            if(seconds >= 0)
            {
                seconds++;
                updateTimeLabel();
            }
        }
        
    }
    
    //HighScore
    
    func createHScoreLabel() {
        if NSUserDefaults.standardUserDefaults().valueForKey("Highscore") == nil{
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "Highscore")
        }
        
        highScoreLabel = SKLabelNode (fontNamed: "Arial")
        highScoreLabel.text = "Highscore: \(NSUserDefaults.standardUserDefaults().integerForKey("Highscore"))"
        highScoreLabel.horizontalAlignmentMode = .Left
        highScoreLabel.position = CGPoint(x: 350,y: 8)
        highScoreLabel.fontColor = UIColor.redColor()
        highScoreLabel.zPosition = 10
        
        
        gameLayer.addChild(highScoreLabel)

    }
    
    func updateHighScore(){
        NSUserDefaults.standardUserDefaults().integerForKey("Highscore")
        if score > NSUserDefaults.standardUserDefaults().integerForKey("Highscore") {
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "Highscore")
            NSUserDefaults.standardUserDefaults().synchronize()
            //highScoreLabel.text = "Highscore: \(score)"
    }
    
    NSUserDefaults.standardUserDefaults().integerForKey("Highscore")
    }

    
    // MARK: - Game State Functions
    func didPauseGame() {
        
        pauseButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        menuLayer.addChild(pauseButton)
        
        // Active Blur Effect
        //gameLayer.shouldEnableEffects = true
        //gameLayer.shouldRasterize = true
        
       
        physicsWorld.speed = 0
    
        gameLayer.paused = true

    }
    
    func willResumeGame() {
        // Disable Blur Effect
        //gameLayer.shouldEnableEffects = false
        menuLayer.removeAllChildren()
        
        gameLayer.paused = false
        
        physicsWorld.speed = 1
    }
    
    // MARK: - Init Functions
    func createHero() {
        hero = SKSpriteNode(imageNamed: "ball")
        hero.physicsBody = SKPhysicsBody(circleOfRadius: hero.size.width / 2)
        hero.physicsBody?.categoryBitMask = CollisionTypes.Hero.rawValue
        hero.physicsBody?.collisionBitMask = CollisionTypes.Wall.rawValue
        hero.physicsBody?.contactTestBitMask = CollisionTypes.Token.rawValue | CollisionTypes.Finish.rawValue
        hero.physicsBody?.linearDamping = 0.4
        
        if let position = startingPosition {
            hero.position = position
        }
        
        gameLayer.addChild(hero)
        
    }
    
    func createScoreLabel() {
        let barra = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeMake(800, 50))
        barra.position = CGPoint(x: CGRectGetMidX(self.frame) * 0.3, y: 8)
        // zPosition to change in which layer the barra appears.
        barra.zPosition = 9
        gameLayer.addChild(barra)
        

        
        scoreLabel = SKLabelNode (fontNamed: "Arial")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.position = CGPoint(x: 10,y: 8)
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.zPosition = 10
        gameLayer.addChild(scoreLabel)
        
    }
    
    func createTimerLabel() {
        timeLabel = SKLabelNode (fontNamed: "Arial")
        timeLabel.horizontalAlignmentMode = .Left
        timeLabel.position = CGPoint(x: 200,y: 8)
        timeLabel.fontColor = UIColor.whiteColor()
        timeLabel.zPosition = 10
        gameLayer.addChild(timeLabel)
    }
    
    func createScene() {
        self.backgroundColor = UIColor(red: 0.502, green: 0.851, blue: 1, alpha: 1.0)

        if let level = self.userData?.objectForKey("level"){
            currentLevel = level as! String
            
        }
        
        if let scenePath = NSBundle.mainBundle().pathForResource(currentLevel, ofType: "txt"){
            if let levelString = try? NSString(contentsOfFile: scenePath, encoding: NSUTF8StringEncoding){
                let lines = levelString.componentsSeparatedByString("\n") as [String]
                
                for (row,line) in lines.reverse().enumerate() {
                    let line2 = line.characters
                    for (column,letter) in line2.enumerate() {
                        
                        let position = CGPoint(x: (32 * column) + 16, y: (32 * row) + 16)
                        if letter == "x" {
                            //load wall
                            let node = SKSpriteNode(imageNamed: "wallBrick")
                            //let node = SKSpriteNode(color: UIColor.grayColor(), size: wallSize)
                            node.position = position
                            node.zPosition = 0
                            node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
                            node.physicsBody?.categoryBitMask = CollisionTypes.Wall.rawValue
                            node.physicsBody?.dynamic = false
                            
                            gameLayer.addChild(node)
                            
                        } else if letter == "s" {
                            //load star point token
                            let node = SKSpriteNode(imageNamed: "star")
                            node.name = "token"
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody?.dynamic = false
                            
                            node.physicsBody?.categoryBitMask = CollisionTypes.Token.rawValue
                            node.physicsBody?.collisionBitMask = 0
                            node.physicsBody?.contactTestBitMask = CollisionTypes.Hero.rawValue
                            self.tokenCounter++
                            node.position = position
                            node.zPosition = 0
                            
                            gameLayer.addChild(node)
                        } else if letter == "v" {
                            //load star point token
                            let node = SKSpriteNode(imageNamed: "vortex")
                            node.name = "vortex"
                            node.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)))
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 3)
                            node.physicsBody?.dynamic = false
                            
                            node.physicsBody?.categoryBitMask = CollisionTypes.Vortex.rawValue
                            node.physicsBody?.collisionBitMask = 0
                            node.physicsBody?.contactTestBitMask = CollisionTypes.Hero.rawValue
                            node.zPosition = 0
                            node.position = position
                            
                            gameLayer.addChild(node)
                        } else if letter == "f" {
                            let node = SKShapeNode(circleOfRadius: wallSize.width/1.5)
                            node.name = "finish"
                            node.fillColor = SKColor.redColor()
                            node.strokeColor = SKColor.redColor()
                            
                            
                            let fading = SKAction.fadeInWithDuration(1.0)
                            let appearing = SKAction.fadeOutWithDuration(1.0)
                            node.runAction(SKAction.repeatActionForever(SKAction.sequence([fading, appearing])))
                            
                            node.physicsBody = SKPhysicsBody(circleOfRadius: 7)
                            node.physicsBody?.dynamic = false
                            node.physicsBody?.categoryBitMask = CollisionTypes.Finish.rawValue
                            node.physicsBody?.collisionBitMask = 0
                            node.physicsBody?.contactTestBitMask = CollisionTypes.Hero.rawValue
                            
                            node.position = CGPoint(x: position.x + wallSize.width/2, y: position.y - wallSize.height/2)
                            node.zPosition = 0
                            gameLayer.addChild(node)
                            
                        } else if letter == "t" {
                            startingPosition = position
                        }
                    }
                }
            }
        }
    }
    
    func createNodeLayers() {
        gameLayer = SKEffectNode()
        gameLayer.zPosition = 0
        
        
        let blur = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius" : 10])
        gameLayer.filter = blur
        gameLayer.shouldRasterize = true
        gameLayer.shouldEnableEffects = false
        
        menuLayer = SKNode()
        menuLayer.zPosition = 50
        
        self.addChild(gameLayer)
        self.addChild(menuLayer)

        
    }
    
    func registerAppTransitionObservers() {
        notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(
            self,
            selector: "applicationWillResignActive:",
            name:UIApplicationWillResignActiveNotification,
            object: nil
        )
        
        notificationCenter.addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: "applicationDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        
    }
    
    //MARK: - Application Transistion Functions
    func applicationWillResignActive(sender : AnyObject) {
       
        if (!gamePaused) {
            gamePaused = true
        }
    }
    
    func applicationWillEnterForeground(sender : AnyObject) {
       
    }
    
    func applicationDidEnterBackground(sender : AnyObject){
        
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
        if node.name == "vortex" {
            hero.physicsBody?.dynamic = false
            gameOver = true
            if(score > 0){
                score -= 1
            }
            
            let move =  SKAction.moveTo(node.position, duration: 0.25)
            let scale = SKAction.scaleTo(0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            
            let sequance = SKAction.sequence([move,scale,remove])
            
            hero.runAction(sequance) { [unowned self] in
                self.createHero()
                self.gameOver = false
            }
        }else if node.name == "token" {
            node.removeFromParent()
            ++score
            updateHighScore()
            tokenCounter -= 1
        }else if node.name == "finish" {
            
            if let pause = self.view?.paused {
                self.view?.paused = !pause
            }
            
            
            stopButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - stopButton.frame.height)
            
            menuLayer.addChild(stopButton)
            
            let finishLabel = SKLabelNode(fontNamed: "Chalkduster")
            finishLabel.text = "CONGRATULATION"
            
            finishLabel.fontSize = 90
            finishLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) + (self.frame.height/4))
            finishLabel.zPosition = 1000
            menuLayer.addChild(finishLabel)
            
            // Active Blur Effect
            gameLayer.shouldEnableEffects = true
            gameLayer.shouldRasterize = true
            
            
            physicsWorld.speed = 0
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if gamePaused == false {
            gamePaused = true
        }
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.pauseButton {
                gamePaused = false
            
            } else if self.nodeAtPoint(location) == self.stopButton {
                let scene = GameScene(size = self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.size = frame.size
                scene.scaleMode = .AspectFit
                skView.presentScene(scene)
            }
            
        }
    }
   
}
