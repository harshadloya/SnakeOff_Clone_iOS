//
//  TwoPlayers.swift
//  p06_npradha2
//
//  Created by Nimesh on 4/15/17.
//  Copyright © 2017 npradha2. All rights reserved.
//

import SpriteKit
import GameplayKit

class TwoPlayers: SKScene, SKPhysicsContactDelegate
{
    var snake1 = Array<SKShapeNode>()
    
    var player1 = Int()
    var player1Label = SKLabelNode()
    var player1TextLabel = SKLabelNode()
    
    var player1Base = SKShapeNode()
    var player1Controller = SKShapeNode()
    var player1SpeedController = SKSpriteNode()
    var player1ControllerPressed = Bool()
    var player1ControllerMoved = Bool()
    var player1SpeedControllerPressed = Bool()
    var player1SpeedBooster = CGFloat()

    var player1DeathCount = Int()
    var player1Lost = Bool()

    var player1xDist = CGFloat()
    var player1yDist = CGFloat()
    var player1PositionArray = Array<CGPoint>()
    
    var snake2 = Array<SKShapeNode>()
    
    var player2 = Int()
    var player2Label = SKLabelNode()
    var player2TextLabel = SKLabelNode()
    
    var player2Base = SKShapeNode()
    var player2Controller = SKShapeNode()
    var player2SpeedController = SKSpriteNode()
    var player2ControllerPressed = Bool()
    var player2ControllerMoved = Bool()
    var player2SpeedControllerPressed = Bool()
    var player2SpeedBooster = CGFloat()
    
    var player2DeathCount = Int()
    var player2Lost = Bool()
    
    var player2xDist = CGFloat()
    var player2yDist = CGFloat()
    var player2PositionArray = Array<CGPoint>()
    
    var circle = SKShapeNode()
    
    var food = Array<SKShapeNode>()
    var deadSnakeFood = Array<SKShapeNode>()
    
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    var restartBtn = SKSpriteNode()
    var exitBtn = SKSpriteNode()

    
    override func didMove(to view: SKView)
    {
        startGame()
    }
    
