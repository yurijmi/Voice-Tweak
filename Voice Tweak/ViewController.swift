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
    @IBOutlet weak var playButton  : UIButton!
    @IBOutlet weak var loopSwitch  : UISwitch!
    
    var audioPlayer : AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func sliderMoved(sender: UISlider) {
        
    }

    @IBAction func recordTapped(sender: UIButton) {
        
    }
    
    @IBAction func playTapped(sender: UIButton) {
        if self.audioPlayer == nil {
            setupAndPlay()
        } else {
            if self.audioPlayer!.playing {
                self.audioPlayer!.stop()
                
                self.playButton.setTitle("PLAY", forState: UIControlState.Normal)
            } else {
                setupAndPlay()
            }
        }
    }
    
    func setupAndPlay() {
        do {
            let path = NSBundle.mainBundle().pathForResource("mic_noise", ofType: "m4a")
            let url  = NSURL(fileURLWithPath: path!)
            
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
            self.audioPlayer!.delegate = self
            self.audioPlayer!.play()
            
            self.playButton.setTitle("STOP", forState: UIControlState.Normal)
        } catch {}
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.playButton.setTitle("PLAY", forState: UIControlState.Normal)
    }
    
}
