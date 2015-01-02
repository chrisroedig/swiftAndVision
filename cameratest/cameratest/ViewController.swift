//
//  ViewController.swift
//  cameratest
//
//  Created by Christoph Roedig on 1/1/15.
//  Copyright (c) 2015 Offroed. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit
import QuartzCore

class ViewController: NSViewController {

    var avCaptureSession : AVCaptureSession?
    var avCaptureDevices: [AVCaptureDevice]!
    var avCurrentCaptureDevice: AVCaptureDevice?
    var avCaptureInput: AVCaptureDeviceInput?
    var avOutput: AVCaptureVideoDataOutput?
    
    @IBOutlet weak var cameraPicker: NSPopUpButton!
    @IBOutlet weak var camView: NSView!
    
    // MARK: - NSViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureCapture()
        self.enumerateCameras()
        self.startCaptureOnFirstCamera()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: - Camera Operations
    func configureCapture(){
        self.avCaptureSession = AVCaptureSession()
        self.avCaptureSession?.sessionPreset = AVCaptureSessionPreset640x480
        self.avCaptureSession?.beginConfiguration()
        self.avCaptureSession?.commitConfiguration()
        
        self.avOutput = AVCaptureVideoDataOutput()

        
        
        self.avOutput?.videoSettings =
            [kCVPixelBufferPixelFormatTypeKey
                as NSString:kCVPixelFormatType_32BGRA]
        self.avOutput?.alwaysDiscardsLateVideoFrames = true
        
        if (self.avCaptureSession?.canAddOutput(self.avOutput) != nil) {
            self.avCaptureSession?.addOutput(self.avOutput)
        }
        
        var captureLayer = AVCaptureVideoPreviewLayer(
            session: self.avCaptureSession)
        
        self.camView.wantsLayer = true
        self.camView.layer = AVCaptureVideoPreviewLayer(
            session: self.avCaptureSession)
    
    }
    
    func enumerateCameras(){
        self.avCaptureDevices =
            AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
            as [AVCaptureDevice]
        
        self.cameraPicker.removeAllItems()
        
        for device in self.avCaptureDevices{
            self.cameraPicker.addItemWithTitle(device.localizedName)
        }
        
    }
    func selectCameraByIndex(cam_index : Int ){
        let device = self.avCaptureDevices[cam_index];
        var err: NSError?
        if( !device.hasMediaType(AVMediaTypeVideo) ){
            return;
        }
        self.avCurrentCaptureDevice = device
        self.avCaptureSession?.removeInput(self.avCaptureInput)
        self.avCaptureInput =
            AVCaptureDeviceInput.deviceInputWithDevice(
                device as AVCaptureDevice, error: &err)
            as? AVCaptureDeviceInput
        
        self.avCaptureSession?.addInput(self.avCaptureInput)
        
    }
    func startCapture(){
        self.avCaptureSession?.startRunning()
    }
    func endCapture(){
        self.avCaptureSession?.stopRunning()
    }
    func startCaptureOnFirstCamera(){
        if(self.avCaptureDevices.count<1){
            return;
        }
        self.selectCameraByIndex(0)
        self.startCapture()
    }

    // MARK: - IBActions
    @IBAction func refreshBtnClicked(sender: AnyObject) {
        self.endCapture()
        self.enumerateCameras()
    
    }
    
    @IBAction func cameraSelected(sender: NSPopUpButton) {
        endCapture()
        self.selectCameraByIndex(sender.indexOfSelectedItem)
        startCapture()
        
    }
    
    


}

