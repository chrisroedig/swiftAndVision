import Cocoa
import AVFoundation
import AVKit
import QuartzCore
import XCPlayground

var view = NSView(frame:
    NSRect(x: 0, y: 0, width: 640, height: 480))

var sess = AVCaptureSession()

sess.sessionPreset = AVCaptureSessionPreset640x480
sess.beginConfiguration()
sess.commitConfiguration()

var input : AVCaptureDeviceInput! = nil
var err: NSError?
var devices: [AVCaptureDevice] = AVCaptureDevice.devices() as [AVCaptureDevice]

AVCaptureDevice .defaultDeviceWithMediaType(AVMediaTypeVideo)
for device in devices {
    if device.hasMediaType(AVMediaTypeVideo) && device.supportsAVCaptureSessionPreset(AVCaptureSessionPreset640x480) {
        
        input = AVCaptureDeviceInput.deviceInputWithDevice(device as AVCaptureDevice, error: &err) as AVCaptureDeviceInput
        
        if sess.canAddInput(input) {
            sess.addInput(input)
            break
        }
    }
}

var settings = [kCVPixelBufferPixelFormatTypeKey as NSString:kCVPixelFormatType_32BGRA]

var output = AVCaptureVideoDataOutput()
output.videoSettings = settings
output.alwaysDiscardsLateVideoFrames = true

if sess.canAddOutput(output) {
    sess.addOutput(output)
}

var captureLayer = AVCaptureVideoPreviewLayer(session: sess)

view.wantsLayer = true
view.layer = captureLayer

sess.startRunning()

