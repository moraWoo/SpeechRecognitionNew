//
//  ViewController.swift
//  SpeechRecognitionNew
//
//  Created by Ильдар on 08.02.2023.
//

import UIKit
import Speech

class ViewController: UIViewController {
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU")) // Use Russian
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    @IBOutlet weak var label: UILabel!
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
        // Do any additional setup after loading the view.
    }
    
    func start() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                self.startRecognition()
            }
        }
    }
    
    func startRecognition() {
        do {
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { return }
            
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                if let result = result {
                    let recognizedText = result.bestTranscription.formattedString
                    self.label.text = recognizedText
                    print(recognizedText)
                }
            }
            
            let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                recognitionRequest.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            label.text = "Слушаю..."
            //            self.isRunning = true
        }
        
        catch {
            
        }
    }
    
    func stop() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionRequest?.endAudio()
        self.isRunning = false
    }
}
