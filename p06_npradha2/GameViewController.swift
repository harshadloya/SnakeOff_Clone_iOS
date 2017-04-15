//
//  GameViewController.swift
//  p06_npradha2
//
//  Created by Nimesh on 4/6/17.
//  Copyright © 2017 npradha2. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view as! SKView
        //  let scene = GameScene(size: CGSize(width:750 , height:1344))
        let scene = GameMenuScene()
        scene.size = self.view.bounds.size
        scene.backgroundColor = SKColor.gray
        
        view.ignoresSiblingOrder = true
        
        view.showsFPS = true
        view.showsNodeCount = true
        scene.scaleMode = .aspectFit
        view.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
