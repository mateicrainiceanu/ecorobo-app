//
//  ViewController.swift
//  EcoRobot
//
//  Created by Matei Crăiniceanu on 04.05.2023.
//
import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var requestNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let captureSession = AVCaptureSession()
        
//        captureSession.beginConfiguration()
//        captureSession.sessionPreset = .hd1920x1080
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }

        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }

        captureSession.addInput(input)

        let dataOutput = AVCaptureVideoDataOutput()
        captureSession.addOutput(dataOutput)
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        let captureConnection = dataOutput.connection(with: .video)
        // Always process the frames
        captureConnection?.isEnabled = true

        //captureSession.commitConfiguration()
        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame

    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.global(qos: .background).async {


        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: DozaSticlaPlastic(configuration: MLModelConfiguration()).model) else {fatalError("Could not import model...")}

        let request = VNCoreMLRequest(model: model, completionHandler: {(req, err) in

            if let results = req.results as? [VNRecognizedObjectObservation]{

                if let recognizedObject = results.first {
                    //print(recognizedObject)
                    let box = recognizedObject.boundingBox
                    
                    if let observation = recognizedObject.labels.first {
                        let rObj = Recognition(box: box, name: observation.identifier, confidence: observation.confidence)
                        rObj.getValues()
                    }

                }
            }
        })

            try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer).perform([request])
        }

    }

}

