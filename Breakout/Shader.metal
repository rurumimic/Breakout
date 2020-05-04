//
//  Shader.metal
//  Breakout
//
//  Created by Dohyun Kim on 04/05/2020.
//  Copyright © 2020 rurumimic. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

// vertex 함수
// 반환값: float4
// vertices 배열
// vertexId: 현재 GPU에서 처리되고 있는 vertex id
vertex float4 vertex_shader(const device packed_float3 *vertices [[ buffer(0) ]], uint vertexId [[ vertex_id ]]) {
    
    // 여기서 vertex 다음 위치 계산
    
    return float4(vertices[vertexId], 1);
}

// vertex를 fragment로 분할
// fragment 함수
// 반환값: half4
fragment half4 fragment_shader() {
    // 빨간색 반환
    return half4(1, 0, 0, 1); // Red, Green, Blue, Alpha
}
