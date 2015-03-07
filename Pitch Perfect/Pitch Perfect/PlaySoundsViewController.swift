//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Thiago Graça Couto Braun on 3/6/15.
//  Copyright (c) 2015 GCBraun. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var slowSoundButton: UIButton!
    @IBOutlet weak var fastSoundButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    var audioPlayer : AVAudioPlayer! = nil
    var audioEngine : AVAudioEngine! = nil
    var audioPlayerNode : AVAudioPlayerNode! = nil
    var audioFile:AVAudioFile!
    var receivedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        //This piece of code sets the sound to always play on the Speakers
        let session = AVAudioSession.sharedInstance()
        var error: NSError?
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error)
        session.setActive(true, error: &error)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowSound(sender: UIButton) {
        
        stopButton.hidden = false
        audioPlayer.prepareToPlay()
        audioPlayer.rate = 0.5
        audioPlayer.volume = 1.0
        audioPlayer.stop()
        audioPlayer.play()
        
    }
    
    @IBAction func fastSound(sender: UIButton) {
        
        stopButton.hidden = false
        audioPlayer.enableRate = true
        audioPlayer.prepareToPlay()
        audioPlayer.rate = 2.0
        audioPlayer.volume = 1.0
        audioPlayer.stop()
        audioPlayer.play()
        
    }
    
    
    @IBAction func chipmunkSound(sender: UIButton) {
        stopButton.hidden = false
        playAudioWithVariablePitch(1000)
        
    }
    
    
    @IBAction func vaderSound(sender: UIButton) {
        stopButton.hidden = false
        playAudioWithVariablePitch(-1000)
        
    }
    
    
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.volume = 1.0
        audioPlayerNode.play()
    }
    
    
    
    @IBAction func stopSound(sender: UIButton) {
        
        audioPlayer.stop()
        audioPlayerNode.stop()
        stopButton.hidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
