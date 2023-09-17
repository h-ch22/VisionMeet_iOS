//
//  SpeechRecognitionHelper.swift
//  VisionMeet
//
//  Created by Ha Changjin on 9/17/23.
//

import Foundation
import Speech
import AVFoundation

class SpeechRecognitionHelper: NSObject, ObservableObject, SFSpeechRecognizerDelegate{
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @Published var resultText = ""
    
    override init(){
        super.init()
        speechRecognizer?.delegate = self
    }
    
    func getAudioEngineRunning() -> Bool{
        return audioEngine.isRunning ? true : false
    }
    
    func endAudio(){
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
    func startRecording(){
        if recognitionTask != nil{
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do{
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch{
            print(error.localizedDescription)
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else{
            fatalError("Cannot initalize recognition request.")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            
            if result != nil{
                self.resultText = result?.bestTranscription.formattedString ?? ""
                
                isFinal = (result?.isFinal)!
            }
            
            if isFinal{
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){ (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do{
            try audioEngine.start()
        } catch{
            print(error.localizedDescription)
        }
    }
}
