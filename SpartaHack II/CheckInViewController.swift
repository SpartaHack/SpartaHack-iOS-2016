//
//  CheckInViewController.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 1/15/17.
//  Copyright © 2017 Chris McGrath. All rights reserved.
//

import Foundation
import AVFoundation
import QuartzCore
import AudioToolbox

protocol CheckInViewControllerDelegate {
    func userCheckedIn (_ result: Bool)
}

class CheckInViewController: UIViewController, UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    var videoLayer:AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    var qrCodeFrameView: UIView?
    
    var player: AVAudioPlayer?
    
    var delegate: CheckInViewControllerDelegate!
    
    override func viewDidAppear(_ animated: Bool) {
        videoLayer?.frame = CGRect(x: 0.0, y: 0.0, width: self.cameraView.frame.width, height: self.cameraView.frame.height)
        cameraView.layer.addSublayer(videoLayer!)
        
        // Start the green circle highlighter
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 3
        cameraView.addSubview(qrCodeFrameView!)
        cameraView.bringSubview(toFront: qrCodeFrameView!)
        self.captureSession?.startRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                                                         AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                                                         AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            captureSession?.startRunning()
            
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoLayer?.transformedMetadataObject(for: metadataObj) as? AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject!.bounds;
            if metadataObj.stringValue != nil {
                SpartaModel.sharedInstance.validateCheckin(idString: metadataObj.stringValue, completionHandler: { (success:Bool, errorStr:String?) in
                    if !success {
                        /// why did we fail
                        self.playFail()
                        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                        SpartaToast.displayToast("Scan Failed \n \(errorStr!)")
                    } else {
                        /// play the easter egg
                        self.playSuccess()
                        SpartaToast.displayToast("Success!")
                    }
                })
                print("Obj scanned: \(metadataObj.stringValue!)")
                // send request to parse with the eventID to grab the name
                self.captureSession?.stopRunning()
            }
        }
    }
    
    func playFail() {
        guard let url = Bundle.main.url(forResource: "portal2buzzer", withExtension: "mp3") else {
            print("url not found")
            return
        }
        
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /// change fileTypeHint according to the type of your audio file (you can omit this)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
            
            // no need for prepareToPlay because prepareToPlay is happen automatically when calling play()
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }

    
    
    func playSuccess() {
        guard let url = Bundle.main.url(forResource: "winXP", withExtension: "mp3") else {
            print("url not found")
            return
        }
        
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /// change fileTypeHint according to the type of your audio file (you can omit this)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
            
            // no need for prepareToPlay because prepareToPlay is happen automatically when calling play()
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }

    
    override func viewDidLayoutSubviews() {
        self.view.backgroundColor = Theme.backgroundColor
        
        let scanButtonAttributedTitle = NSAttributedString(string: "Scan",
                                                            attributes: [NSForegroundColorAttributeName : Theme.primaryColor])
        scanButton.setAttributedTitle(scanButtonAttributedTitle, for: .normal)
        scanButton.layer.cornerRadius = 0.0
        scanButton.layer.borderColor = Theme.tintColor.cgColor
        scanButton.layer.borderWidth = 1.5
        
        let font = UIFont.systemFont(ofSize: 40)
        
        let closeButtonAttributedTitle = NSAttributedString(string: "x",
                                                            attributes: [NSForegroundColorAttributeName : Theme.primaryColor,
                                                                         NSFontAttributeName: font])
        closeButton.setAttributedTitle(closeButtonAttributedTitle, for: .normal)
        
    }
    
    @IBAction func scanButtonTapped(_ sender: AnyObject) {
        self.captureSession?.startRunning()

    }
    
    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
