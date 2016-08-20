//
//  ScanViewController.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 2/6/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var videoPreviewLayer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    var videoLayer:AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    var qrCodeFrameView: UIView?
    
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
            
            messageLabel!.text = "No code is detected"
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        videoLayer?.frame = CGRect(x: 0, y: 0, width: self.videoPreviewLayer.frame.width, height: self.videoPreviewLayer.frame.height)
        videoPreviewLayer.layer.addSublayer(videoLayer!)
        
        // Start the green circle highlighter
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 3
        videoPreviewLayer.addSubview(qrCodeFrameView!)
        videoPreviewLayer.bringSubview(toFront: qrCodeFrameView!)
        self.captureSession?.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel!.text = "Point at Code to Scan"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObjectTypeCode128Code {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoLayer?.transformedMetadataObject(for: metadataObj) as? AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject!.bounds;
            if metadataObj.stringValue != nil {
                messageLabel!.text = metadataObj.stringValue
                // send request to parse with the eventID to grab the name
                self.checkInUser(metadataObj.stringValue)
                self.captureSession?.stopRunning()
            }
        }
    }
    
    func checkInUser (_ title:String) {
        let alertController = UIAlertController(title: "Check-in?", message: title, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // cancelButton tapped
            self.captureSession?.startRunning()
        }
        
        let checkinAction = UIAlertAction(title: "Check-In User", style: .default) { (action) in
            // check the user in
            print("Check-in!")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "checkInView") as! CheckInUserViewController
            vc.objectId = title
            self.present(vc, animated: true, completion: nil)           
        }
        
        
        alertController.addAction(checkinAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async { () -> Void in
            self.present(alertController, animated: true) {
            }
        }
    }

    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
