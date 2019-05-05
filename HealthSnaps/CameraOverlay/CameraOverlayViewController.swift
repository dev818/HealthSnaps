//
//  CameraOverlayViewController.swift
//  HealthSnaps
//
//  Created by Admin on 02/12/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit
import AVFoundation
import ActionSheetPicker_3_0
import IQKeyboardManagerSwift
import SCLAlertView
import Alamofire
import MultilineTextField

class CameraOverlayViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var loginViewCancelBtn: UIButton!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginEmailTextFld: UITextField!
    @IBOutlet weak var loginPasswordTextFld: UITextField!
    
    @IBOutlet weak var overlayMutiTextField: MultilineTextField!
    @IBOutlet weak var centerSaveModalConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveLibraryView: UIView!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var showOverlayedText: UILabel!
    @IBOutlet weak var textBack: UIImageView!
    @IBOutlet weak var overlayVideoActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveModalBackView: UIView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var saveLibraryButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!    
    @IBOutlet weak var saveBtnSaveModal: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var repsValueLbl: UILabel!
    @IBOutlet weak var setsValueLbl: UILabel!
    @IBOutlet weak var holdValueLbl: UILabel!
    @IBOutlet weak var freqValueLbl: UILabel!
    
    var patientInfo: [String : Any] = [:]
    var patientObj: [String : Any] = [:]
    var player: AVPlayer!
    let playerLayer = AVPlayerLayer()
    var finishedOverlay: Bool!
    var overlayTimer: Timer!
    var signedURL: String!
    var exerciseObj: [String : Any] = [:]
    var exerciseID: String!
    //var base64VideoPlaying: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customize()        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //overlayTimer.invalidate()
    }
    
    //
    func customize() {
        
        setStatusBarBackgroundColor(color: "transparent")
        
        loginViewCancelBtn.setTitleColor(UIColor(hexString: "#e67e22"), for: .normal)
        //loginIndicator.isHidden = true
        loginView.isHidden = true
        loginView.layer.cornerRadius = 15
        loginView.layer.borderWidth = 1
        loginView.layer.borderColor = UIColor.gray.cgColor
        loginEmailTextFld.returnKeyType = UIReturnKeyType.done
        loginEmailTextFld.delegate = self
        loginPasswordTextFld.returnKeyType = UIReturnKeyType.done
        loginPasswordTextFld.delegate = self
        
        saveLibraryView.isHidden = true
        saveLibraryView.layer.cornerRadius = 15
        saveModalBackView.isHidden = true
        saveBtnSaveModal.setTitleColor(UIColor(hexString: "#e67e22"), for: .normal)
        
        overlayMutiTextField.delegate = self
        overlayMutiTextField.isHidden = true
        overlayMutiTextField.returnKeyType = UIReturnKeyType.done
        
        nameTextField.delegate = self
        nameTextField.returnKeyType = UIReturnKeyType.done
        
        repsValueLbl.text = String(exerciseData["reps"] as! Int)
        setsValueLbl.text = String(exerciseData["sets"] as! Int)
        holdValueLbl.text = String(exerciseData["hold"] as! Int)
        freqValueLbl.text = String(exerciseData["freq"] as! Int)
        
        IQKeyboardManager.sharedManager().disabledToolbarClasses = [CameraOverlayViewController.self]
        
        showOverlayedText.isHidden = true
        textBack.isHidden = true
        overlayVideoActivityIndicator.isHidden = true
        
        if (fromHepToOverlay) {
            updateButton.backgroundColor = UIColor(hexString: "#2980b9")
            updateButton.layer.cornerRadius = 5
            updateButton.layer.borderWidth = 1
            updateButton.layer.borderColor = UIColor.white.cgColor
            updateButton.isHidden = false
            sendButton.isHidden = true
            saveLibraryButton.isHidden = true
        }
        
        createAVLayer()
    }
    
    func showLoginModal() {
        
//        loginEmailTextFld.text = userInfo.username.rawValue
//        loginPasswordTextFld.text = userInfo.password.rawValue
        
        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: "email") {
            loginEmailTextFld.text = email
        }
        
        saveModalBackView.isHidden = false
        saveModalBackView.alpha = 0.1
        loginView.isHidden = false
        centerYConstraint.constant = 0
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.53, initialSpringVelocity: 0, options: .curveEaseOut, animations: { self.view.layoutSubviews() }, completion: nil)
        
    }
    
    func closeLoginModal() {
        
        saveModalBackView.isHidden = true
        loginView.isHidden = true
        centerYConstraint.constant = 900
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.53, initialSpringVelocity: 0, options: .curveEaseOut, animations: { self.view.layoutSubviews() }, completion: nil)
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        
        login_User()
    }
    
    @IBAction func loginCancelBtnTapped(_ sender: UIButton) {
        
        closeLoginModal()
    }
    
    @IBAction func signupBtnTapped(_ sender: UIButton) {
        
        NetworkManager.openWebsite()
    }
    
    //
    func createTextLayer() {
        
        textBack.isHidden = false
        showOverlayedText.isHidden = false
        showOverlayedText.text = overlayMutiTextField.text!
        
        overlayMutiTextField.isHidden = true
        self.view.endEditing(true)
        
    }
    
    // Create AV Player!
    func createAVLayer() {
            
        playerLayer.frame = self.videoContainerView.bounds
        //playerLayer.frame = CGRect(x:43, y:3, width:self.view.frame.width - 86, height:self.view.frame.height - 23)
            
        if videoFileURL != nil {
            
            player.actionAtItemEnd = .none
            playerLayer.player = player
            self.videoContainerView.layer.addSublayer(playerLayer)
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerDidReachEnd),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem)
            player.play()
            
        } else {
            
            getBlobVideo()
        }
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func playerDidReachEnd(notification: NSNotification) {
        let playerItem = notification.object as! AVPlayerItem
        playerItem.seek(to: kCMTimeZero, completionHandler: nil)
    }
    
    // different Actions!
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        
        if (fromHepToOverlay) {
            
            //if (base64VideoPlaying) {
                player.pause()
            //    base64VideoPlaying = false
            //}
            fromHepToOverlay = false
            self.performSegue(withIdentifier: "hepFromOverlay", sender: self)
        
        } else if (fromLibrary) {
            
            self.player.pause()
            self.performSegue(withIdentifier: "LibraryFromOverlay", sender: self)
            
        } else {
            
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("OK"){
                self.player.pause()
                self.performSegue(withIdentifier: "CameraFromOverlay", sender: self)                
            }
            alert.addButton("CANCEL"){
                return
            }
            alert.showSuccess("Info", subTitle: "Are you sure?")
            
        }       
        
    }
    
    // convert patientInfo to Chat View!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "hepFromOverlay") {
            let vc = segue.destination as! HepViewController
            vc.patientInfo = patientInfo
            vc.patientObj = patientObj            
        }
        
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
        //IQKeyboardManager.sharedManager().enabledToolbarClasses = [CameraOverlayViewController.self]
        
        if (login) {
            
            showSaveLibraryModal()
            
        } else {
            
            showLoginModal()
        }
        
    }
    
    func showSaveLibraryModal() {
        
        if (fromLibrary) {
            Alert.showInfo(msg: RepMessage.SavedExercise.rawValue)
            return
        } else if (exerciseData["name"] as! String) == "" {
            Alert.showInfo(msg: RepMessage.enterExerciseName.rawValue)
            return
        } else if !(finishedOverlay) {
            Alert.showInfo(msg: RepMessage.NotFinishOverlay.rawValue)
            return
        }
        
        centerSaveModalConstraint.constant = 0
        saveLibraryView.isHidden = false
        saveModalBackView.isHidden = false
        DispatchQueue.main.async {
            self.nameTextField.text = exerciseData["name"] as? String
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: { self.view.layoutIfNeeded() }, completion: nil)
    }
    
    func overlayTextToVideo() {
        
        //
        showOverlayIndicator()
        finishedOverlay = false
        
        //
        let fps: Int32 = 30
        let micPermission = checkMicPermission()
        
        let composition = AVMutableComposition()
        let asset = AVURLAsset(url: videoFileURL, options: nil)
        
        let track =  asset.tracks(withMediaType: AVMediaType.video)
        let videoTrack: AVAssetTrack = track[0] as AVAssetTrack
        let timerange = CMTimeRangeMake(kCMTimeZero, asset.duration)
        
        let compositionVideoTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())!
        
        do {
            try compositionVideoTrack.insertTimeRange(timerange, of: videoTrack, at: kCMTimeZero)
                compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        } catch {
            print(error)
        }
        
        if micPermission {
            let atrack =  asset.tracks(withMediaType: AVMediaType.audio)
            let audioTrack: AVAssetTrack = atrack[0] as AVAssetTrack
            let audio_timerange = CMTimeRangeMake(kCMTimeZero, asset.duration)
            
            let compositionAudioTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
            
            do {
                try compositionAudioTrack.insertTimeRange(audio_timerange, of: audioTrack, at: kCMTimeZero)
                compositionAudioTrack.preferredTransform = audioTrack.preferredTransform
                
            } catch {
                print(error)
            }
            
        }
        
        var size = videoTrack.naturalSize
        size = CGSize(width: size.height, height: size.width)
        //print(size)
        
        let textLayer = CATextLayer()
        let backLayer = CALayer()
        
        if size.width == 1080 {
            textLayer.frame = CGRect(x:45, y:size.height - (168 + textBack.bounds.height * 3), width: size.width - 90, height: textBack.bounds.height * 3)
            textLayer.fontSize = 60
            
            backLayer.frame = CGRect(x:0, y:size.height - (138 + textBack.bounds.height * 3), width: size.width, height: textBack.bounds.height * 3)
        } else {
            textLayer.frame = CGRect(x:30, y:size.height - (112 + textBack.bounds.height * 2), width: size.width - 60, height: textBack.bounds.height * 2)
            textLayer.fontSize = 40
            
            backLayer.frame = CGRect(x:0, y:size.height - (92 + textBack.bounds.height * 2), width: size.width, height: textBack.bounds.height * 2)
        }
        textLayer.string = overlayMutiTextField.text!
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.isWrapped = true
        textLayer.alignmentMode = kCAAlignmentCenter
        
        backLayer.backgroundColor = UIColor.black.cgColor
        backLayer.opacity = 0.7
        
        let videolayer = CALayer()
        videolayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let parentlayer = CALayer()
        parentlayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        parentlayer.addSublayer(videolayer)
        parentlayer.addSublayer(backLayer)
        parentlayer.addSublayer(textLayer)
        
        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(1, fps)
        layercomposition.renderSize = CGSize(width: size.width, height: size.height)
        layercomposition.renderScale = 1.0
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videolayer, in: parentlayer)

        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
        
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        layerInstruction.setTransform(videoTrack.preferredTransform, at: kCMTimeZero)
        
        instruction.layerInstructions = [layerInstruction]
        layercomposition.instructions = [instruction]
        
        if ((exportedVideoURL) != nil) {
            
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(at: exportedVideoURL)
            } catch {
                print(error)
            }
        }

        let now = NSDate()
        let nowString = dateToStringYMD_HMS(date: now as Date)
        videoName = nowString + ".mp4"
        
