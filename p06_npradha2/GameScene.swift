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
    var food = Array<SKShapeNode>()

    var base = SKShapeNode()
    var controller = SKShapeNode()
    var controllerPressed = Bool()
    
    var xDist = CGFloat()
    var yDist = CGFloat()
    var positionArray = Array<CGPoint>()
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()

    
    static  let snake1Head : UInt32 = 0x1 << 1
    static  let snake1Body : UInt32 = 0x1 << 2
    static  let food : UInt32 = 0x1 << 3

    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        self.createController()
        self.backgroundColor = SKColor.white
        
        screenWidth = self.frame.width
        screenHeight = self.frame.height
        
        for i in 0...4
        {
            var circle2 = SKShapeNode()
            circle2 = self.snake()
            circle2.position.x = circle2.position.x - CGFloat(i * 15)
            circle2.position.y = screenHeight / 2
            if(i == 0)
            {
                circle2.physicsBody = SKPhysicsBody(circleOfRadius: 10)
                circle2.physicsBody?.categoryBitMask = GameScene.snake1Head
                circle2.physicsBody?.collisionBitMask = 0
                circle2.physicsBody?.contactTestBitMask = GameScene.food
                circle2.physicsBody?.affectedByGravity = false
                circle2.physicsBody?.isDynamic = false
                circle2.zPosition = 1
            }
            else{
                circle2.physicsBody = SKPhysicsBody(circleOfRadius: 10)
                circle2.physicsBody?.categoryBitMask = GameScene.snake1Body
                circle2.physicsBody?.collisionBitMask = 0
                circle2.physicsBody?.contactTestBitMask = 0
                circle2.physicsBody?.affectedByGravity = false
                circle2.physicsBody?.isDynamic = false
                circle2.zPosition = 1
            }
            
            snake1.append(circle2)
        }


        
        for _ in 0...1
        {
            var snakeFood = SKShapeNode()
            snakeFood = self.foodCreate()
            snakeFood.position.x = CGFloat(randomValue(min: 20, max: screenWidth - 20))
            snakeFood.position.y = CGFloat(randomValue(min: 20, max: screenHeight - 20))
            
            snakeFood.physicsBody = SKPhysicsBody(circleOfRadius: 10)
            snakeFood.physicsBody?.categoryBitMask = GameScene.food
            snakeFood.physicsBody?.collisionBitMask = 0
            snakeFood.physicsBody?.contactTestBitMask = GameScene.snake1Head
            snakeFood.physicsBody?.affectedByGravity = false
            snakeFood.physicsBody?.isDynamic = false
            snakeFood.zPosition = 1
            
            food.append(snakeFood)

        }
        
        //NSLog("%d", snake1.count)
        if(!snake1.isEmpty)
        {
            NSLog("adding snake")
            for i in 0...snake1.count-1
            {
               // if(i == 0)
               // {
                //    self.addChild(snake1[i])
               // }
               // else
               // {
                    self.addChild(snake1[i])
                  //  let rangeToSprite = SKRange(lowerLimit: 15.0, upperLimit: 15.0)
                    
                //    let distanceConstraint = SKConstraint.distance(rangeToSprite, to: snake1[i-1])
                   // let rangeForOrientation = SKRange(lowerLimit: CGFloat(M_2_PI*7), upperLimit: CGFloat(M_2_PI*7))
                    
                   // let orientConstraint = SKConstraint.orient(to: snake1[i-1], offset: rangeForOrientation)
//                    snake1[i].constraints = [orientConstraint, distanceConstraint]
               // }
            }
        }
        
        if(!food.isEmpty)
        {
            for x in 0...food.count-1
            {
                self.addChild(food[x])
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
    
    func foodCreate() -> SKShapeNode
    {
        let foodCircle = SKShapeNode(circleOfRadius: 10)
        foodCircle.position = CGPoint(x: 250, y:100)
        foodCircle.fillColor = SKColor.green
        foodCircle.strokeColor = SKColor.brown
        
        return foodCircle;
    }
    
    func randomNumber(min : Int, max : Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
    
    //random value between starting and ending value
    func randomValue() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func randomValue(min : CGFloat, max : CGFloat) -> CGFloat
    {
        return randomValue() * (max - min) + min
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
        for i in 0...snake1.count - 1
        {
            positionArray.append(snake1[i].position)
        }
        
        //move head in the direction of controller
        if(controllerPressed)
        {
            snake1[0].position = CGPoint(x:snake1[0].position.x - xDist / 5, y:snake1[0].position.y + yDist / 5)
        }
        else
        {
            snake1[0].position = CGPoint(x:snake1[0].position.x + 4, y:snake1[0].position.y)
        }
        
        //change position of body to new position
        for i in 1...snake1.count - 1{
            let moveAction = SKAction.move(to: positionArray[i-1], duration: 0.05)
            snake1[i].run(moveAction)
        }
        positionArray.removeAll()
        
        //if snake head touches screen boundries
        if(snake1[0].position.y < 0){
            snake1[0].position = CGPoint(x:snake1[0].position.x - xDist / 5, y:0)
        }
        if(snake1[0].position.y > self.frame.size.height){
            snake1[0].position = CGPoint(x:snake1[0].position.x - xDist / 5, y:screenHeight)
        }
        
        if(snake1[0].position.x < 0){
            snake1[0].position = CGPoint(x:0, y:snake1[0].position.y + yDist / 5)
        }
        if(snake1[0].position.x > self.frame.size.width){
            snake1[0].position = CGPoint(x:screenWidth, y:snake1[0].position.y + yDist / 5)
        }
        
        updateScore()
        
     }
    
    func updateScore()
    {
        //checking if food was eaten
        for x in 0...food.count-1
        {
            //print(snake1[0].position)
            //print("Food")
            //print(food[x].position)
            
            //The below way works but need to handle more cases...
            
//            if((snake1[0].position.x >= food[x].position.x-CGFloat(1) && snake1[0].position.x <= food[x].position.x+CGFloat(1)) && (snake1[0].position.y >= food[x].position.y-CGFloat(1) && snake1[0].position.y >= food[x].position.y+CGFloat(1)))
            
            if(snake1[0].position == food[x].position)
            {
                print("Food Eaten")
                food[x].position = CGPoint(x: randomValue(min: 20, max: screenWidth - 20), y: randomValue(min: 20, max: screenHeight - 20))
                
                for i in 2...snake1.count-1
                {
                    if(snake1[i].position == food[x].position)
                    {
                        food[x].position = CGPoint(x: randomValue(min: 20, max: screenWidth - 20), y: randomValue(min: 20, max: screenHeight - 20))
                    }
                    else
                    {
                        break
                    }
                }
            }
        }
        
    }
    
    
}
