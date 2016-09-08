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
    
    // MARK: - Navigation


    @IBAction func recordTapped(sender: AnyObject) {
        recordingActive(true)
        
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
        recordingActive(false)
        
        recorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func recordingActive(state: Bool){
        recordButton.enabled = !state
        stopButton.enabled = state
        recordLabel.text = state == true ?"Recording":"Processing.."
    }
    
}

extension RecordingViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegueWithIdentifier("stopRecording", sender: recorder.url)
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
