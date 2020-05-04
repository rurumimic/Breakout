//
//  ViewController.swift
//  Breakout
//
//  Created by Dohyun Kim on 04/05/2020.
//  Copyright © 2020 rurumimic. All rights reserved.
//

import UIKit
import MetalKit


enum Colors {
    static let green = MTLClearColor(red: 0.0, green: 0.4, blue: 0.21, alpha: 1.0)
}

class ViewController: UIViewController {

    // Main 스토리보드의 MTKView 접근
    var metalView: MTKView {
        return view as! MTKView
    }
    
    // 애플리케이션 하나 당 Device, CommandQueue 한 개씩.
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reference GPU
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        
        metalView.clearColor = Colors.green // 투명색 설정
        metalView.delegate = self // metalView의 delegate 설정
        
        commandQueue = device.makeCommandQueue() // Command Buffer를 담는 큐
        
         
    }

}

// MetalKit은 Frame 마다 업데이트를 하기 위해서 프로토콜을 사용한다.
extension ViewController: MTKViewDelegate {
    
    // View 크기가 변할 때
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    // View는 drawable, render pass descriptor를 가지고 있다.
    func draw(in view: MTKView) {
        guard
            let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor
        else {
            return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer() // Command를 담는 버퍼
        
        // Render Command Encoder 생성: 모든 Command를 실행한다.
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        // Command 생성 끝
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
