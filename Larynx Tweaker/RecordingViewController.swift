//
//  RecordingViewController.swift
//  Larynx Tweaker
//
//  Created by Pushkar Sharma on 08/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController {
    
    var recorder: AVAudioRecorder!

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        stopButton.enabled = false
        recordButton.enabled = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func recordTapped(sender: AnyObject) {
        recordButton.enabled = false
        stopButton.enabled = true
        recordLabel.text = "Recording.."
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recName = "temp.wav"
        let pathArray = [dirPath, recName]
        let fileURL = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! recorder = AVAudioRecorder(URL: fileURL!, settings: [:])
        
        recorder.delegate = self
        recorder.meteringEnabled = true
        recorder.prepareToRecord()
        recorder.record()
        
    }
    
    @IBAction func stopTapped(sender: AnyObject) {
        recordButton.enabled = true
        stopButton.enabled = false
        recordLabel.text = "Processing.."
        
        recorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
}

extension RecordingViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag){
            self.performSegueWithIdentifier("stopRecording", sender: recorder.url)
        }else{
            recordLabel.text = "Recording Failed."
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}
