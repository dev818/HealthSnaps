//
//  SendViewController.swift
//  HealthSnaps
//
//  Created by Admin on 05/12/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SCLAlertView

class SendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var loginViewCancelBtn: UIButton!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginEmailTextFld: UITextField!
    @IBOutlet weak var loginPasswordTextFld: UITextField!
    
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var patientTable: UITableView!
    
    @IBOutlet weak var cancelBtnSendModal: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var sendModalView: UIView!
    @IBOutlet weak var receivedPatientName: UILabel!
    @IBOutlet weak var sendMessageToLbl: UILabel!
    @IBOutlet weak var questionMarkLbl: UILabel!    
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    
    var patientAry: [[String : Any]] = []
    var patientInfo: [String : Any] = [:]
    var patientObj: [String : Any] = [:]
    var patientLog: [String : Any] = [:]
    var firstSpellAry: [String] = []
    var buttons = [UIButton]()
    var spellText: String = ""
    var videoID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customize()
        
        if (login) {
            getPatientList()
        } else {
            showLoginModal()
        }
        
    }
    
    func showLoginModal() {
        
//        loginEmailTextFld.text = userInfo.username.rawValue
//        loginPasswordTextFld.text = userInfo.password.rawValue
        
        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: "email") {
            loginEmailTextFld.text = email
        }
        
        backView.isHidden = false
        backView.alpha = 0.1
        loginView.isHidden = false
        centerYConstraint.constant = 0
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.53, initialSpringVelocity: 0, options: .curveEaseOut, animations: { self.view.layoutSubviews() }, completion: nil)
        
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        
        login_User()
    }
    
    @IBAction func loginCancelBtnTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "OverlayFromSendView", sender: self)
    }
    
    @IBAction func signuoBtnTapped(_ sender: UIButton) {
        
        NetworkManager.openWebsite()
    }    
    
    func customize() {
        
        setStatusBarBackgroundColor(color: "white")
        setNavigationBar()
        setSearchBar()
        setupSearchButtons()
        
        patientTable.delegate = self
        patientTable.dataSource = self
        
        loginViewCancelBtn.setTitleColor(UIColor(hexString: "#e67e22"), for: .normal)
        loginIndicator.isHidden = true
        loginView.isHidden = true
        loginView.layer.cornerRadius = 15
        loginView.layer.borderWidth = 1
        loginView.layer.borderColor = UIColor.gray.cgColor
        backView.alpha = 0
        backView.isHidden = true
        sendModalView.layer.cornerRadius = 15
        sendModalView.isHidden = true
        cancelBtnSendModal.setTitleColor(UIColor(hexString: "#e67e22"), for: .normal)
        receivedPatientName.textColor = UIColor(hexString: "#2980b9")
    }
    
    //naviBar customize
    @objc func setNavigationBar() {
        
        naviBar.barTintColor = UIColor.white
        naviBar.topItem?.title = "Send To..."
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor(hexString: "#2980b9"),
            NSAttributedStringKey.font: UIFont(name: "Thonburi-Bold", size: 23)!
        ]
        naviBar.titleTextAttributes = attrs
        
    }
    
    //searchBar Customize
    @objc func setSearchBar() {
        
        searchBar.placeholder = "Search"
        searchBar.barTintColor = UIColor.white
        searchBar.delegate = self
        
    }
    
    //setup *-# buttons
    func setupSearchButtons() {
        
//        let buttonBackView = UIView(frame: CGRect(x: Int(self.view.bounds.width - 30), y: 126, width: 25, height: 28 * 17))
//        buttonBackView.backgroundColor = UIColor.white
//        self.view.addSubview(buttonBackView)
        
        spellText = ""
        var i = 0
        
        for spell in spells1 {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: Int(self.view.bounds.width - 23), y: 126 + i * 17, width: 15, height: 15)
            //button.frame = CGRect(x: 7, y: i * 17, width: 15, height: 15)
            button.setTitle(spell, for: [])
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.tag = i
            button.addTarget(self, action: #selector(spellButtonTapped), for: .touchUpInside)
            self.view.addSubview(button)
            //buttonBackView.addSubview(button)
            buttons.append(button)
            i += 1
        }
        
        buttons[0].setImage(UIImage(named: "star"), for: .normal)
        
    }
    
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        spellText = ""
        if searchText.isEmpty {
            patientAry = sortedPatientAryAll
            firstSpellAry = firstSpellAryAll
            patientTable.reloadData()
        } else {
            filterTableView(text: searchText)
        }
    }
    
    //*-A-Z-# buttons tapped
    @objc func spellButtonTapped(_sender: UIButton!) {
        
        spellText = spellText + spells[_sender.tag]
        filterTableView(text: spellText)
        //print(spellText)
    }
    
    func filterTableView(text: String) {
        
        patientAry = constantPatientAryAll.filter({ (mod) -> Bool in
            
            return (mod["name"] as! String).lowercased().contains(text.lowercased())
            
        })
        
        createFirstSpellAry()
        
        patientTable.reloadData()
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        dismissKeyboard()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return patientAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sendCell") as! SendTableViewCell
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let patient = patientAry[indexPath.row]
        
        cell.patientName.text = patient["name"] as? String
        cell.firstSpellLabel.text = firstSpellAry[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print("row selected: \(indexPath.row)")
        
        patientInfo = patientAry[indexPath.row]
        receivedPatientName.text = patientInfo["firstName"] as? String
        
        DispatchQueue.main.async {
            let nameWidth = self.receivedPatientName.frame.width
            let firstLbl_x = (305 - 177 - nameWidth) / 2
            let secondLbl_x = firstLbl_x + 150 + 4
            let thirdLbl_x = secondLbl_x + nameWidth + 1
            self.sendMessageToLbl.frame = CGRect(x: firstLbl_x, y: 49, width: 150, height: 24)
            self.receivedPatientName.frame = CGRect(x: secondLbl_x, y: 48, width: nameWidth, height: 25.5)
            self.questionMarkLbl.frame = CGRect(x: thirdLbl_x, y: 50, width: 22, height: 21)
        }
        
        let no = patientInfo["no"] as! Int
        patientObj = patientObjs[no]
        //print(patientObj)
        
        showModalView()
        view.endEditing(true)
        
    }
    @IBAction func goBackBtnTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "OverlayFromSendView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "OverlayFromSendView" {
            
            let OverlayViewController = segue.destination as! CameraOverlayViewController
            if (fromLibrary) {
                OverlayViewController.player = AVPlayer(url: videoFileURL)
            } else {
                OverlayViewController.player = AVPlayer(url: exportedVideoURL)
            }
            OverlayViewController.finishedOverlay = true
            
        } else if segue.identifier == "HepViewFromSendView" {
            
            let vc = segue.destination as! HepViewController
            vc.patientInfo = patientInfo
            vc.patientObj = patientObj
            getExercise = false
        }
        
    }
    
    //send *** Btutton Tapped!
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        
        addRecent()
        if (fromLibrary) {
            saveVideoInfo()
        } else {
            saveVideoFile()
        }
        
    }
    
    // show Modal View!
    func showModalView() {
        
        centerConstraint.constant = 0
        sendModalView.isHidden = false
        backView.isHidden = false
        backView.alpha = 0.45
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: { self.view.layoutIfNeeded() }, completion: nil)
        //UIView.animate(withDuration: 0.2, animations: { self.backgroundView.alpha = 0.45 })
    }
    
    //close Modal View!
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        
        closeModal()
    }
    
    //
    func closeModal() {
        
        centerConstraint.constant = -670
        sendModalView.isHidden = true
        backView.isHidden = true
    }
    
    //get Patient List from server API
    func getPatientList() {
        
        //when start app, did login?
        if (loginSendToList) {
            self.patientAry = sortedPatientAryAll
            print("Already login PatientList!")
            
            firstSpellAry = firstSpellAryAll
            
            return
        }
        
        //format Variables!
        patientObjs = []
        sortedPatientAryAll = []
        constantPatientAryAll = []
        
        //Alert show
        if !(reloadPatientList) {
            
            //Alert.showWaiting(msg: RepMessage.LoadingPatient.rawValue)
            
        }
        
        let requestURL = BackendEndpoints.getpatientsList() + Ids.Vault_ID.rawValue + "/search"
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Content-Type": HeaderType.ContentType.rawValue as String,
                       "Authorization": accessTokenEncoded as String]
        
        let userId = StaticData.getUser().getUserId()
        let queryParams = ["filter":
            ["TherapistID": [["type": "eq"], ["value": userId]],
             "Deleted":[["type": "eq"], ["value": false]]
            ],
                           "filter_type": "and",
                           "full_document": true,
                           "per_page": 500,
                           "schema_id": Ids.Schema_ID.rawValue] as [String : Any]
        //print(queryParams)
        
        let dictAsString: String = JSONStringify(value: queryParams)
        let base64CredentialDictAsString = base64Encoded(auth: dictAsString)
        let encodedQueryParams = ["search_option": base64CredentialDictAsString]
        
        // Get Patient List Request!
        NetworkManager.JSON(params: encodedQueryParams as [String : AnyObject], URL: requestURL, method: .post, headers: headers, completion: { (result) in
            
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                
                let data = result["data"] as! [String : AnyObject]
                if let arrayofDic = data["documents"] as? [Dictionary<String,AnyObject>] {
                    
                    var i: Int = 0
                    for aDic in arrayofDic {
                        
                        let documentID = aDic["document_id"] as? String
                        
                        if let document = aDic["document"] as? String {
                            let patientInfo1 = base64Decoded(encodedString: document)
                            do {
                                var patientDic = try convertToDictionary(from: patientInfo1)
                                
                                if (patientDic["Deleted"] as! Bool) { continue }
                                
                                patientObjs.append(patientDic)
                                
                                let first = patientDic["FirstName"] as? String
                                let last = patientDic["LastName"] as? String
                                let name = first! + " " + last!
                                let patientID = patientDic["PatientID"] as? String
                                
                                let messagesForTherapist: Int!
                                if !(patientDic["MessagesForTherapist"] == nil) {
                                    messagesForTherapist = patientDic["MessagesForTherapist"] as! Int
                                } else {
                                    messagesForTherapist = 0
                                }
                                
                                let messagesForPatient: Int!
                                if !(patientDic["MessagesForPatient"] == nil) {
                                    messagesForPatient = patientDic["MessagesForPatient"] as! Int
                                } else {
                                    messagesForPatient = 0
                                }
                                
                                self.patientAry.append(["no": i, "firstName": first!, "name": name, "patientID": patientID!, "documentID": documentID!, "messagesForTherapist": messagesForTherapist, "messagesForPatient": messagesForPatient])
                                i = i + 1
                                
                            } catch {
                                //print(result)
                                print(error) //
                            }
                        }
                    }
                    
                    self.patientAry.sort { ($0["name"] as! String) < ($1["name"] as! String) }
                    sortedPatientAryAll = self.patientAry
                    constantPatientAryAll = self.patientAry
                    
                    self.createFirstSpellAry()
                    constantfirstSpellAry = self.firstSpellAry
                    firstSpellAryAll = self.firstSpellAry
                    
                    self.patientTable.reloadData()
                }
                // WaitingAlert hide
                //NetworkManager.hidePatientWaitingAlert()
                
                loginSendToList = true
                print(RepMessage.GetPatients_SUCCESS.rawValue)
                
            } else {
                
                // WaitingAlert hide
                //NetworkManager.hidePatientWaitingAlert()
                
                NetworkManager.showErrorAlert(result: result)
                print(RepMessage.InvalidRequest.rawValue)
            }
        })
    }
    
    // Last active Day calculation!
    public func calLastActiveDay(lastActiveDate: String) -> String {
        
        let now = NSDate()
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.day]
        formatter.maximumUnitCount = 1
        
        let lastDate = stringToDate(stringDate: lastActiveDate)
        var lastActiveDay = formatter.string (from: lastDate, to: now as Date)
        lastActiveDay = "Last Active " + lastActiveDay! + " ago"
        
        return lastActiveDay!
    }
    
    //
    func createFirstSpellAry() {
        
        firstSpellAry = []
        var compare: String = ""
        for patient in patientAry {
            let firstname = patient["firstName"] as! String
            let index = firstname.index(firstname.startIndex, offsetBy: 0)
            let firstSpell = String(firstname[index]) // returns String
            
            if compare == firstSpell {
                firstSpellAry.append("")
            } else {
                firstSpellAry.append(firstSpell)
                compare = firstSpell
            }
        }
//        constantfirstSpellAry = firstSpellAry
//        firstSpellAryAll = firstSpellAry
    }
    
    // Save Video File API Call 12!
    func saveVideoFile() {
        
        // show Alert!
        Alert.showWaiting(msg: RepMessage.SaveVideo_UpdatePatientLog.rawValue)
        
        if !(videoID == "") {
            saveVideoInfo()
            return
        }
        
        let requestURL = BackendEndpoints.getpatientsList() + Ids.GetSaveVideoFile_ID.rawValue + "/blobs"
        let auth = Ids.GetVideoAuth_ID.rawValue + ":"
        let base64Credentials = base64Encoded(auth: auth)
        let authEncoded = "Basic " + base64Credentials
        let headers = ["Authorization": authEncoded as String,
                       "Content-Type": "multipart/form-data"]
        
        //let rand = String(arc4random_uniform(1000))
        let fileName = videoName  // + ".m4v"

        let url = try! URLRequest(url: requestURL, method: .post, headers: headers)
        
        let videoData: Data =  try! Data(contentsOf: exportedVideoURL)
        let videoBase64String = videoData.base64EncodedString(options: [])
        let newString = "data:video/mp4;base64," + videoBase64String
        let blob = newString.data(using: .utf8)
        
        print(blob!)
     
        var readableJSON: [String: Any]!
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(blob!, withName: "file", fileName: fileName!, mimeType: "video/mp4")
            },
            with: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                     upload.responseJSON { response in

                        //print(response)

                        switch(response.result) {
                        case .success(_):

                            do {
                                readableJSON = try JSONSerialization.jsonObject(with: response.data!, options:.mutableContainers) as! [String : Any]
                                if (readableJSON["result"] as! String) == RepResult.SUCCESS.rawValue {

                                    let addedVideo = readableJSON["blob"] as! [String : Any]
                                    self.videoID = addedVideo["id"] as! String
                                    //print(self.videoID)
                                    print(RepMessage.VideoUpload_SUCCESS.rawValue)

                                    self.saveVideoInfo()

                                } else {

                                    // Alert hide
                                    Alert.hideWaitingAlert()

                                    NetworkManager.showErrorAlert(result: readableJSON)
                                    print(RepMessage.InvalidRequest.rawValue)
                                }

                            }
                            catch {
                                print(error)
                            }

                            break

                        case .failure(_):
                            print(response)
                            //completion(response.result)
                            break
                        }
                }
                case .failure( _):
                    break
                }
            }
        )
    }
    
    // Save Video Info: API Call 13!
    func saveVideoInfo() {
        
        let now = NSDate()
        let date = dateToString(date: now as Date)
        let name = exerciseData["name"] as! String
        let days = exerciseData["days"] as! String
        let hold = exerciseData["hold"] as! Int
        let patientID = patientInfo["patientID"] as! String
        let reps = exerciseData["reps"] as! Int
        let sets = exerciseData["sets"] as! Int
        let freq = exerciseData["freq"] as! Int
                
        var exercise: [String : Any] = [:]
        if !(fromLibrary) {
            
            exercise = ["Name": name, "BodyPart": "custom", "Days": days, "Strength": "custom",
                            "Hold": hold, "Equipment": "custom", "Deleted": false, "Video": "", "Img": "",
                            "TimeStamp": date, "AssignedExerciseID": "", "PatientID": patientID,
                            "Frequency": freq, "Reps": reps, "Sets": sets, "VideoBlobID": self.videoID,
                            "ImgBlobID": "", "Description": ""] as [String : Any]
        } else {
            
            // show Alert!
            Alert.showWaiting(msg: RepMessage.SaveVideo_UpdatePatientLog.rawValue)
            
            let video = exerciseObj["S3URL"] as! String
            exercise = ["Name": name, "BodyPart": "custom", "Days": days, "Strength": "custom",
                        "Hold": hold, "Equipment": "custom", "Deleted": false, "Video": video, "Img": "",
                        "TimeStamp": date, "AssignedExerciseID": "", "PatientID": patientID,
                        "Frequency": freq, "Reps": reps, "Sets": sets, "Description": ""] as [String : Any]
        }
        
        let newData: String = JSONStringify(value: exercise)
        
        let requestURL = BackendEndpoints.getpatientsList() + Ids.GetExercises_ID.rawValue + "/documents"
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Content-Type": HeaderType.ContentType.rawValue as String,
                       "Authorization": accessTokenEncoded as String]
        
        let base64Data = base64Encoded(auth: newData)
        let data = ["document": base64Data,
                    "schema_id": Ids.GetExercisesSchema_ID.rawValue]
        
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: headers, completion: { (result) in

            //print(result)
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {

                print(RepMessage.SaveVideoInfo_SUCCESS.rawValue)

                // Alert hide
                //Alert.hideWaitingAlert()

                self.getPatientLog()

            } else {

                // Alert hide
                Alert.hideWaitingAlert()
                NetworkManager.showErrorAlert(result: result)
            }
        })
    }
    
    // Update Patient Log - API Call 14! // First get patient log!
    func getPatientLog() {
        
        let patientLogID = patientObj["PatientLogID"] as! String
        let requestURL = BackendEndpoints.getpatientsList() + Ids.PatientLog_ID.rawValue + "/documents/" + patientLogID
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Authorization": accessTokenEncoded as String,
                       "Content-Type": HeaderType.ContentType.rawValue as String]
        
        Alamofire.request(requestURL, method: .get, parameters: [:], headers: headers)
            .responseString { response in
                
                //print(response)
                
                let result: String = response.description
                var index = result.index(result.startIndex, offsetBy: 7)
                let head = String(result[..<index])
                index = result.index(result.startIndex, offsetBy: 9)
                let content = String(result[index...])
                //print(content)
                
                if (head == RepResult.uperSUCCESS.rawValue) {
                    
                    let newData = base64Decoded(encodedString: content)
                    do {
                        
                        self.patientLog = try convertToDictionary(from: newData)
                        //print(self.patientLog)
                        print(RepMessage.GetPatientLog_SUCCESS.rawValue)
                        
                        self.changesToPatientLog()
                        
                    } catch {
                        //print(result)
                        print(error) //
                    }
                    
                } else {
                    
                    // Alert hide
                    Alert.hideWaitingAlert()
                    Alert.showError(msg: RepMessage.RequestFailed.rawValue)
                }
                
        }
    }
    
    // Make changes to Patient Log
    func changesToPatientLog() {
        
        //print(patientLog)
        
        //var patientLog1: [String : Any] = [:]
        var dateIndex = 0
        
        for i in 0...200 {
            
            let date = (Calendar.current as NSCalendar).date(byAdding: .day, value: i, to: Date(), options: [])!
            let theDate = dateToStringMDY(date: date)
            
            if (patientLog[theDate] == nil) {
               
                //create a new log entry
                patientLog[theDate] = ["completed": 0, "assigned": 0, "exercises": []]
                
            }
            
        }
        
        for _ in 0...90 {

            let date = (Calendar.current as NSCalendar).date(byAdding: .day, value: dateIndex, to: Date(), options: [])!
            let theDate = dateToStringMDY(date: date)

            switch (exerciseData["days"] as! String) {
            case exerciseDays.everyday.rawValue:
                dateIndex += 1
                break
            case exerciseDays.everyotherday.rawValue:
                if date.dayOfWeek()! == "Saturday" {
                    dateIndex += 1
                } else {
                    dateIndex += 2
                }
                break
            case exerciseDays.weekday.rawValue:
                let tomorrow = (Calendar.current as NSCalendar).date(byAdding: .day, value: dateIndex + 1, to: Date(), options: [])!
                if tomorrow.dayOfWeek()! == "Saturday" || tomorrow.dayOfWeek()! == "Sunday" {
                    dateIndex += 3
                } else {
                    dateIndex += 1
                }
                break
            default:
                dateIndex += 1
                break
            }

            let patientLogDate: [String : Any] = patientLog[theDate] as! [String : Any]
            var assigned = patientLogDate["assigned"] as! Int
            assigned += 1
            var exercises = patientLogDate["exercises"] as! [[String : Any]]
            exercises.append(["exerciseName": exerciseData["name"] as! String, "completed": false])
            patientLog[theDate] = ["completed": 0, "assigned": assigned, "exercises": exercises]

        }
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM-dd-yyyy"
//
//        let dayTotalArray = patientLog1.map { ($0, $1) }
//            .sorted() { formatter.date(from: $0.0)!.compare(formatter.date(from: $1.0)!) == .orderedAscending }

        //print(dayTotalArray)
        //print(patientLog)
        
        self.savePatientLog()
    }
    
    // Save Patient Log
    func savePatientLog() {
        
        let patientLogID = patientObj["PatientLogID"] as! String
        let requestURL = BackendEndpoints.getpatientsList() + Ids.PatientLog_ID.rawValue + "/documents/" + patientLogID
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Authorization": accessTokenEncoded as String,
                       "Content-Type": HeaderType.ContentType.rawValue as String]
        
        let dictAsString: String = JSONStringify(value: patientLog)
        let base64CredentialDictAsString = base64Encoded(auth: dictAsString)
        let data = ["document": base64CredentialDictAsString]
        
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .put, headers: headers, completion: { (result) in
            
            //print(result)
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                
                
                print(RepMessage.SavePatientLog_SUCCESS.rawValue)
                
                // Alert hide
                Alert.hideWaitingAlert()
                
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("Done"){
                    self.closeModal()
                    self.performSegue(withIdentifier: "HepViewFromSendView", sender: self)
                }
                alert.showSuccess("Congratulations", subTitle: RepMessage.SavePatientLog_SUCCESS.rawValue)
                
            } else {
                
                // Alert hide
                Alert.hideWaitingAlert()
                
                NetworkManager.showErrorAlert(result: result)
                print(RepMessage.InvalidRequest.rawValue)
            }
            
        })
    }
    
    // add recent patient to Ary
    func addRecent() {
        
        var temp: [[String : Any]] = []
        temp.append(self.patientInfo)
        temp += constantPatientAryAll
        sortedPatientAryAll = temp
        
        var tempString: [String] = []
        tempString.append("RECENT")
        tempString += constantfirstSpellAry
        firstSpellAryAll = tempString
        
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
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
                
                print(result)
                NetworkManager.showErrorAlert(result: result)
                self.loginIndicator.stopAnimating()
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
                self.loginIndicator.stopAnimating()
                
                self.centerYConstraint.constant = 900
                self.backView.isHidden = true
                self.getPatientList()
                
            } else {
                
                NetworkManager.showErrorAlert(result: result)
                self.loginIndicator.stopAnimating()
            }
            
        })
        
    }
    
    
    // Show ActivityIndicator!
    func showLoginIndicator() {
        
        loginIndicator.isHidden = false
        loginIndicator.hidesWhenStopped = true
        loginIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loginIndicator.startAnimating()
        
    }
    
}

extension Date {
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
}

