//
//  ContentView.swift
//  AudioCaptureandPlaybackwithProfiles
//
//  Created by Dayton Steffeny on 10/11/19.
//  Copyright © 2019 Dayton Steffeny. All rights reserved.
//

import UIKit
import AVFoundation
class AudioViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var b1: UIBarButtonItem!
    @IBOutlet weak var b2: UIBarButtonItem!
    
    let highM4a = profile(title: "High Quality m4a" , body: [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue, AVNumberOfChannelsKey: 1, AVSampleRateKey: 44100] as [String : Any], filename: "recording.m4a")
    
    let lowM4a = profile(title: "Low Quality m4a" , body: [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue, AVNumberOfChannelsKey: 1, AVSampleRateKey: 8000] as [String : Any], filename: "recording.m4a")
    
    let lowCaf = profile(title: "Low Quality caf" , body: [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue, AVEncoderBitRateKey: 16, AVNumberOfChannelsKey: 2, AVSampleRateKey: 8000.0] as [String : Any], filename: "recording.caf")
    
    let highCaf = profile(title: "High Quality caf" , body: [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue, AVEncoderBitRateKey: 16, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100.0] as [String : Any], filename: "recording.caf")
    
    var recordingSettings = [String : Any]()
    var filename = ""
    var profileData = [profile]()
    override func viewDidLoad() {
        super.viewDidLoad()
        profileData.append(lowM4a)
        profileData.append(highM4a)
        profileData.append(highCaf)
        profileData.append(lowCaf)
        recordingSettings = profileData[0].body
        filename = profileData[0].filename
        b1.image = UIImage(named: "Record")
        b2.image = UIImage(named: "Play")
        b2.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    var audioRecorder:AVAudioRecorder!
    var recordingSession: AVAudioSession!
    var audioPlayer : AVAudioPlayer!
    
    @IBAction func Clickb1(_ sender: Any) {
        b2.image = UIImage(named: "Stop")
        b2.isEnabled = true
        b1.isEnabled = false
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        let file = self.filename
                        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                        let fileURL = dir!.appendingPathComponent(file)
                        do {
                            self.audioRecorder = try AVAudioRecorder(url: fileURL, settings: self.recordingSettings)
                            self.audioRecorder.record()
                            
                        } catch {
                            self.recordingFailed()
                        }
                    } else {
                        self.recordingFailed()
                    }
                }
            }
        } catch {
            recordingFailed()
        }
    }
    
    func recordingFailed(){
        let alert = UIAlertController(title: "Warning", message: "Failed to record.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        return
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        b1.isEnabled = true
        b2.image = UIImage(named: "Play")
    }
    
    @IBAction func Clickb2(_ sender: Any) {
        if audioRecorder.isRecording{
            b1.isEnabled = true
            b2.image = UIImage(named: "Play")
            audioRecorder.stop()
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
            }
            catch{
                let alert = UIAlertController(title: "Warning", message: "Failed to play audio.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            return
        }
        
        if audioPlayer.isPlaying{
            b1.isEnabled = true
            b2.image = UIImage(named: "Play")
            audioPlayer.stop()
            return
        }
            
        else{
            b2.image = UIImage(named: "Pause")
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            return
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return profileData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        recordingSettings = profileData[row].body
        filename = profileData[row].filename
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return profileData[row].title
    }

}