    func startGame()
    {
        screenWidth = self.frame.width
        screenHeight = self.frame.height
        
        self.createController()
        
        //adding background
        let background = SKSpriteNode(imageNamed: "bggrid")
        background.size = CGSize(width: screenWidth, height: screenHeight)
        background.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        background.zPosition = 1
        self.addChild(background)
        
        //player1 score labels
        player1TextLabel = createScoreLabel(name: "text", player: 1)
        player1TextLabel.text = "Player 1"
        self.addChild(player1TextLabel)
        
        player1Label = createScoreLabel(name: "number", player: 1)
        player1Label.text = "\(player1)"
        self.addChild(player1Label)
        
        //player2 score labels
        player2TextLabel = createScoreLabel(name: "text", player: 2)
        player2TextLabel.text = "Player 2"
        self.addChild(player2TextLabel)
        
        player2Label = createScoreLabel(name: "number", player: 2)
        player2Label.text = "\(player2)"
        self.addChild(player2Label)
        
        player1SpeedBooster = 1.3
        player2SpeedBooster = 1.3
        
        self.createSnake(player: 1)
        self.createSnake(player: 2)
        self.player1DeathCount = 5
        self.player2DeathCount = 5
        
        self.player1ControllerPressed = false
        self.player1ControllerMoved = false
        self.player1SpeedControllerPressed = false
        
        self.player2ControllerPressed = false
        self.player2ControllerMoved = false
        self.player2SpeedControllerPressed = false
        
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

    func createSnake(player : Int)
    {
        if(player == 1)
        {
            for i in 0...4
            {
                var circle2 = SKShapeNode()
                if(i == 0)
                {
                    circle2 = self.snakeHead(player: player)
                }
                else
                {
                    circle2 = self.snake(player: player, type: "new")
                }
                circle2.position.x = circle2.position.x - CGFloat(i * 15)
                circle2.position.y = screenHeight / 2
                circle2.zPosition = 2
                
                snake1.append(circle2)
            }
        
            if(!snake1.isEmpty)
            {
                NSLog("Adding Player 1 Snake")
                for i in 0...snake1.count-1
                {
                    self.addChild(snake1[i])
                }
            }
        }
        else
        {
            for i in 0...4
            {
                var circle2 = SKShapeNode()
                
                if(i == 0)
                {
                    circle2 = self.snakeHead(player: player)
                }
                else
                {
                    circle2 = self.snake(player: player, type: "new")
                }
                
                circle2.position.x = circle2.position.x + CGFloat(i * 15)
                circle2.position.y = screenHeight / 2 - 100
                circle2.zPosition = 2
                
                snake2.append(circle2)
            }
            
            if(!snake2.isEmpty)
            {
                NSLog("Adding Player 2 Snake")
                for i in 0...snake2.count-1
                {
                    self.addChild(snake2[i])
                }
            }
        }
    }
    
    func createScoreLabel(name: String, player: Int) -> SKLabelNode
    {
        
        let label = SKLabelNode()
        
        if(player == 1)
        {
            if name == "text"
            {
                label.position = CGPoint(x: screenWidth / 5 , y: screenHeight / 2 + screenHeight / 2.5)
            }
            else if name == "number"
            {
                label.position = CGPoint(x: screenWidth / 5, y: screenHeight / 2 + screenHeight / 3)
            }
        }
        else
        {
            if name == "text"
            {
                label.position = CGPoint(x: screenWidth - screenWidth / 5 , y: screenHeight / 2 + screenHeight / 2.5)
            }
            else if name == "number"
            {
                label.position = CGPoint(x: screenWidth - screenWidth / 5, y: screenHeight / 2 + screenHeight / 3)
            }
        }
        label.fontColor = UIColor.black
        label.fontSize = 24
        label.zPosition = 10
        return label
    }
    
    func createController()
    {
        //player1
        self.player1Base = SKShapeNode(circleOfRadius: 50)
        self.player1Base.fillColor = SKColor.darkGray
        self.player1Base.position = CGPoint(x: screenWidth / 10, y:screenHeight - 100)
        self.player1Base.alpha = 0.4
        self.player1Base.zPosition = 3
        self.addChild(player1Base)
        
        self.player1Controller = SKShapeNode(circleOfRadius: 20)
        self.player1Controller.fillColor = SKColor.gray
        self.player1Controller.position = self.player1Base.position
        self.player1Controller.alpha = 0.7
        self.player1Controller.zPosition = 4
        self.addChild(player1Controller)
        
        self.player1SpeedController = SKSpriteNode(imageNamed: "speedBoost")
        self.player1SpeedController.zPosition = 4
        self.player1SpeedController.alpha = 0.4
        self.player1SpeedController.position = CGPoint(x: screenWidth / 10, y: 100)
        self.player1SpeedController.setScale(0.4)
        self.addChild(player1SpeedController)
        
        //player2
        self.player2Base = SKShapeNode(circleOfRadius: 50)
        self.player2Base.fillColor = SKColor.darkGray
        self.player2Base.position = CGPoint(x:screenWidth - screenWidth / 10, y:screenHeight - 100)
        self.player2Base.alpha = 0.4
        self.player2Base.zPosition = 3
        self.addChild(player2Base)
        
        self.player2Controller = SKShapeNode(circleOfRadius: 20)
        self.player2Controller.fillColor = SKColor.gray
        self.player2Controller.position = self.player2Base.position
        self.player2Controller.alpha = 0.7
        self.player2Controller.zPosition = 4
        self.addChild(player2Controller)
        
        self.player2SpeedController = SKSpriteNode(imageNamed: "speedBoost")
        self.player2SpeedController.zPosition = 4
        self.player2SpeedController.alpha = 0.4
        self.player2SpeedController.position = CGPoint(x: screenWidth - screenWidth / 10, y: 100)
        self.player2SpeedController.setScale(0.4)
        self.addChild(player2SpeedController)
    }
    
    func snakeHead(player: Int) -> SKShapeNode
    {
        self.circle = SKShapeNode(circleOfRadius: 10)

        let outerBody = SKShapeNode(circleOfRadius: 10)
        let innerBody = SKShapeNode(circleOfRadius: 7)
        let leftEye = SKShapeNode(circleOfRadius: 2)
        let rightEye = SKShapeNode(circleOfRadius: 2)
        let leftEyeWhite = SKShapeNode(circleOfRadius: 3.5)
        let rightEyeWhite = SKShapeNode(circleOfRadius: 3.5)
        
        if(player == 1)
        {
            self.circle.position = CGPoint(x: 150, y:100)
            outerBody.fillColor = SKColor.blue
            outerBody.strokeColor = SKColor.blue
        
            innerBody.fillColor = SKColor.cyan
            innerBody.strokeColor = SKColor.cyan
            
            leftEye.position.x = 2
            leftEye.position.y = 7
        
            leftEyeWhite.position.x = 3
            leftEyeWhite.position.y = 7
            
            rightEye.position.x = 2
            rightEye.position.y = -7
            
            rightEyeWhite.position.x = 3
            rightEyeWhite.position.y = -7
        }
        else
        {
            self.circle.position = CGPoint(x: screenWidth - 150, y:100)
            outerBody.fillColor = SKColor.red
            outerBody.strokeColor = SKColor.red
            
            innerBody.fillColor = SKColor.orange
            innerBody.strokeColor = SKColor.orange
            
            leftEye.position.x = 2
            leftEye.position.y = 7
            
            leftEyeWhite.position.x = 3
            leftEyeWhite.position.y = 7
            
            
            rightEye.position.x = 2
            rightEye.position.y = -7
            
            rightEyeWhite.position.x = 3
            rightEyeWhite.position.y = -7
        }
        
        leftEye.fillColor = SKColor.black
        leftEye.strokeColor = SKColor.black
        
        rightEye.fillColor = SKColor.black
        rightEye.strokeColor = SKColor.black
        
        leftEyeWhite.fillColor = SKColor.white
        leftEyeWhite.strokeColor = SKColor.black
        
        rightEyeWhite.fillColor = SKColor.white
        rightEyeWhite.strokeColor = SKColor.black
        
        
        self.circle.addChild(outerBody)
        self.circle.addChild(innerBody)
        self.circle.addChild(leftEyeWhite)
        self.circle.addChild(rightEyeWhite)
        self.circle.addChild(leftEye)
        self.circle.addChild(rightEye)
        
        return self.circle;
        
    }
    
    func snake(player : Int, type: String) -> SKShapeNode
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
        
        if(player == 1)
        {
            self.circle.position = CGPoint(x: 150, y:100)
            
            outerBody.fillColor = SKColor.blue
            outerBody.strokeColor = SKColor.blue
            
            innerBody.fillColor = SKColor.cyan
            innerBody.strokeColor = SKColor.cyan
        }
        else
        {
            self.circle.position = CGPoint(x: screenWidth - 150, y:100)
            
            outerBody.fillColor = SKColor.red
            outerBody.strokeColor = SKColor.red
            
            innerBody.fillColor = SKColor.orange
            innerBody.strokeColor = SKColor.orange
        }
        
        self.circle.addChild(outerBody)
        self.circle.addChild(innerBody)
        return self.circle;
        
    }
    
