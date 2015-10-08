//
//  ViewController.swift
//  Voice Tweak
//
//  Created by Юрий Михайлов on 08.10.15.
//  Copyright © 2015 Юрий Михайлов. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var speedLabel  : UILabel!
    @IBOutlet weak var speedSlider : UISlider!
    @IBOutlet weak var playButton  : UIButton!
    @IBOutlet weak var loopSwitch  : UISwitch!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer   : AVAudioPlayer?
    var audioURL      : NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudioRecorder()
    }
    
    func setupAudioRecorder() {
        do {
            let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
            let pathComponents = [basePath, "recorded.m4a"]
            
            self.audioURL = NSURL.fileURLWithPathComponents(pathComponents)
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            try session.setActive(true)
            
            var recordSettings = [String : AnyObject]()
                recordSettings[AVFormatIDKey]         = Int(kAudioFormatMPEG4AAC)
                recordSettings[AVSampleRateKey]       = 44100.0
                recordSettings[AVNumberOfChannelsKey] = 2
            
            self.audioRecorder = try AVAudioRecorder(URL: self.audioURL!, settings: recordSettings)
            self.audioRecorder!.meteringEnabled = true
            
            self.audioRecorder!.prepareToRecord()
        } catch {}
    }

    @IBAction func recordTapped(button: UIButton) {
        if self.audioRecorder!.recording {
            self.audioRecorder!.stop()
            
            button.setTitle("RECORD", forState: UIControlState.Normal)
        } else {
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                
                self.audioRecorder!.record()
                
                button.setTitle("STOP", forState: UIControlState.Normal)
            } catch {}
        }
    }
    
    @IBAction func playTapped(button: UIButton) {
        if self.audioPlayer == nil {
            setupAndPlay()
        } else {
            if self.audioPlayer!.playing {
                self.audioPlayer!.stop()
                
                button.setTitle("PLAY", forState: UIControlState.Normal)
            } else {
                setupAndPlay()
            }
        }
    }
    
    @IBAction func sliderMoved(slider: UISlider) {
        let speed = String(format: "%.1f", slider.value)
        
        self.speedLabel.text = "Speed \(speed)x"
        
        if self.audioPlayer != nil {
            self.audioPlayer!.rate = slider.value
        }
    }
    
    func setupAndPlay() {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: self.audioURL!)
            
            self.audioPlayer!.enableRate = true
            self.audioPlayer!.rate       = self.speedSlider.value
            self.audioPlayer!.delegate   = self
            
            if self.loopSwitch.on {
                self.audioPlayer!.numberOfLoops = -1
            }
            
            self.audioPlayer!.play()
            
            self.playButton.setTitle("STOP", forState: UIControlState.Normal)
        } catch {}
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.playButton.setTitle("PLAY", forState: UIControlState.Normal)
    }
    
}
