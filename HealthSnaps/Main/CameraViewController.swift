//
//  ViewController.swift
//  HealthSnaps
//
//  Created by Admin on 11/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
import SCLAlertView

class ViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {    
    
    @IBOutlet weak var torchBtn: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var LoginIndicator: UIActivityIndicatorView!
    
    var captureDeviceAudioFound:Bool = false
    var micPermission:Bool = false
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var captureAudio: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var videoFileOutput: AVCaptureMovieFileOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var limitTimer: Timer!
    var goOverlayView = 0
    
    var isRecording = false
    var outputPath: String!
    var turnOnFlash: Bool!
    var nowBackCamera: Bool!
    
    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginIndicator.isHidden = true
        
        customize()
        
        if !(login) {
            //check_Login()
            auto_loginAPI()
        }
        
        
        // Zoom In recognizer
        zoomInGestureRecognizer.direction = .up
        zoomInGestureRecognizer.addTarget(self, action: #selector(zoomIn))
        view.addGestureRecognizer(zoomInGestureRecognizer)
        
        // Zoom Out recognizer
        zoomOutGestureRecognizer.direction = .down
        zoomOutGestureRecognizer.addTarget(self, action: #selector(zoomOut))
        view.addGestureRecognizer(zoomOutGestureRecognizer)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionFromRight(swipe:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionFromLeft(swipe:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: "transparent")
    }
    
    func customize() {
        
        //setStatusBarBackgroundColor(color: "transparent")
        turnOnFlash = false
        nowBackCamera = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.setupCaptureSession()
            self.setupDevice()
            //self.setupInputOutput()
            self.setupPreviewLayer()
            self.startRunningCaptureSession()
        }
    }
    
    @objc func swipeActionFromRight(swipe: UISwipeGestureRecognizer)
    {
        performSegue(withIdentifier: "PatientViewfromCameraView", sender: self)
    }
    
    @objc func swipeActionFromLeft(swipe: UISwipeGestureRecognizer)
    {
        performSegue(withIdentifier: "MessageViewFromcameraView", sender: self)
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.high
    }
    
    func setupDevice() {
        // Camera Device
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        var captureDeviceVideoFound: Bool = false
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
                captureDeviceVideoFound = true
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
                captureDeviceVideoFound = true
            }
        }
        currentCamera = backCamera
        
        micPermission = checkMicPermission()
        if (micPermission) {
            
            // Mic Device!
            let audioDeviceSession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInMicrophone], mediaType: AVMediaType.audio, position: .unspecified)
            let audioDevices = audioDeviceSession.devices
            
            for mic in audioDevices {
                captureAudio = mic
                captureDeviceAudioFound = true
            }
            
        }
        
        if !(captureDeviceVideoFound) {
            Alert.showInfo(msg: "Camera Invalid!")
        } else if(captureDeviceVideoFound){
            self.setupInputOutput()
        }
        