    func foodCreate() -> SKShapeNode
    {
        let foodCircle = SKShapeNode(circleOfRadius: 5)
        foodCircle.position = CGPoint(x: 150, y:100)
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
            
            //player 1 controllers
            if(player1Controller.contains(location))
            {
                player1ControllerPressed = true
            }
            else
            {
                player1ControllerPressed = false
            }
            
            if(player1SpeedController.contains(location))
            {
                player1SpeedControllerPressed = true
                player1SpeedBooster = 2.2
            }
            else
            {
                player1SpeedControllerPressed = false
                player1SpeedBooster = 1.3
            }
            
            //player 2 controllers
            if(player2Controller.contains(location))
            {
                player2ControllerPressed = true
            }
            else
            {
                player2ControllerPressed = false
            }
            
            if(player2SpeedController.contains(location)){
                player2SpeedControllerPressed = true
                player2SpeedBooster = 2.2
            }
            else
            {
                player2SpeedControllerPressed = false
                player2SpeedBooster = 1.3
            }
            
            //if game over
            if(player1Lost || player2Lost)
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            //player 1 direction controller
            if(player1ControllerPressed)
            {
                player1ControllerMoved = true
                let v = CGVector(dx: location.x - player1Base.position.x, dy: location.y - player1Base.position.y)
                let angle = atan2(v.dy, v.dx)
                
                let length: CGFloat = player1Base.frame.size.height / 5
                
                player1xDist = sin(angle - .pi / 2.0) * length
                player1yDist = cos(angle - .pi / 2.0) * length
                
                player1Controller.position = CGPoint(x:player1Base.position.x - player1xDist, y:player1Base.position.y + player1yDist)
                snake1[0].zRotation = angle
            }
            
            //player 2 direction controller
            if(player2ControllerPressed)
            {
                player2ControllerMoved = true
                let v = CGVector(dx: location.x - player2Base.position.x, dy: location.y - player2Base.position.y)
                let angle = atan2(v.dy, v.dx)
                
                let length: CGFloat = player1Base.frame.size.height / 5
                
                player2xDist = sin(angle - .pi / 2.0) * length
                player2yDist = cos(angle - .pi / 2.0) * length
                
                player2Controller.position = CGPoint(x:player2Base.position.x - player2xDist, y:player2Base.position.y + player2yDist)
                snake2[0].zRotation = angle
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.player1Controller.position = self.player1Base.position
        self.player1SpeedBooster = 1.3
        self.player1SpeedControllerPressed = false
        
        self.player2Controller.position = self.player2Base.position
        self.player2SpeedBooster = 1.3
        self.player2SpeedControllerPressed = false
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if (player1Lost || player2Lost) {
            return
        }
        //save old position in array
        for i in 0...snake1.count - 1
        {
            player1PositionArray.append(snake1[i].position)
        }
        for i in 0...snake2.count - 1
        {
            player2PositionArray.append(snake2[i].position)
        }
        
        //move head in the direction of player1Controller
        if(player1ControllerMoved)
        {
            snake1[0].position = CGPoint(x:snake1[0].position.x - player1xDist / 5 * player1SpeedBooster, y:snake1[0].position.y + player1yDist / 5 * player1SpeedBooster)
        }
        else
        {
            snake1[0].position = CGPoint(x:snake1[0].position.x + 4 * player1SpeedBooster, y:snake1[0].position.y )
        }
        
        if(player2ControllerMoved)
        {
            snake2[0].position = CGPoint(x:snake2[0].position.x - player2xDist / 5 * player2SpeedBooster, y:snake2[0].position.y + player2yDist / 5 * player2SpeedBooster)
        }
        else
        {
            snake2[0].position = CGPoint(x:snake2[0].position.x - 4 * player2SpeedBooster, y:snake2[0].position.y )
        }
        
        //change position of body to new position
        for i in 1...snake1.count - 1{
            let moveAction = SKAction.move(to: player1PositionArray[i-1], duration: 0.01)
            snake1[i].run(moveAction)
        }
        
        for i in 1...snake2.count - 1{
            let moveAction = SKAction.move(to: player2PositionArray[i-1], duration: 0.01)
            snake2[i].run(moveAction)
        }
        
        //Check if Snake 1 touches Snake 2
        self.checkSnakeCollision()
        
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
        
        if(snake2[0].position.y < 0){
            self.killSnake(snakeNumber: 2)
        }
        if(snake2[0].position.y > self.frame.size.height){
            self.killSnake(snakeNumber: 2)
        }
        
        if(snake2[0].position.x < 0){
            self.killSnake(snakeNumber: 2)
        }
        if(snake2[0].position.x > self.frame.size.width){
            self.killSnake(snakeNumber: 2)
        }
        
        checkFoodEaten()
        player1PositionArray.removeAll()
        player2PositionArray.removeAll()

    }
    
    func checkSnakeCollision()
    {
        //checking head to head collision of both snakes
        if(Int(snake1[0].position.x) >= Int(snake2[0].position.x) - 15 &&
            Int(snake1[0].position.x) <= Int(snake2[0].position.x) + 15 &&
            Int(snake1[0].position.y) >= Int(snake2[0].position.y) - 15 &&
            Int(snake1[0].position.y) <= Int(snake2[0].position.y) + 15)
        {
            if(snake1.count > snake2.count)
            {
                self.killSnake(snakeNumber: 2)
            }
            else if(snake1.count < snake2.count)
            {
                self.killSnake(snakeNumber: 1)
            }
            return
        }
        
        //checking snake 1 collided with snake 2
        for x in 0...snake2.count-1
        {
            if(Int(snake1[0].position.x) >= Int(snake2[x].position.x) - 15 &&
                Int(snake1[0].position.x) <= Int(snake2[x].position.x) + 15 &&
                Int(snake1[0].position.y) >= Int(snake2[x].position.y) - 15 &&
                Int(snake1[0].position.y) <= Int(snake2[x].position.y) + 15)
            {
                self.killSnake(snakeNumber: 1)
                return
            }
        }
        
        //checking snake 2 collided with snake 1
        for x in 0...snake1.count-1
        {
            if(Int(snake2[0].position.x) >= Int(snake1[x].position.x) - 15 &&
                Int(snake2[0].position.x) <= Int(snake1[x].position.x) + 15 &&
                Int(snake2[0].position.y) >= Int(snake1[x].position.y) - 15 &&
                Int(snake2[0].position.y) <= Int(snake1[x].position.y) + 15)
            {
                self.killSnake(snakeNumber: 2)
                return
            }
        }
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
                NSLog("Food Eaten by Player 1")
                food[x].position = CGPoint(x: randomValue(min: 20, max: screenWidth - 20), y: randomValue(min: 20, max: screenHeight - 20))
                food[x].fillColor = self.randomColor()
                
                self.updatePlayer1Score()
                
                self.growSnake(player: 1)
            }
            
            if(Int(snake2[0].position.x) >= Int(food[x].position.x) - 15 &&
                Int(snake2[0].position.x) <= Int(food[x].position.x) + 15 &&
                Int(snake2[0].position.y) >= Int(food[x].position.y) - 15 &&
                Int(snake2[0].position.y) <= Int(food[x].position.y) + 15)
            {
                NSLog("Food Eaten by Player 2")
                food[x].position = CGPoint(x: randomValue(min: 20, max: screenWidth - 20), y: randomValue(min: 20, max: screenHeight - 20))
                food[x].fillColor = self.randomColor()
                
                self.updatePlayer2Score()
                
                self.growSnake(player: 2)
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
                    //  NSLog("Dead Snake Food Eaten")
                    self.updatePlayer1Score()
                    self.growSnake(player: 1)
                    deadSnakeFood[x].removeFromParent()
                    deadSnakeFood.remove(at: x)
                    break
                }
                
                if(!deadSnakeFood[x].isHidden &&
                    Int(snake2[0].position.x) >= Int(deadSnakeFood[x].position.x) - 15 &&
                    Int(snake2[0].position.x) <= Int(deadSnakeFood[x].position.x) + 15 &&
                    Int(snake2[0].position.y) >= Int(deadSnakeFood[x].position.y) - 15 &&
                    Int(snake2[0].position.y) <= Int(deadSnakeFood[x].position.y) + 15)
                {
                    //  NSLog("Dead Snake Food Eaten")
                    self.updatePlayer2Score()
                    self.growSnake(player: 2)
                    deadSnakeFood[x].removeFromParent()
                    deadSnakeFood.remove(at: x)
                    break
                }
            }
        }
    }
    
    func updatePlayer1Score(){
        player1 += 1
        player1Label.text = "\(player1)"
    }
    
    func updatePlayer2Score(){
        player2 += 1
        player2Label.text = "\(player2)"
    }
    
    func growSnake(player : Int)
    {
        if(player == 1)
        {
            var circle2 = SKShapeNode()
            circle2 = self.snake(player: 1, type: "new")
            circle2.position.x = snake1[snake1.count-1].position.x
            circle2.position.y = snake1[snake1.count-1].position.y
            circle2.zPosition = 2
            
            snake1.append(circle2)
            self.addChild(snake1[snake1.count-1])
        }
        else
        {
            var circle2 = SKShapeNode()
            circle2 = self.snake(player: 2, type: "new")
            circle2.position.x = snake2[snake2.count-1].position.x
            circle2.position.y = snake2[snake2.count-1].position.y
            circle2.zPosition = 2
            
            snake2.append(circle2)
            self.addChild(snake2[snake2.count-1])
        }
    }
    
    func killSnake(snakeNumber: Int)
    {
        //if player1 killed
        if(snakeNumber == 1)
        {
            if(player1DeathCount == 0)
            {
                self.gameOver(player: 1)
            }
            else
            {
                player1DeathCount -= 1
                for i in 0...snake1.count - 1
                {
                    player1PositionArray[i] = snake1[i].position
                    snake1[i].removeAllActions()
                }
                
                self.player1ControllerMoved = false
                self.createFoodOnSnakeKill(snakeNumber: snakeNumber)
            }
        }
        //if player 2 killed
        else{
                if(player2DeathCount == 0)
                {
                    self.gameOver(player: 2)
                }
                else
                {
                    player2DeathCount -= 1
                    for i in 0...snake2.count - 1
                    {
                        player2PositionArray[i] = snake2[i].position
                        snake2[i].removeAllActions()
                    }
                    
                    self.player2ControllerMoved = false
                    self.createFoodOnSnakeKill(snakeNumber: snakeNumber)
                }
            }
    }
    
    func createFoodOnSnakeKill(snakeNumber: Int)
    {
        if(snakeNumber == 1)
        {
            for x in 0...(snake1.count - 1)
            {
                var snakeFood1 = SKShapeNode()
                
                snakeFood1 = self.snake(player: snakeNumber, type: "dead")
                
                snakeFood1.position.x = snake1[x].position.x + randomValue(min: -15.0, max: 15.0)
                snakeFood1.position.y = snake1[x].position.y + randomValue(min: -15.0, max: 15.0)
                snakeFood1.zPosition = 2
                snakeFood1.run(SKAction.sequence([SKAction.wait(forDuration: 5.0),SKAction.fadeOut(withDuration: 10), SKAction.hide()]))
                deadSnakeFood.append(snakeFood1)
                snake1[x].removeFromParent()
            }
            snake1.removeAll()
        }
        else
        {
            for x in 0...(snake2.count - 1)
            {
                var snakeFood2 = SKShapeNode()
                
                snakeFood2 = self.snake(player: snakeNumber, type: "dead")
                
                snakeFood2.position.x = snake2[x].position.x + randomValue(min: -15.0, max: 15.0)
                snakeFood2.position.y = snake2[x].position.y + randomValue(min: -15.0, max: 15.0)
                snakeFood2.run(SKAction.sequence([SKAction.wait(forDuration: 5.0),SKAction.fadeOut(withDuration: 10), SKAction.hide()]))
                snakeFood2.zPosition = 2
                deadSnakeFood.append(snakeFood2)
                snake2[x].removeFromParent()
            }
            snake2.removeAll()
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
        self.createSnake(player: snakeNumber)
    }
    
    func gameOver(player : Int)
    {
        let popUpMessage = SKNode()
        let popUpMessageBackground = SKSpriteNode(color: SKColor.gray, size: CGSize(width: 300, height: 40))
        let messageDisplay = SKLabelNode()
        
        popUpMessageBackground.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        popUpMessage.addChild(popUpMessageBackground)
        
        
        if(player1 > player2)
        {
            messageDisplay.text = "Player 1 wins with Score: \(player1)"
        }
        else if(player1 < player2)
        {
            messageDisplay.text = "Player 2 wins with Score: \(player2)"
        }
        else
        {
            messageDisplay.text = "It's a TIE"
        }
        messageDisplay.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2 - 10)
        messageDisplay.fontSize = 24
        popUpMessage.addChild(messageDisplay)
        popUpMessage.setScale(0)
        popUpMessage.zPosition = 5
        
        self.addChild(popUpMessage)
        popUpMessage.run(SKAction.scale(to: 1, duration: TimeInterval(0.5)))
        
        if(player == 1)
        {
            player1Lost = true
            self.player1 = 0
        }
        else
        {
            player2Lost = true
            self.player2 = 0
        }
        
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
        snake2.removeAll()
        
        food.removeAll()
        deadSnakeFood.removeAll()
        
        self.removeAllChildren()
        self.removeAllActions()
        
        player1Lost = false
        player1 = 0
        
        player2Lost = false
        player2 = 0
        
        startGame()
    }
    
}

