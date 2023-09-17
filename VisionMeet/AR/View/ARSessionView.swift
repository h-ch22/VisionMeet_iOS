//
//  ARSessionView.swift
//  VisionMeet
//
//  Created by Ha Changjin on 9/17/23.
//

import SwiftUI

struct ARSessionView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var viewModel: ARSessionViewModel = ARSessionViewModel()
    @StateObject private var recognitionHelper = SpeechRecognitionHelper()
    
    @State private var isRecording = false
    @State private var useKeyboard = false
    
    let sessionName: String
    
    var body: some View {
        ZStack{
            ARViewContainer(arViewModel: viewModel).edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Button(action:{
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.gray)
                            .shadow(radius: 5)
                            .background(.ultraThinMaterial, in: Circle())

                    }
                    
                    Spacer()
                    
                    Text(sessionName)
                        .foregroundStyle(Color.txt)
                    
                    Spacer()
                }
                
                Spacer()
                
                if recognitionHelper.resultText != "" && !useKeyboard{
                    Text(recognitionHelper.resultText)
                        .foregroundStyle(Color.white)
                        .padding(15)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
                        .animation(.easeInOut)
                    
                    Spacer().frame(height: 20)

                }
                
                HStack{
                    if !useKeyboard{
                        Button(action: {
                            useKeyboard = true
                        }){
                            Image(systemName: "keyboard")
                                .padding(10)
                                .foregroundStyle(Color.gray)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                                             
                        Spacer()
                        
                        Button(action: {
                            if !isRecording{
                                if recognitionHelper.getAudioEngineRunning(){
                                    recognitionHelper.endAudio()
                                }
                                
                                recognitionHelper.startRecording()
                                isRecording = true
                            } else{
                                recognitionHelper.endAudio()
                                isRecording = false
                            }
                        }){
                            Image(systemName: "record.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(isRecording ? Color.gray : Color.red)
                        }
                        .animation(.easeInOut)
                        
                        Spacer()
                        
                    } else{
                        Button(action: {
                            useKeyboard = false
                        }){
                            Image(systemName: "waveform")
                                .foregroundStyle(Color.gray)
                                .padding(10)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        
                        Spacer()
                        
                        TextField("대화를 입력해보세요.", text: $recognitionHelper.resultText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Spacer()
                        
                        Button(action: {
                            recognitionHelper.resultText = ""
                        }){
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(recognitionHelper.resultText == "" ? Color.gray : Color.accent)
                        }
                    }
                }
                
            }.padding(20)
                .animation(.easeInOut)
        }
    }
}

#Preview {
    ARSessionView(sessionName: "AR Session")
}
