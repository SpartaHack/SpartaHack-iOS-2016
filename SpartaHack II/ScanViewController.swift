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
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
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
    
    override func viewDidAppear(animated: Bool) {
        videoLayer?.frame = CGRectMake(0, 0, self.videoPreviewLayer.frame.width, self.videoPreviewLayer.frame.height)
        videoPreviewLayer.layer.addSublayer(videoLayer!)
        
        // Start the green circle highlighter
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 3
        videoPreviewLayer.addSubview(qrCodeFrameView!)
        videoPreviewLayer.bringSubviewToFront(qrCodeFrameView!)
        self.captureSession?.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            messageLabel!.text = "Point at Code to Scan"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObjectTypeCode128Code {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoLayer?.transformedMetadataObjectForMetadataObject(metadataObj) as? AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject!.bounds;
            if metadataObj.stringValue != nil {
                messageLabel!.text = metadataObj.stringValue
                // send request to parse with the eventID to grab the name
                self.checkInUser(metadataObj.stringValue)
                self.captureSession?.stopRunning()
            }
        }
    }
    
    func checkInUser (title:String) {
        let alertController = UIAlertController(title: "Check-in?", message: title, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // cancelButton tapped
            self.captureSession?.startRunning()
        }
        
        let checkinAction = UIAlertAction(title: "Check-In User", style: .Default) { (action) in
            // check the user in
            print("Check-in!")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("checkInView") as! CheckInUserViewController
            vc.objectId = title
            self.presentViewController(vc, animated: true, completion: nil)           
        }
        
        let hardwareOutAction = UIAlertAction(title: "Hardware Check Out", style: .Default) { (action) -> Void in
            
        }
        
        let hardwareInAction = UIAlertAction(title: "Hardware Check In", style: .Default) { (action) -> Void in
            
        }
        
        alertController.addAction(checkinAction)
        alertController.addAction(hardwareOutAction)
        alertController.addAction(hardwareInAction)
        alertController.addAction(cancelAction)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.presentViewController(alertController, animated: true) {
            }
        }
    }

    @IBAction func closeButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
