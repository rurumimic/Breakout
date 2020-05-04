//
//  ViewController.swift
//  Breakout
//
//  Created by Dohyun Kim on 04/05/2020.
//  Copyright © 2020 rurumimic. All rights reserved.
//

import UIKit
import MetalKit

var renderer: Renderer?

class ViewController: UIViewController {

    // Main 스토리보드의 MTKView 접근
    var metalView: MTKView {
        return view as! MTKView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Renderer
        renderer = Renderer(metalView: metalView)
    }

}

