//
//  ARModel.swift
//  VisionMeet
//
//  Created by Ha Changjin on 9/17/23.
//

import Foundation
import RealityKit
import ARKit

struct ARModel{
    private(set) var arView: ARView
    
    init(){
        arView = ARView(frame: .zero)
        let configuration = ARWorldTrackingConfiguration()
        
        arView.session.run(configuration)
    }
}
