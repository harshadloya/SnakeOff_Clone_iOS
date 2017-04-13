//
//  GameScene.swift
//  p06_npradha2
//
//  Created by Nimesh on 4/6/17.
//  Copyright © 2017 npradha2. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var circle = SKShapeNode()

    var snake1 = Array<SKShapeNode>()

    var base = SKShapeNode()
    var controller = SKShapeNode()
    var controllerPressed = Bool()
    
    var xDist = CGFloat()
    var yDist = CGFloat()
    var positionArray = Array<CGPoint>()

    
    static  let snake1Head : UInt32 = 0x1 << 1
    static  let snake1Body : UInt32 = 0x1 << 2

    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.createController()
        self.backgroundColor = SKColor.white
        
        for i in 0...10
        {
            var circle2 = SKShapeNode()
            circle2 = self.snake()
            circle2.position.x = circle2.position.x - CGFloat(i * 15)
            circle2.position.y = self.frame.size.height / 2
            if(i == 0){
                self.circle.physicsBody = SKPhysicsBody(circleOfRadius: 10)
                self.circle.physicsBody?.categoryBitMask = GameScene.snake1Head
                self.circle.physicsBody?.affectedByGravity = false
                self.circle.physicsBody?.isDynamic = false
            }
            else{
                self.circle.physicsBody = SKPhysicsBody(circleOfRadius: 10)
                self.circle.physicsBody?.categoryBitMask = GameScene.snake1Body
                self.circle.physicsBody?.affectedByGravity = false
                self.circle.physicsBody?.isDynamic = false
            }
            
            self.snake1.append(circle2)
        }
        
        NSLog("%d", snake1.count)
        if(!snake1.isEmpty){
            for i in 0...snake1.count-1
            {
                NSLog("adding snake")
                if(i == 0)
                {
                    self.addChild(snake1[i])
                }
                else
                {
                    self.addChild(snake1[i])
                    let rangeToSprite = SKRange(lowerLimit: 15.0, upperLimit: 15.0)
                    
                    let distanceConstraint = SKConstraint.distance(rangeToSprite, to: snake1[i-1])
                    let rangeForOrientation = SKRange(lowerLimit: CGFloat(M_2_PI*7), upperLimit: CGFloat(M_2_PI*7))
                    
                    let orientConstraint = SKConstraint.orient(to: snake1[i-1], offset: rangeForOrientation)
//                    snake1[i].constraints = [orientConstraint, distanceConstraint]
                }
            }
        }
        
        
    }
    
    func createController(){
    
        self.base = SKShapeNode(circleOfRadius: 70)
        self.base.fillColor = SKColor.darkGray
        self.base.position = CGPoint(x:100, y:100)
        self.base.alpha = 0.4
        self.addChild(base)

        self.controller = SKShapeNode(circleOfRadius: 35)
        self.controller.fillColor = SKColor.gray
        self.controller.position = self.base.position
        self.controller.alpha = 0.7
        self.addChild(controller)
    }

    func snake() -> SKShapeNode
    {
        self.circle = SKShapeNode(circleOfRadius: 10 )
        self.circle.position = CGPoint(x: 250, y:100)
        self.circle.fillColor = SKColor.cyan
        self.circle.strokeColor = SKColor.brown
        
        return self.circle;

    }
    
    func randomNumber(min : Int, max : Int) -> Int {
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
    
    func touchDown(atPoint pos : CGPoint) {
   
    }
    
    func touchMoved(toPoint pos : CGPoint) {
      
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location  = touch.location(in: self)
            if(controller.contains(location)){
                controllerPressed = true
                }
            else{
                controllerPressed = false
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        for touch in touches{
            let location = touch.location(in: self)
        
            if(controllerPressed){
            let v = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
            let angle = atan2(v.dy, v.dx)
                
            let length: CGFloat = base.frame.size.height / 5
            
             xDist = sin(angle - 1.57079633) * length
             yDist = cos(angle - 1.57079633) * length

            controller.position = CGPoint(x:base.position.x - xDist, y:base.position.y + yDist)
            
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.controller.position = self.base.position
    }
    
    override func update(_ currentTime: TimeInterval) {
        //save old position in array
        for i in 0...snake1.count - 1{
            positionArray.append(snake1[i].position)
        }
        
        //move head in the direction of controller
        if(controllerPressed){
            snake1[0].position = CGPoint(x:snake1[0].position.x - xDist / 5, y:snake1[0].position.y + yDist / 5)
        }
        else{
            snake1[0].position = CGPoint(x:snake1[0].position.x
                 + 4, y:snake1[0].position.y)
        }
        
        //change position of body to new position
        for i in 1...snake1.count - 1{
            snake1[i].position = positionArray[i - 1]
        }
        positionArray.removeAll()
        
        //if snake head touches screen boundries
        if(snake1[0].position.y < 0){
            snake1[0].position = CGPoint(x:snake1[0].position.x - xDist / 5, y:0)
        }
        if(snake1[0].position.y > self.frame.size.height){
            snake1[0].position = CGPoint(x:snake1[0].position.x - xDist / 5, y:self.frame.size.height)
        }
        
        if(snake1[0].position.x < 0){
            snake1[0].position = CGPoint(x:0, y:snake1[0].position.y + yDist / 5)
        }
        if(snake1[0].position.x > self.frame.size.width){
            snake1[0].position = CGPoint(x:self.frame.size.width, y:snake1[0].position.y + yDist / 5)
        }
      
        
     }
    
    
}
