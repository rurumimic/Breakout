//
//  Renderer.swift
//  Breakout
//
//  Created by Dohyun Kim on 04/05/2020.
//  Copyright © 2020 rurumimic. All rights reserved.
//

import MetalKit

enum Colors {
    static let green = MTLClearColor(red: 0.0, green: 0.4, blue: 0.21, alpha: 1.0)
}

class Renderer: NSObject {
    
    // 애플리케이션 하나 당 Device, CommandQueue 한 개씩.
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    
    var vertices: [Float] = [
        0, 1, 0,
        -1, -1, 0,
        1, -1, 0
    ]
    
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    
    init(metalView: MTKView) {
        // Reference GPU
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("GPU not available")
        }
        
        metalView.device = device
        Renderer.device = device
        Renderer.commandQueue = device.makeCommandQueue()
        
        super.init()
        buildModel(device: device)
        buildPipelineState(device: device)
        
        metalView.clearColor = Colors.green // 투명색 설정
        metalView.delegate = self // metalView의 delegate 설정
    }
    
    private func buildModel(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
    }
    
    // Pipeline State 생성
    private func buildPipelineState(device: MTLDevice) {
        // 모든 Shader 함수는 Library 안에 저장된다.
        let library = device.makeDefaultLibrary()
        
        // XCode가 프로젝트를 빌드할 때 이 함수들도 함께 컴파일하여 라이브러리에 저장한다.
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")
        
        // Pipeline Descriptor 생성
        // Shader 함수 정보 저장
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // Pipeline Descriptor 사용하여 Pipeline State 생성
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

// MetalKit은 Frame 마다 업데이트를 하기 위해서 프로토콜을 사용한다.
extension Renderer: MTKViewDelegate {
    
    // View 크기가 변할 때
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    // View는 drawable, render pass descriptor를 가지고 있다.
    func draw(in view: MTKView) {
        guard
            let drawable = view.currentDrawable,
            let pipelineState = pipelineState,
            let descriptor = view.currentRenderPassDescriptor
        else {
            return
        }
        
        let commandBuffer = Renderer.commandQueue.makeCommandBuffer() // Command를 담는 버퍼
        
        // Render Command Encoder 생성: 모든 Command를 실행한다.
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        // Command 생성 끝
        commandEncoder?.setRenderPipelineState(pipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
