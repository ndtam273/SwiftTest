//
//  CallDetailVC.swift
//  SwiftTest
//
//  Created by Nguyen Duc Tam on 2017/02/19.
//  Copyright © 2017年 Nguyen Duc Tam. All rights reserved.
//

import UIKit
import AVFoundation

protocol CallDetailVCDelegate: NSObjectProtocol {
    func view(view: CallDetailVC, needsPerformAction action: CallDetailVC.Action)
}

class CallDetailVC: UIViewController {
    @IBOutlet weak var endCallBtn: UIButton!
    @IBOutlet weak var cancelCallBtn: UIButton!
    @IBOutlet weak var acceptCallBtn: UIButton!
    @IBOutlet weak var callerImg: UIImageView!
    @IBOutlet weak var callerText: UILabel!
    var phoneSound: AVAudioPlayer!
    var talkQueue: AVQueuePlayer!
    
    weak var delegate: CallDetailVCDelegate?
    
    enum Action {
        case callBack
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        endCallBtn.isHidden = true
        talkQueue = {
            let url1 = Bundle.main.url(forResource: "talk1", withExtension: "mp3")!
            let url2 = Bundle.main.url(forResource: "talk2", withExtension: "mp3")!
            let url3 = Bundle.main.url(forResource: "talk3", withExtension: "mp3")!
            let item1 = AVPlayerItem(url: url1)
            let item2 = AVPlayerItem(url: url2)
            let item3 = AVPlayerItem(url: url3)
            let queue = AVQueuePlayer(items: [item1, item2,item3])
            return queue
        }()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CallDetailVC.didFnishAAudio), name:
            .AVPlayerItemDidPlayToEndTime, object: nil)
        setCallState()

        // Do any additional setup after loading the view.
    }
    
    var callImageName: String?
    
    @objc func didFnishAAudio() {
        callerImg.image = UIImage(named: callImageName ?? "talk2")
        callImageName = "talk3"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCallState() {
        playSound("call.mp3")
        callerImg.image = UIImage(named: "call")
        callerText.text = "着信中\n負けもの\n0185-2X-9220"
       
    }

    func talk() {
        acceptCallBtn.isHidden = true
        cancelCallBtn.isHidden = true
        endCallBtn.isHidden = false
        stopSound()
        callerImg.image = UIImage(named: "talk1")
        callerText.text = "応答中"
        talkQueue.play()
        
        
        
    }
    func playSound(_ fileName: String) {
        let path = Bundle.main.path(forResource: fileName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            phoneSound = sound
            sound.play()
        } catch {
            // couldn't load file :(
            print("cant play sound")
        }
        
    }
    
    func stopSound() {
        if phoneSound != nil {
            phoneSound.stop()
            phoneSound = nil
        }
    }
    
    @IBAction func accept(_ sender: UIButton) {
        talk()
    }
    @IBAction func deny(_ sender: UIButton) {
        delegate?.view(view: self, needsPerformAction: .callBack)
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
