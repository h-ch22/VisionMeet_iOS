//
//  ARSessionViewModel.swift
//  VisionMeet
//
//  Created by Ha Changjin on 9/17/23.
//

import Foundation
import RealityKit
import ARKit

class ARSessionViewModel: UIViewController, ObservableObject, ARSessionDelegate{
    @Published private var arModel: ARModel = ARModel()
    
    var arView: ARView{
        arModel.arView
    }
    
    func startSessionDelegate(){
        arModel.arView.session.delegate = self
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]){
        
    }
}