//        let randName = String(arc4random_uniform(10000000))
//        videoName = randName + ".m4v"
        let documentsDirectory = getDocumentsDirectory()
        let movieUrl = documentsDirectory.appendingPathComponent(videoName)
        
        guard let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetMediumQuality) else {return}
        assetExport.videoComposition = layercomposition
        assetExport.outputFileType = AVFileType.mp4
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.outputURL = movieUrl
        exportedVideoURL = movieUrl
        fromLibrary = false
        
        overlayTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runTimeGetFinishedOverlay), userInfo: nil, repeats: true)
        
        assetExport.exportAsynchronously(completionHandler: {
            
            switch assetExport.status {
            case .completed:
                print("success")
                print(exportedVideoURL)
                self.finishedOverlay = true
                break
            case .cancelled:
                print("cancelled")
                break
            case .exporting:
                print("exporting")
                break
            case .failed:
                print(exportedVideoURL)
                print("failed: \(assetExport.error!)")
                break
            case .unknown:
                print("unknown")
                break
            case .waiting:
                print("waiting")
                break
            }
        })
        
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // Show ActivityIndicator!
    func showOverlayIndicator() {
        
        overlayVideoActivityIndicator.isHidden = false
        overlayVideoActivityIndicator.hidesWhenStopped = true
        overlayVideoActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        //overlayVideoActivityIndicator.color = UIColor.gray
        overlayVideoActivityIndicator.startAnimating()
        
    }
    
    // Stop Activity
    @objc func runTimeGetFinishedOverlay() {
        
        print("get")
        if (finishedOverlay) {
            overlayVideoActivityIndicator.stopAnimating()
            overlayTimer.invalidate()
        }
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        
        if (exerciseData["name"] as! String) == "" {
            Alert.showInfo(msg: RepMessage.enterExerciseName.rawValue)
        } else if !(finishedOverlay) {
            Alert.showInfo(msg: RepMessage.NotFinishOverlay.rawValue)
        } else {
            player.pause()
            performSegue(withIdentifier: "SendViewFromOverlay", sender: self)
        }
    }
    
    @IBAction func textBtnTapped(_ sender: UIButton) {
        
        //IQKeyboardManager.sharedManager().disabledToolbarClasses = [CameraOverlayViewController.self]
        if (fromLibrary) {
            Alert.showInfo(msg: RepMessage.EnteredExerciseName.rawValue)
        } else {
            self.overlayMutiTextField.isHidden = false
            self.overlayMutiTextField.becomeFirstResponder()            
        }
    }
    
    // TextField Keybord "Done" Tapped!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
        textField.resignFirstResponder()
        return true
        
    }
    
    // TextView Keybord "Done" Tapped!
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            let name = self.overlayMutiTextField.text!
            self.overlayMutiTextField.text = name.firstUppercased
            
            if fromHepToOverlay {
                exerciseData["name"] = self.overlayMutiTextField.text!
                self.overlayMutiTextField.isHidden = true
            } else {
                self.createTextLayer()
                
                DispatchQueue.main.async {
                    self.overlayTextToVideo()
                    exerciseData["name"] = self.overlayMutiTextField.text!
                }
            }
            
            self.overlayMutiTextField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
        
        updateExerciseAPI()
        
    }
    
    @IBAction func repsBtnTapped(_ sender: UIButton) {
        
        let repValues = (0...99).map { String($0) }
        let acp = ActionSheetMultipleStringPicker(title: "Reps", rows: [repValues], initialSelection: [0],
                doneBlock: {
                picker, value, index in
                if let selectedValue = index as? Array<String> {
                    
                    exerciseData["reps"] = Int(selectedValue[0])
                    self.repsValueLbl.text = String(exerciseData["reps"] as! Int)
                }
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender.superview!.superview)
        acp?.show()
        
    }
    
    @IBAction func setsBtnTapped(_ sender: UIButton) {
        
        let setValues = (0...99).map { String($0) }
        let acp = ActionSheetMultipleStringPicker(title: "Sets", rows: [setValues], initialSelection: [0],
                doneBlock: {
                picker, value, index in
                if let selectedValue = index as? Array<String> {
                    
                    exerciseData["sets"] = Int(selectedValue[0])
                    self.setsValueLbl.text = String(exerciseData["sets"] as! Int)
                }
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender.superview!.superview)
        acp?.show()
    }
    
    @IBAction func timerBtnTapped(_ sender: UIButton) {
        
        let minValues = (0...59).map { String($0) }
        let secValues = (0...59).map { String($0) }
        let acp = ActionSheetMultipleStringPicker(title: "Timer(minutes,seconds)", rows: [minValues, secValues],        initialSelection: [0, 0], doneBlock: {
                picker, values, indexes in
                if let selectedValues = indexes as? Array<String> {
                    
                    let min = selectedValues[0]
                    let sec = selectedValues[1]
                    let hold = Int(min)! * 60 + Int(sec)!
                    exerciseData["hold"] = hold
                    
                    if hold < 100 {
                        self.holdValueLbl.font = self.holdValueLbl.font.withSize(14)
                    } else if hold >= 100 && hold < 1000 {
                        self.holdValueLbl.font = self.holdValueLbl.font.withSize(11)
                    } else if hold >= 1000 {
                        self.holdValueLbl.font = self.holdValueLbl.font.withSize(8)
                    }
                    self.holdValueLbl.text = String(exerciseData["hold"] as! Int)
                    
                }
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender.superview!.superview)
        acp?.show()
    }
    
    @IBAction func freqBtnTapped(_ sender: UIButton) {
        
        let setValues = (0...99).map { String($0) }
        let acp = ActionSheetMultipleStringPicker(title: "Frequency", rows: [setValues], initialSelection: [0],
                doneBlock: {
                picker, value, index in
                if let selectedValue = index as? Array<String> {
                    
                    exerciseData["freq"] = Int(selectedValue[0])
                    self.freqValueLbl.text = String(exerciseData["freq"] as! Int)
                }
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender.superview!.superview)
        acp?.show()
    }
    
    
    @IBAction func calenderBtnTapped(_ sender: UIButton) {
        
        let calenderValues = [exerciseDays.everyday.rawValue,
                              exerciseDays.weekday.rawValue,
                              exerciseDays.everyotherday.rawValue]
        
        let acp = ActionSheetMultipleStringPicker(title: "Select day", rows: [calenderValues], initialSelection: [0],
                doneBlock: {
                picker, value, index in
                if let selectedValue = index as? Array<String> {
                    
                    exerciseData["days"] = selectedValue[0]
                }
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender.superview!.superview)
        acp?.show()
    }
    
    @IBAction func nameTextEditingDidEnd(_ sender: UITextField) {
        
        let name = nameTextField.text!
        nameTextField.text = name.firstUppercased
    }
    
    @IBAction func saveLibraryBtnTapped(_ sender: UIButton) {
        
        getSignedUrlAPI()
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        
        closeSaveLibraryModalView()
    }
    
    // close Modal View!
    func closeSaveLibraryModalView() {
        
        centerSaveModalConstraint.constant = -670
        saveLibraryView.isHidden = true
        saveModalBackView.isHidden = true
        
        view.endEditing(true)
    }
    
    // API Call 15 - GET SIGNED URL
    func getSignedUrlAPI() {
        
        // show Alert!
        Alert.showWaiting(msg: RepMessage.SavingToLibray.rawValue)
        
        let requestURL = BackendEndpoints.getSignedUrl()
        let headers = ["Content-Type": HeaderType.ContentType.rawValue as String]
        let data = ["fileName": videoName as String]
                Alamofire.request(requestURL, method: .post, parameters: data, headers: headers)
            .responseString { response in
           
                let result: String = response.description
                var index = result.index(result.startIndex, offsetBy: 7)
                //let head = String(result[..<index])
                index = result.index(result.startIndex, offsetBy: 9)
                self.signedURL = String(result[index...])
                
                print("Get Signed URL Success!")
                self.uploadVideo()
        }
    }
    
    // API Call 16 - Upload Video
    func uploadVideo() {
        
        let requestURL = signedURL
        let headers = ["Content-Type": "video/mp4"]
        //print(exportedVideoURL)
        
        Alamofire.upload(exportedVideoURL, to: requestURL!, method: .put, headers: headers).responseData { response in

            print(response)

            let result: String = response.description
            let index = result.index(result.startIndex, offsetBy: 7)
            let head = String(result[..<index])

            if (head == RepResult.uperSUCCESS.rawValue) {
                
                print("Upload Video Success!")
                self.saveToLibraryAPI()
            } else {

                // Alert hide
                Alert.hideWaitingAlert()
                Alert.showError(msg: RepMessage.TimeOut.rawValue)
            }
        }
        
    }
    
    //API Call 17 - Save to Library
    func saveToLibraryAPI() {
        
        let s3URL = BackendEndpoints.getS3URL() + videoName
        let name = exerciseData["name"] as! String
        let therapistID = StaticData.getUser().getUserId()
        let data = ["S3URL": s3URL, "S3ImgURL": "", "Name": name,
                    "Description": "", "TherapistID": therapistID]
        
        let requestURL = BackendEndpoints.getSaveToLibrary()
        
        //print(data)
        
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: [:], completion: { (result) in
            
            print(result)
            if (result["id"] as! String) != "" {
                
                print(RepMessage.SaveToLibrary_SUCCESS.rawValue)
                
                // Alert hide
                Alert.hideWaitingAlert()
                self.closeSaveLibraryModalView()
                
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("Done"){
                    
                }
                alert.showSuccess("Congratulations", subTitle: RepMessage.SaveToLibrary_SUCCESS.rawValue)
                
                getExerciseLib = false
                
            } else {
                
                // Alert hide
                Alert.hideWaitingAlert()
                NetworkManager.showErrorAlert(result: result)
            }
        })
    }
    
    // user Login
    func login_User() {
        
        //ActivityIndicator show
        showLoginIndicator()
        
        // create new user class!
        let newUser = User(username: loginEmailTextFld.text!, password: loginPasswordTextFld.text!,
                           account_id: Ids.Account_ID.rawValue)
        StaticData.setUser(user: newUser)
        
        var Data = newUser.getUserLoginFields()
        
        let now = Date()
        //let after14Days = Calendar.current.date(byAdding: .day, value: 14, to: now)
        let not_valid_after = dateToStringYMD_HMS_SSSZ(date: now)
        Data["not_valid_after"] = not_valid_after as AnyObject
        print(Data)
        
        let requestURL = BackendEndpoints.getLogin()
        
        // Request user Login
        NetworkManager.JSON(params: Data, URL: requestURL, method: .post, headers: [:], completion: { (result) in
            
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                let user = result["user"] as! [String: Any]
                
                StaticData.getUser().setUserId(userId: (user["id"] as? String)!)
                StaticData.getUser().setAccess_token(access_token: (user["access_token"] as? String)!)
                StaticData.getUser().setStatus(status: (user["status"] as? String)!)
                StaticData.getUser().setMfa_enrolled(mfa_enrolled: (user["mfa_enrolled"] as? Bool)!)
                
                login = true
                print(RepMessage.Login_SUCCESS.rawValue)
                
                self.view.endEditing(true)
                //self.getUserInfo()
                self.saveDeviceToken()
                
            } else {
                
                //print(result)
                NetworkManager.showErrorAlert(result: result)
                self.overlayVideoActivityIndicator.stopAnimating()
                print(RepMessage.InvalidRequest.rawValue)
            }
            
        })
    }
    
    // Save DeviceToken to new DB
    func saveDeviceToken() {
        
        let requestURL = BackendEndpoints.getSaveDeviceTokenToDB()
        let data = ["UserID": StaticData.getUser().getUserId(),
                    "DeviceToken": device_tokenString]  as [String : Any]
        
        print (requestURL)
        print (data)
        
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: [:], completion: { (result) in
            
            print(result)
            print("Save devicetoken success!")
            self.getUserInfo()
            
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
                    
                } catch {
                    print(error) //
                }
                
                // save info to localstorage
                let now = NSDate()
                let defaults = UserDefaults.standard
                defaults.set(self.loginEmailTextFld.text!, forKey: "email")
                defaults.set(StaticData.getUser().getAccess_token(), forKey: "access_token")
                defaults.set(dateToStringYMD_HMS(date: now as Date), forKey: "login_time")
                
                
                print(RepMessage.GetUserInfo_SUCCESS.rawValue)
                // ActivityIndicator hide
                self.overlayVideoActivityIndicator.stopAnimating()
                self.closeLoginModal()
                self.showSaveLibraryModal()
                
            } else {
                
                NetworkManager.showErrorAlert(result: result)
                self.overlayVideoActivityIndicator.stopAnimating()
            }
            
        })
        
    }
    
    
    // Show ActivityIndicator!
    func showLoginIndicator() {
        
        overlayVideoActivityIndicator.isHidden = false
        overlayVideoActivityIndicator.hidesWhenStopped = true
        overlayVideoActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        overlayVideoActivityIndicator.startAnimating()
        
    }
    
    // update Exercise API!
    func updateExerciseAPI() {
        
        Alert.showWaiting(msg: RepMessage.UpdatingExercise.rawValue)
        
        exerciseObj["Name"] = exerciseData["name"]
        exerciseObj["Hold"] = exerciseData["hold"]
        exerciseObj["Frequency"] = exerciseData["freq"]
        exerciseObj["Reps"] = exerciseData["reps"]
        exerciseObj["Sets"] = exerciseData["sets"]
        
        if (exerciseObj["VideoBlobID"] != nil) {
            exerciseObj["Video"] = ""
        }
        
        if (exerciseObj["ImgBlobID"] != nil) {
            exerciseObj["Img"] = ""
        }
        
        let newData: String = JSONStringify(value: exerciseObj)
        let base64Data = base64Encoded(auth: newData)
        let data = ["document": base64Data]
        
        //let exerciseID = exerciseObj["ID"] as! String
        let requestURL = BackendEndpoints.getpatientsList() + Ids.GetExercises_ID.rawValue + "/documents/" + exerciseID
        
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Authorization": accessTokenEncoded as String,
                       "Content-Type": HeaderType.ContentType.rawValue as String]
        
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .put, headers: headers, completion: { (result) in

            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {

                print("Updating Exercise Success!")

                // Alert hide
                Alert.hideWaitingAlert()

                getExercise = false
                self.performSegue(withIdentifier: "hepFromOverlay", sender: self)

            } else {

                // Alert hide
                Alert.hideWaitingAlert()
                NetworkManager.showErrorAlert(result: result)
            }
        })
    }
    
    //get BlobVideo API!
    func getBlobVideo() {
        
        cancelButton.isEnabled = false
        
        //Alert.showWaiting(msg: RepMessage.GettingVideo.rawValue)
        
        let blobID = self.exerciseObj["VideoBlobID"] as! String
        let requestURL = BackendEndpoints.getpatientsList() + Ids.GetSaveVideoFile_ID.rawValue + "/blobs/" + blobID
        
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Authorization": accessTokenEncoded as String,
                       "Content-Type": HeaderType.ContentType.rawValue as String]
      
        Alamofire.request(requestURL, method: .get, parameters: [:], headers: headers)
            .responseString { response in
                
                let result: String = response.description
                let index = result.index(result.startIndex, offsetBy: 7)
                let head = String(result[..<index])

                if (head == RepResult.uperSUCCESS.rawValue) {
                    
                    let index = result.index(result.startIndex, offsetBy: 31)
                    let body = String(result[index...])
                    //print(body)
                    print("getting base64String success!")
                    
                    // Alert hide
                    //Alert.hideWaitingAlert()
                    
                    self.playBase64StringVideo(base64String: body)
                    
                } else {

                    // Alert hide
                    //Alert.hideWaitingAlert()
                    Alert.showError(msg: RepMessage.Getbase64StringFailed.rawValue)
                }
        }
        
    }
    
    // play base64 String Viddeo!
    func playBase64StringVideo(base64String: String) {
        
        let videoAsData = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let videoURL = documentsURL.appendingPathComponent("video.mp4")
        videoAsData?.write(to: videoURL, atomically: true)
        
        player = AVPlayer(url: videoURL as URL)
        player.actionAtItemEnd = .none
        playerLayer.player = player
        self.videoContainerView.layer.addSublayer(playerLayer)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidReachEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        player.play()
        cancelButton.isEnabled = true
    }
    
}


