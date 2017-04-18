//
//  GameScene.swift
//  p06_npradha2
//
//  Created by Nimesh on 4/6/17.
//  Copyright © 2017 npradha2. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var score = Int()
    var highScore = 0
    var scoreLabel = SKLabelNode()
    var scoreTextLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var highScoreTextLabel = SKLabelNode()
    
    var circle = SKShapeNode()

    var snake1 = Array<SKShapeNode>()
    var food = Array<SKShapeNode>()
    var deadSnakeFood = Array<SKShapeNode>()

    var base = SKShapeNode()
    var controller = SKShapeNode()
    var speedController = SKSpriteNode()
    var controllerPressed = Bool()
    var controllerMoved = Bool()
    var speedControllerPressed = Bool()
    var speedBooster = CGFloat()
    
    var xDist = CGFloat()
    var yDist = CGFloat()
    var positionArray = Array<CGPoint>()
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    var lost = Bool()
    var restartBtn = SKSpriteNode()
    var exitBtn = SKSpriteNode()
    var snake1DeathCount = Int()
    
    /*
    static  let snake1Head : UInt32 = 0x1 << 1
    static  let snake1Body : UInt32 = 0x1 << 2
    static  let food : UInt32 = 0x1 << 3
    */

    override func didMove(to view: SKView)
    {
        startGame()
    }
    
    func startGame()
    {

        
        screenWidth = self.frame.width
        screenHeight = self.frame.height
        
        self.createController()
        
        let background = SKSpriteNode(imageNamed: "bggrid")
        background.size = CGSize(width: screenWidth, height: screenHeight)
        background.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        background.zPosition = 1
        self.addChild(background)
        
        scoreTextLabel = createScoreLabel(name: "text")
        self.addChild(scoreTextLabel)
        
        scoreLabel = createScoreLabel(name: "number")
        self.addChild(scoreLabel)
        
        highScoreTextLabel = createScoreLabel(name: "text")
        highScoreTextLabel.text = "HighScore"
        highScoreTextLabel.position.x += 100
        self.addChild(highScoreTextLabel)
        
        highScoreLabel = createScoreLabel(name: "number")
        highScoreLabel.position.x += 100
        self.addChild(highScoreLabel)
        
        self.updateHighScoreLabel()
        speedBooster = 1.3
        
        //Creating New Snake
        self.createSnake()
        self.snake1DeathCount = 5
        
        self.controllerPressed = false
        self.controllerMoved = false
        self.speedControllerPressed = false
        
        //Creating fixed food on screen
        for _ in 0...14
        {
            var snakeFood = SKShapeNode()
            snakeFood = self.foodCreate()
            snakeFood.position.x = CGFloat(randomValue(min: 20, max: screenWidth - 20))
            snakeFood.position.y = CGFloat(randomValue(min: 20, max: screenHeight - 20))
        
            food.append(snakeFood)
        }
        
        if(!food.isEmpty)
        {
            NSLog("Adding snakefood")
            for x in 0...food.count-1
            {
                self.addChild(food[x])
            }
        }
        
    }
    
    func updateHighScoreLabel()
    {
        // get saved high score
        if(UserDefaults.standard.object(forKey: "highScore") != nil){
            highScore = UserDefaults.standard.value(forKey: "highScore") as! Int
            highScoreLabel.text = "\(highScore)"
        }
    }
    
    func createSnake()
    {
        for i in 0...4
        {
            var circle2 = SKShapeNode()
            if(i == 0)
            {
                circle2 = self.snakeHead()
            }
            else
            {
                circle2 = self.snake(type: "new")
            }
            circle2.position.x = circle2.position.x - CGFloat(i * 15)
            circle2.position.y = screenHeight / 2
            circle2.zPosition = 2
            snake1.append(circle2)
        }
        
        //NSLog("%d", snake1.count)
        if(!snake1.isEmpty)
        {
            NSLog("Adding snake")
            for i in 0...snake1.count-1
            {
                self.addChild(snake1[i])
            }
        }
    }
    
    func snakeHead() -> SKShapeNode
    {
        self.circle = SKShapeNode(circleOfRadius: 10)
        self.circle.position = CGPoint(x: 250, y:100)
        
        let outerBody = SKShapeNode(circleOfRadius: 10)
        outerBody.fillColor = SKColor.red
        outerBody.strokeColor = SKColor.red
        
        let innerBody = SKShapeNode(circleOfRadius: 7)
        innerBody.fillColor = SKColor.orange
        innerBody.strokeColor = SKColor.orange
        
        let leftEye = SKShapeNode(circleOfRadius: 2)
        leftEye.fillColor = SKColor.black
        leftEye.strokeColor = SKColor.black
        leftEye.position.x = 2
        leftEye.position.y = 7
        
        let rightEye = SKShapeNode(circleOfRadius: 2)
        rightEye.fillColor = SKColor.black
        rightEye.strokeColor = SKColor.black
        rightEye.position.x = 2
        rightEye.position.y = -7
        
        let leftEyeWhite = SKShapeNode(circleOfRadius: 3.5)
        leftEyeWhite.fillColor = SKColor.white
        leftEyeWhite.strokeColor = SKColor.black
        leftEyeWhite.position.x = 3
        leftEyeWhite.position.y = 7
        
        let rightEyeWhite = SKShapeNode(circleOfRadius: 3.5)
        rightEyeWhite.fillColor = SKColor.white
        rightEyeWhite.strokeColor = SKColor.black
        rightEyeWhite.position.x = 3
        rightEyeWhite.position.y = -7
        
        self.circle.addChild(outerBody)
        self.circle.addChild(innerBody)
        self.circle.addChild(leftEyeWhite)
        self.circle.addChild(rightEyeWhite)
        self.circle.addChild(leftEye)
        self.circle.addChild(rightEye)
        
        
        return self.circle;
        
    }
    
    func snake(type: String) -> SKShapeNode
    {
        var innerBody = SKShapeNode()
        var outerBody = SKShapeNode()
        
        if(type == "new")
        {
            self.circle = SKShapeNode(circleOfRadius: 10)
            outerBody = SKShapeNode(circleOfRadius: 10)
            innerBody = SKShapeNode(circleOfRadius: 7)
        }
        else if(type == "dead")
        {
            self.circle = SKShapeNode(circleOfRadius: 6)
            outerBody = SKShapeNode(circleOfRadius: 6)
            innerBody = SKShapeNode(circleOfRadius: 4)
        }
            
        self.circle.position = CGPoint(x: 250, y:100)
        
        outerBody.fillColor = SKColor.red
        outerBody.strokeColor = SKColor.red
        
        innerBody.fillColor = SKColor.orange
        innerBody.strokeColor = SKColor.orange
        
        self.circle.addChild(outerBody)
        self.circle.addChild(innerBody)
        return self.circle;
        
    }
    
    func createScoreLabel(name: String) -> SKLabelNode
    {
        
        let label = SKLabelNode()
        
        if name == "text"
        {
            label.position = CGPoint(x: screenWidth / 2 + screenWidth / 4, y: screenHeight / 2 + screenHeight / 2.5)
            label.text = "Score"
        }
        else if name == "number"
        {
            label.position = CGPoint(x: screenWidth / 2 + screenWidth / 4, y: screenHeight / 2 + screenHeight / 3)
            label.text = "\(score)"
        }
        label.fontColor = UIColor.black
        label.fontSize = 24
        label.zPosition = 10
        return label
    }
    
    func createController()
    {
    
        self.base = SKShapeNode(circleOfRadius: 50)
        self.base.fillColor = SKColor.darkGray
        self.base.position = CGPoint(x:100, y:70)
        self.base.alpha = 0.4
        self.base.zPosition = 3
        self.addChild(base)

        self.controller = SKShapeNode(circleOfRadius: 20)
        self.controller.fillColor = SKColor.gray
        self.controller.position = self.base.position
        self.controller.alpha = 0.7
        self.controller.zPosition = 4
        self.addChild(controller)
        
        self.speedController = SKSpriteNode(imageNamed: "speedBoost")
        self.speedController.zPosition = 4
        self.speedController.alpha = 0.4
        self.speedController.position = CGPoint(x: screenWidth - 100, y: 70)
        self.speedController.setScale(0.4)
        self.addChild(speedController)
    }

    
    
    func foodCreate() -> SKShapeNode
    {
        let foodCircle = SKShapeNode(circleOfRadius: 5)
        foodCircle.position = CGPoint(x: 250, y:100)
        foodCircle.fillColor = self.randomColor()
        foodCircle.strokeColor = SKColor.black
        foodCircle.zPosition = 2
        return foodCircle;
    }
    
    func randomColor() -> UIColor
    {
        let randomRed = randomValue(min: 0, max: 1)
        let randomGreen = randomValue(min: 0, max: 1)
        let randomBlue = randomValue(min: 0, max: 1)
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            let location  = touch.location(in: self)
            
            if(controller.contains(location))
            {
                controllerPressed = true
            }
            else
            {
                controllerPressed = false
            }
            
            if(speedController.contains(location))
            {
                speedControllerPressed = true
                speedBooster = 2.2
            }
            else
            {
                speedControllerPressed = false
                speedBooster = 1.3
            }
         
            if(lost)
            {
                if (restartBtn.contains(location))
                {
                    restartGame()
                }
                
                if (exitBtn.contains(location))
                {
                    let gameMenuScene = GameMenuScene()
                    gameMenuScene.size = (self.view?.bounds.size)!
                    gameMenuScene.scaleMode = .aspectFill
                    self.view?.presentScene(gameMenuScene)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        for touch in touches{
            let location = touch.location(in: self)
        
            if(controllerPressed)
            {
                controllerMoved = true
                let v = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
                let angle = atan2(v.dy, v.dx)
                
                let length: CGFloat = base.frame.size.height / 5
            
                xDist = sin(angle - .pi / 2.0) * length
                yDist = cos(angle - .pi / 2.0) * length

                controller.position = CGPoint(x:base.position.x - xDist, y:base.position.y + yDist)
                snake1[0].zRotation = angle
            
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
                self.controller.position = self.base.position
                self.speedBooster = 1.3
                self.speedControllerPressed = false
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if lost == true {
            return
        }
        //save old position in array
        for i in 0...snake1.count - 1
        {
            positionArray.append(snake1[i].position)
        }
        
        //move head in the direction of controller
        if(controllerMoved)
        {
            snake1[0].position = CGPoint(x:snake1[0].position.x - xDist / 5 * speedBooster, y:snake1[0].position.y + yDist / 5 * speedBooster)
        }
        else
        {
            snake1[0].position = CGPoint(x:snake1[0].position.x + 4 * speedBooster, y:snake1[0].position.y )
        }
        
        //change position of body to new position
        for i in 1...snake1.count - 1{
            let moveAction = SKAction.move(to: positionArray[i-1], duration: 0.01)
            snake1[i].run(moveAction)
        }

        //if snake head touches screen boundries
        if(snake1[0].position.y < 0){
            self.killSnake(snakeNumber: 1)
        }
        if(snake1[0].position.y > self.frame.size.height){
            self.killSnake(snakeNumber: 1)
        }
        
        if(snake1[0].position.x < 0){
            self.killSnake(snakeNumber: 1)
        }
        if(snake1[0].position.x > self.frame.size.width){
            self.killSnake(snakeNumber: 1)
        }
        
        checkFoodEaten()
        positionArray.removeAll()

     }
    
    func checkFoodEaten()
    {
        //checking if food was eaten
        for x in 0...food.count-1
        {
            if(Int(snake1[0].position.x) >= Int(food[x].position.x) - 15 &&
                Int(snake1[0].position.x) <= Int(food[x].position.x) + 15 &&
                Int(snake1[0].position.y) >= Int(food[x].position.y) - 15 &&
                Int(snake1[0].position.y) <= Int(food[x].position.y) + 15)
            {
                NSLog("Food Eaten")
                food[x].position = CGPoint(x: randomValue(min: 20, max: screenWidth - 20), y: randomValue(min: 20, max: screenHeight - 20))
                food[x].fillColor = self.randomColor()
                
                self.updateScore()
                
                self.growSnake()
            }
        }
        
        //checking if food created by dead snake was eaten
        if(!deadSnakeFood.isEmpty)
        {
            for x in 0...deadSnakeFood.count-1
            {
                if(!deadSnakeFood[x].isHidden &&
                    Int(snake1[0].position.x) >= Int(deadSnakeFood[x].position.x) - 15 &&
                    Int(snake1[0].position.x) <= Int(deadSnakeFood[x].position.x) + 15 &&
                    Int(snake1[0].position.y) >= Int(deadSnakeFood[x].position.y) - 15 &&
                    Int(snake1[0].position.y) <= Int(deadSnakeFood[x].position.y) + 15)
                {
                  //NSLog("Dead Snake Food Eaten")
                    
                    self.updateScore()
                
                    self.growSnake()
                    
                    deadSnakeFood[x].removeFromParent()
                    deadSnakeFood.remove(at: x)
                    break
                }
            }
        }
    }
    
    func updateScore(){
        score += 1
        scoreLabel.text = "\(score)"
        if(score > highScore)
        {
            highScore = score
            highScoreLabel.text = "\(highScore)"
            //store high score
            UserDefaults.standard.set(highScore, forKey: "highScore")
            UserDefaults.standard.synchronize()
        }
    }
    
    func growSnake()
    {
        var circle2 = SKShapeNode()
        circle2 = self.snake(type: "new")
        circle2.position.x = snake1[snake1.count-1].position.x
        circle2.position.y = snake1[snake1.count-1].position.y
        circle2.zPosition = 2
        snake1.append(circle2)
        self.addChild(snake1[snake1.count-1])
    }
    
    func killSnake(snakeNumber: Int)
    {
        
        if(snake1DeathCount == 0){
            self.gameOver()
        }
        else
        {
            snake1DeathCount -= 1
           
            if(snakeNumber == 1)
            {
                for i in 0...snake1.count - 1
                {
                    positionArray[i] = snake1[i].position
                    snake1[i].removeAllActions()
                    //When lost gives broken effect
                  //  snake1[i].position.x = snake1[i].position.x + randomValue(min: -10.0, max: 10.0)
                  //  snake1[i].position.y = snake1[i].position.y + randomValue(min: -10.0, max: 10.0)
                }
            }
            self.controllerMoved = false
            self.createFoodOnSnakeKill(snakeNumber: snakeNumber)
        }
    }
    
    func createFoodOnSnakeKill(snakeNumber: Int)
    {
        if(snakeNumber == 1)
        {
            for x in 0...(snake1.count - 1)
            {
                var snakeFood1 = SKShapeNode()
                
                snakeFood1 = self.snake(type: "dead")
                snakeFood1.position.x = snake1[x].position.x + randomValue(min: -15.0, max: 15.0)
                snakeFood1.position.y = snake1[x].position.y + randomValue(min: -15.0, max: 15.0)
                snakeFood1.zPosition = 2
                snakeFood1.run(SKAction.sequence([SKAction.wait(forDuration: 5.0),SKAction.fadeOut(withDuration: 10), SKAction.hide()]))
                deadSnakeFood.append(snakeFood1)
                snake1[x].removeFromParent()
            }

            snake1.removeAll()
        }
        
        if(!deadSnakeFood.isEmpty)
        {
         //   NSLog("Adding snakefood")
            for y in 0...deadSnakeFood.count-1
            {
                if(!deadSnakeFood[y].inParentHierarchy(self) && !deadSnakeFood[y].isHidden){
                    self.addChild(deadSnakeFood[y])
                }
            }
        }
        
        self.createSnake()
    }
    
    func gameOver()
    {
        lost = true
        
        let popUpMessage = SKNode()
        let popUpMessageBackground = SKSpriteNode(color: SKColor.gray, size: CGSize(width: 250, height: 40))
        let messageDisplay = SKLabelNode()
        
        popUpMessageBackground.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        popUpMessage.addChild(popUpMessageBackground)
        
        
        messageDisplay.text = "Score: \(score)"
        messageDisplay.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2 - 10)
        messageDisplay.fontSize = 24
        popUpMessage.addChild(messageDisplay)
        popUpMessage.setScale(0)
        popUpMessage.zPosition = 5
        self.addChild(popUpMessage)
        popUpMessage.run(SKAction.scale(to: 1, duration: TimeInterval(0.5)))
        
        self.score = 0
        
        let restartMessage = SKNode()
        let restartMessageText = SKLabelNode()
        
        restartBtn = createButton()
        
        restartMessageText.text = "Play Again"
        restartMessageText.fontSize = 24
        restartMessageText.position = restartBtn.position
        restartMessageText.position.y -= 10
        
        restartMessage.addChild(restartBtn)
        restartMessage.addChild(restartMessageText)
        
        restartMessage.setScale(0)
        restartMessage.zPosition = 5
        self.addChild(restartMessage)
        restartMessage.run(SKAction.scale(to: 1, duration: TimeInterval(0.5)))
        
        
        let exitMessage = SKNode()
        let exitBtnText = SKLabelNode()
        
        exitBtn = createButton()
        exitBtn.position.x += 250
        
        exitBtnText.text = "Exit"
        exitBtnText.fontSize = 24
        exitBtnText.position = exitBtn.position
        exitBtnText.position.y -= 10
        
        exitMessage.addChild(exitBtn)
        exitMessage.addChild(exitBtnText)
        
        exitMessage.setScale(0)
        exitMessage.zPosition = 5
        self.addChild(exitMessage)
        exitMessage.run(SKAction.scale(to: 1, duration: TimeInterval(0.5)))
    }
    
    func createButton() -> SKSpriteNode
    {
        let button = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 200, height: 40))
        button.position = CGPoint(x: screenWidth / 2 - 100, y: screenHeight / 2 - 100)
        
        return button
    }
    
    func restartGame()
    {
        snake1.removeAll()
        food.removeAll()
        deadSnakeFood.removeAll()
        
        self.removeAllChildren()
        self.removeAllActions()
        
        lost = false
        score = 0
        
        startGame()
    }
    
    
}