//        else if !(captureDeviceAudioFound) {
//            //Alert.showInfo(msg: "Mic Invalid! Do you want video with no sound?")
//            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
//            let alert = SCLAlertView(appearance: appearance)
//            alert.addButton("Yes"){ self.setupInputOutput() }
//            alert.addButton("No"){ }
//            alert.showSuccess("Do you want video with no sound?", subTitle: "Mic Invalid")
//        }
    }
    
    func setupInputOutput() {
        do {
//            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
//            captureSession.addInput(captureDeviceInput)
//
//            if (captureDeviceAudioFound && micPermission) {
//                let captureAudioInput = try AVCaptureDeviceInput(device: captureAudio!)
//                captureSession.addInput(captureAudioInput)
//            }
//
//            videoFileOutput = AVCaptureMovieFileOutput()
//            captureSession.addOutput(videoFileOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    // MARK: - Action methods
    
    @IBAction func capture(_ sender: Any) {
        goOverlayView += 1
        videoCapture()
    }
    
    @objc func showLimitTimeAlert() {
        
        videoCapture()
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("OK"){
            self.performSegue(withIdentifier: "OverlayFromCamera", sender: videoFileURL)
        }
        alert.showSuccess("Video Recording Stopped", subTitle: RepMessage.videoLimited.rawValue)
    }
    
    func videoCapture() {
        
        if !isRecording {
            limitTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(showLimitTimeAlert), userInfo: nil, repeats: false)
            isRecording = true
            if let image = UIImage(named: "recording.png") {
                recordButton.setImage(image, for: [])
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: { () -> Void in
                self.recordButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: nil)
            
            outputPath = NSTemporaryDirectory() + "output.mp4"
            let outputFileURL = URL(fileURLWithPath: outputPath)
            videoFileOutput?.movieFragmentInterval = kCMTimeInvalid
            videoFileOutput?.startRecording(to: outputFileURL, recordingDelegate: self)
        } else {
            limitTimer.invalidate()
            isRecording = false
            if let image = UIImage(named: "capture.png") {
                recordButton.setImage(image, for: [])
            }
            
            UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: { () -> Void in
                self.recordButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
            recordButton.layer.removeAllAnimations()
            videoFileOutput?.stopRecording()
            
            //save video file to PhotoAlbum
            //UISaveVideoAtPathToSavedPhotosAlbum(outputPath, nil, nil, nil)
        }
        
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate methods
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error != nil {
            print(error ?? "nil")
            return
        }
        
        videoFileURL = outputFileURL
        if (goOverlayView == 2) {
            performSegue(withIdentifier: "OverlayFromCamera", sender: outputFileURL)
        } else {
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OverlayFromCamera" {
            
            turnOffTorch()
            
            let OverlayViewController = segue.destination as! CameraOverlayViewController
            fromLibrary = false
            OverlayViewController.player = AVPlayer(url: videoFileURL)
            exerciseData["name"] = ""
            exerciseData["reps"] = 0
            exerciseData["sets"] = 0
            exerciseData["hold"] = 0
            exerciseData["freq"] = 0
            exerciseData["days"] = exerciseDays.everyday.rawValue
        }
    }
    
    //
    func turnOffTorch() {
        if (turnOnFlash) {
            turnOnFlash = false
            toggleTorch(on: turnOnFlash)
        }
    }
    
    @IBAction func libraryBtnTapped(_ sender: UIButton) {
        
        turnOffTorch()
        performSegue(withIdentifier: "LibraryViewFromCameraView", sender: self)
    }
    
    @IBAction func menuBtnTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "MenuSegue", sender: self)
        
    }
    
    @IBAction func switch_Camera(_ sender: UIButton) {
        if isRecording { return }
        if (turnOnFlash) {
            torchBtn.setImage(UIImage(named: "flash_off"), for: .normal)
            turnOnFlash = false
        }
        nowBackCamera = !nowBackCamera
        switchCamera()
    }
    
    @objc func switchCamera() {
        captureSession.beginConfiguration()
        
        // Change the device based on the current camera
        let newDevice = (currentCamera?.position == AVCaptureDevice.Position.back) ? frontCamera : backCamera
        
        // Remove all inputs from the session
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        // Change to the new input
        let cameraInput: AVCaptureDeviceInput
        let captureAudioInput: AVCaptureDeviceInput!
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
            if micPermission {
                captureAudioInput = try AVCaptureDeviceInput(device: captureAudio!)
                if captureSession.canAddInput(captureAudioInput) {
                    captureSession.addInput(captureAudioInput)
                }
            }
        } catch {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
            //captureSession.addInput(captureAudioInput)
        }
        
//        if captureSession.canAddInput(captureAudioInput) {
//            captureSession.addInput(captureAudioInput)
//        }
        
        currentCamera = newDevice
        captureSession.commitConfiguration()
    }
    
    @objc func zoomIn() {
        if let zoomFactor = currentCamera?.videoZoomFactor {
            if zoomFactor < 5.0 {
                let newZoomFactor = min(zoomFactor + 1.0, 5.0)
                do {
                    try currentCamera?.lockForConfiguration()
                    currentCamera?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func zoomOut() {
        if let zoomFactor = currentCamera?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                do {
                    try currentCamera?.lockForConfiguration()
                    currentCamera?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // Patient View button tapped
    @IBAction func onPatientTapped(_ sender: UIButton) {
        turnOffTorch()
        performSegue(withIdentifier: "PatientViewfromCameraView", sender: self)
    }
    
    @IBAction func onMessagesTapped(_ sender: UIButton) {
        turnOffTorch()
        performSegue(withIdentifier: "MessageViewFromcameraView", sender: self)
    }
    
    @IBAction func trunFlashTapped(_ sender: UIButton) {
        if !(nowBackCamera) {
            Alert.showInfo(msg: RepMessage.NotNeedFlash.rawValue)
            return
        }
        
        if (turnOnFlash) {
            torchBtn.setImage(UIImage(named: "flash_off"), for: .normal)
        } else {
            torchBtn.setImage(UIImage(named: "flash_on"), for: .normal)
        }
        turnOnFlash = !turnOnFlash
        toggleTorch(on: turnOnFlash)
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used!")
            }
        } else {
            print("Torch is not available!")
        }
    }
        
    //check
    func check_Login() {
        
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email")
        if email == "" {
            return
        }
        
        if let login_time = defaults.string(forKey: "login_time") {
            
            let now = NSDate()
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .short
            formatter.allowedUnits = [.minute]
            formatter.maximumUnitCount = 1
            
            let lastDate = stringToDateYMD_HMS(stringDate: login_time)
            let lastLogin = formatter.string (from: lastDate, to: now as Date)
            let lastLoginMin = (lastLogin?.components(separatedBy: " ").first)?.replacingOccurrences(of: ",", with: "")
            
            print("***------------ From here")
            print(lastLoginMin ?? "1000")
            
            if (Int(lastLoginMin!)! < 64) {
                
                self.auto_loginAPI()
                
            } else {
                print("Login time over")
                return
            }
            
        } else {
            print("first login")           
            return
        }
    }
    
    //Auto relogin API!
    func auto_loginAPI() {
        
        //ActivityIndicator show
        showLoginIndicator()
        
        let requestURL = BackendEndpoints.getAutoLogin()
        
        let defaults = UserDefaults.standard
        let access_token = defaults.string(forKey: "access_token")
        let auth = access_token! + ":"
        let base64Credentials = base64Encoded(auth: auth)
        let accessTokenEncoded = "Basic " + base64Credentials
        
        let headers = ["Authorization": accessTokenEncoded as String]
        
        print("***------------ From here again")
        
        NetworkManager.JSON(params: [:], URL: requestURL, method: .get, headers: headers, completion: { (result) in

            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                let user = result["user"] as! [String: Any]
                
                print(user)
                // create new user class!
                let newUser = User(username: (user["username"] as? String)!, password: "xxxx",
                                   account_id: (user["account_id"] as? String)!)
                StaticData.setUser(user: newUser)
                
                StaticData.getUser().setUserId(userId: (user["id"] as? String)!)
                StaticData.getUser().setAccess_token(access_token: access_token!)
                StaticData.getUser().setStatus(status: (user["status"] as? String)!)
                StaticData.getUser().setMfa_enrolled(mfa_enrolled: (user["mfa_enrolled"] as? Bool)!)
                
                print(RepMessage.Login_SUCCESS.rawValue)                
                
                self.getUserInfo()
                
            } else {
                
                print(result)
                //NetworkManager.showErrorAlert(result: result)
                self.LoginIndicator.stopAnimating()
                print(RepMessage.InvalidRequest.rawValue)
            }

        })
    }
    
    // Get User Info from server
    func getUserInfo() {
        
        let requestURL = BackendEndpoints.getUsers() + StaticData.getUser().getUserId() + "?full=true"
        let accessTokenEncoded = AccessTokenEncoded()
        
        let headers = ["Authorization": accessTokenEncoded as String,
                       "Content-Type": HeaderType.ContentType.rawValue as String]
        
        NetworkManager.JSON(params: [:], URL: requestURL, method: .get, headers: headers, completion: { (result) in
            
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                
                let user = result["user"] as! [String: Any]
                
                let attributesString    = base64Decoded(encodedString: (user["attributes"] as? String)!)
                do {
                    
                    let attributes = try convertToDictionary(from: attributesString)
                    
                    StaticData.getUser().setAttributes(attributes: attributes)
                    StaticData.getUser().setGroup_ids(group_ids: (user["group_ids"] as? NSArray)!)
                    
                    login = true                    
                    
                } catch {
                    print(error) //
                }
                
                print(RepMessage.GetUserInfo_SUCCESS.rawValue)
                // ActivityIndicator hide
                self.LoginIndicator.stopAnimating()              
                
            } else {
                
                NetworkManager.showErrorAlert(result: result)
                self.LoginIndicator.stopAnimating()
            }
            
        })
        
    }
    
    // Show ActivityIndicator!
    func showLoginIndicator() {
        
        LoginIndicator.isHidden = false
        LoginIndicator.hidesWhenStopped = true
        LoginIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        //LoginIndicator.color = UIColor.blue
        LoginIndicator.startAnimating()
        
    }
    
}


