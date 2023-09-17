//
//  ARViewContainer.swift
//  VisionMeet
//
//  Created by Ha Changjin on 9/17/23.
//

import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable{
    var arViewModel: ARSessionViewModel
    
    func makeUIView(context: Context) -> ARView {
        arViewModel.startSessionDelegate()
        return arViewModel.arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
