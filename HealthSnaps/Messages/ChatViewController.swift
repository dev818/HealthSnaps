//
//  ChatViewController.swift
//  HealthSnaps
//
//  Created by Admin on 23/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit
import MultilineTextField
import IQKeyboardManagerSwift

class ChatViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var naviBar: UINavigationBar!    
    @IBOutlet weak var chatTextView: MultilineTextField!
    @IBOutlet weak var messageShowTable: UITableView!
    @IBOutlet weak var sendIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tapView: UIView!    
    
    var patientInfo: [String : Any] = [:]
    var patientObj: [String : Any] = [:]
    var messages: [[String : Any]] = []
    var getMessageTimer: Timer!
    var firstLoad: Bool!
    var messageCount: Int!
    var messagesForPatient: Int!
    var messagesForTherapist: Int!
    var updateDueToTherapist: Bool!
    var messageString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customize()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.closeKeyboard))
        self.tapView.addGestureRecognizer(gesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        messageShowTable.estimatedRowHeight = 70
        messageShowTable.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        getMessageTimer.invalidate()
    
    }
    
    // customize UI and ...
    func customize() {
        
        tapView.isHidden = true
        
        IQKeyboardManager.sharedManager().disabledToolbarClasses = [ChatViewController.self]
        
        updateDueToTherapist = true
        firstLoad = true
        messageCount = 0
        
        messagesForPatient = patientInfo["messagesForPatient"] as? Int
        messagesForTherapist = patientInfo["messagesForTherapist"] as? Int
        
//        if (messagesForTherapist > 0 || messagesForPatient > 0) {
        getMessages()
//        } else {
//            firstLoad = false
//        }
        
        setStatusBarBackgroundColor(color: "white")
        setNavigationBar()
        
        sendIndicator.isHidden = true
        
        messageShowTable.delegate = self
        messageShowTable.dataSource = self
        messageShowTable.separatorStyle = UITableViewCellSeparatorStyle.none
        messageShowTable.allowsSelection = false
        
        chatTextView.delegate = self
        chatTextView.returnKeyType = UIReturnKeyType.send
        chatTextView.placeholder = "Send a chat"
        chatTextView.placeholderColor = UIColor.lightGray
        chatTextView.layer.borderWidth = 1
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        chatTextView.layer.borderColor = borderColor.cgColor
        chatTextView.layer.cornerRadius = 5
        chatTextView.textContainerInset = UIEdgeInsetsMake(10, 15, 10, 15)
        
        getMessageTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimeGetMessage), userInfo: nil, repeats: true)
    }
    
    // Get Message Timer Event
    @objc func runTimeGetMessage() {
        
        print("geting...")

        getMessages()
    }
    
    //naviBar customize
    @objc func setNavigationBar() {
        
        naviBar.barTintColor = UIColor.white
        naviBar.topItem?.title = patientInfo["firstName"] as? String
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor(hexString: "#2980b9"),
            NSAttributedStringKey.font: UIFont(name: "Thonburi-Bold", size: 23)!
        ]
        naviBar.titleTextAttributes = attrs
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == textView {
            //print("You tapped myTextView")
            self.tapView.isHidden = false
        }
    }
    
    // Message send Button Tapped!
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            //print("Tapped")
            if (self.chatTextView.text! == "") {
                //print("Empty text!")
                self.chatTextView.text = "Send a chat"
                self.chatTextView.resignFirstResponder()
                self.chatTextView.text = ""
                self.tapView.isHidden = true
                return true
            }
            
            DispatchQueue.main.async {
                
                self.chatTextView.text! = self.chatTextView.text!.replacingOccurrences(of: "\n", with: "")
                self.messageString = self.chatTextView.text!
                self.chatTextView.text = "Send a chat"
                self.chatTextView.resignFirstResponder()
                //self.messageString = self.messageString.replacingOccurrences(of: "\n", with: "")
                self.chatTextView.text = ""
                self.sendMessages()
            }
        }
        return true
    }
    
    // show sent Message!
    func showSentMessage() {
        
        messageCount = messageCount + 1
        
        self.messages.append(["timestamp": "Now", "from": "therapist", "message": self.messageString])
        self.messageShowTable.reloadData()
        self.messageShowTable.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
        
        //chatTextView.text = ""
        tapView.isHidden = true
        //self.sendPushToPatient()
        self.pullDeviceToken()
    }
    
    //tableview delegates!
    
    @objc func closeKeyboard() {
        
        //print("tapped!")
        view.endEditing(true)
        self.chatTextView.text = "Send a chat"
        self.chatTextView.resignFirstResponder()
        self.chatTextView.text = ""
        
        tapView.isHidden = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let receivedCell = tableView.dequeueReusableCell(withIdentifier: "receivedCell") as! ReceivedTableViewCell
        let sentCell = tableView.dequeueReusableCell(withIdentifier: "sentCell") as! SentTableViewCell
       
        let message = messages[indexPath.row]
        
        if (message["from"] as! String) == "patient" {
            
            receivedCell.patientName.text = patientInfo["firstName"] as? String
            receivedCell.messageLabel.text = message["message"] as? String
            receivedCell.receivedTimeLabel.text = message["timestamp"] as? String
            
            return receivedCell
            
        } else {
            
            sentCell.sentMessageLabel.text = message["message"] as? String
            
            return sentCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    // Go back to MessageView Button Tapped!
    @IBAction func onGoBackBtnTapped(_ sender: UIButton) {
        
        if (fromWhichView == "MessageView") {
            
            performSegue(withIdentifier: "MessageViewFromChatView", sender: self)
            
        } else if (fromWhichView == "NewChatView") {
            
            performSegue(withIdentifier: "NewChatViewFromChatView", sender: self)
            
        } else {
            
            performSegue(withIdentifier: "HepViewFromChatView", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HepViewFromChatView") {
            let vc = segue.destination as! HepViewController
            vc.patientInfo = patientInfo
            vc.patientObj = patientObj
        }
    }
    
    // Get Message API Call 7:
    func getMessages() {
        
        //Alert show
        if (firstLoad) {
            Alert.showWaiting(msg: RepMessage.LoadingMessages.rawValue)
        }
        
        let requestURL = BackendEndpoints.getpatientsList() + Ids.GetMessage_ID.rawValue + "/search"
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Content-Type": HeaderType.ContentType.rawValue as String,
                       "Authorization": accessTokenEncoded as String]
        
        let queryParams = ["filter": ["PatientID": [["type": "eq"], ["value": patientInfo["patientID"]]]],
                           "per_page": 500,
                           "full_document": true,
                           "schema_id": Ids.GetMessageSchema_ID.rawValue] as [String : Any]
        //print(queryParams)
        
        let dictAsString: String = JSONStringify(value: queryParams)
        let base64CredentialDictAsString = base64Encoded(auth: dictAsString)
        let encodedQueryParams = ["search_option": base64CredentialDictAsString]
        
        // Get Message Request!
        NetworkManager.JSON(params: encodedQueryParams as [String : AnyObject], URL: requestURL, method: .post, headers: headers, completion: { (result) in
            
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                
                //print(result)
                let data = result["data"] as! [String : AnyObject]
                if let arrayofDic = data["documents"] as? [Dictionary<String,AnyObject>] {

                    self.messages = []
                    for aDic in arrayofDic {

                        if let document = aDic["document"] as? String {
                            
                            let messageInfo = base64Decoded(encodedString: document)
                            do {

                                let messageDic = try convertToDictionary(from: messageInfo)
                                  
                                if !(messageDic["Message"] == nil) {

                                    let timestamp = messageDic["Timestamp"] as! String
                                    let receivedDay = "RECEIVED " + timestamp
                                    let from = messageDic["From"] as! String
                                    let message = messageDic["Message"] as! String
                                    
                                    self.messages.append(["timestamp": receivedDay, "from": from, "message": message])

                                } else {
                                    break
                                }

                            } catch {
                                //print(result)
                                print(error) //
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {

                    if self.messages.count > self.messageCount {
                        self.messageShowTable.reloadData()
                        self.messageShowTable.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                        self.messageCount = self.messages.count
                    }

                    if (self.messagesForTherapist > 0) {
                        self.updateMessagesForTherapist()
                    }

                    // Alert hide
                    if (self.firstLoad) {
                        Alert.hideWaitingAlert()
                        self.firstLoad = false
                    }
                }
                
                //print(self.messages)
                // print(RepMessage.GetPatients_SUCCESS.rawValue)
                
            } else {
                
                // Alert hide
                if (self.firstLoad) {
                    Alert.hideWaitingAlert()
                    self.firstLoad = true
                }
                NetworkManager.showErrorAlert(result: result)
            }

            
        })
        
    }
    
    // send Message API 8 Call!
    func sendMessages() {
        
        //ActivityIndicator show
        showSendingMessageIndicator()
        
        let requestURL = BackendEndpoints.getpatientsList() + Ids.GetMessage_ID.rawValue + "/documents"
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Authorization": accessTokenEncoded as String,
                       "Content-Type": HeaderType.ContentType.rawValue as String]
        
        let now = NSDate()
        let nowString = dateToStringMDhm12(date: now as Date)
        
        let attributes = StaticData.getUser().getAttributes()
        let theData = ["PatientID": patientInfo["patientID"] as Any,
                       "Timestamp": nowString,
                       "Title": "",
                       "Message": messageString as Any,
                       "From": "therapist",
                       "ClinicID": attributes["ClinicID"] as Any] as [String : Any]
        
        let newData: String = JSONStringify(value: theData)
        let base64CredentialDictAsString = base64Encoded(auth: newData)
        let data = ["document": base64CredentialDictAsString,
                    "schema_id": Ids.GetMessageSchema_ID.rawValue]
        
        // Get Message Request!
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: headers, completion: { (result) in
            
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
              
                print(RepMessage.SendMessage_SUCCESS.rawValue)
                
                self.updateMessagesForPatient()
                //self.showSentMessage()
                
            } else {
                
                Alert.showError(msg: RepMessage.SendingMessageFailed.rawValue)
                print(result)
                self.sendIndicator.stopAnimating()
            }
            
        })
        
    }
    
    //Update Parameter!
    func updateMessagesForTherapist() {
        
        updateDueToTherapist = true
        messagesForTherapist = 0
        //print(messagesForTherapist)
        updatePatient(updateData: messagesForTherapist)
    }
    
    //Update MessagesForPatient!
    func updateMessagesForPatient() {
        
        updateDueToTherapist = false
        messagesForPatient = messagesForPatient + 1
        //print(messagesForPatient)
        updatePatient(updateData: messagesForPatient)
    }
    
    //
    func updatePatient(updateData: Int) {
        
        let documentID = patientInfo["documentID"] as! String
        let requestURL = BackendEndpoints.getpatientsList() + Ids.Vault_ID.rawValue + "/documents/" + documentID
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Authorization": accessTokenEncoded as String,
                       "Content-Type": HeaderType.ContentType.rawValue as String]
        
        var theData = patientObj
        
        if (updateDueToTherapist) {
            theData["MessagesForTherapist"] = updateData
        } else {
            theData["MessagesForPatient"] = updateData
        }
        
        let newData: String = JSONStringify(value: theData)
        let base64CredentialDictAsString = base64Encoded(auth: newData)
        let data = ["document": base64CredentialDictAsString]
        
        // Get Message Request!
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .put, headers: headers, completion: { (result) in

            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {

                print(RepMessage.updatePatient_SUCCESS.rawValue)
                //print(result)
                // ActivityIndicator hide
                self.sendIndicator.stopAnimating()

                if !(self.updateDueToTherapist) {
                    self.showSentMessage()
                }
                
                if (self.updateDueToTherapist) {
                    self.patientObj["MessagesForTherapist"] = updateData
                } else {
                    self.patientObj["MessagesForPatient"] = updateData
                }
                
                loginPatientList = false
            } else {

                Alert.showError(msg: RepMessage.updatePatientFailed.rawValue)
                print(result)
                self.sendIndicator.stopAnimating()
            }

        })
        
    }
    
    // pull device token from DB API!
    func pullDeviceToken() {
        print(patientObj)
        let patientUserID = patientObj["PatientID"] as! String
        let requestURL = BackendEndpoints.getSaveDeviceTokenToDB() + "/" + patientUserID
        
        print(requestURL)
        NetworkManager.JSON(params: [:], URL: requestURL, method: .get, headers: [:], completion: { (result) in
            
            print(result)
            self.sendPushToPatient(patientToken: "")
        })
    }
    
    // push Notification to Patient API!
    func sendPushToPatient(patientToken: String) {
        
        print("push!")
        //print(patientInfo)
        
        let requestURL = BackendEndpoints.getPushPatient()
        let headers = ["Content-Type": HeaderType.ContentType_json.rawValue as String,
                       "Authorization": authKey]
        
        //print(patientInfo)
        if patientToken != "" {
            
            let data = ["to": patientToken, "priority": "high", "notification": ["body": "Your provider has sent you a message", "title": "New Message", "icon": "myicon", "sound": "mySound"]] as [String : Any]

            // Send Notification Request!
            NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: headers, completion: { (result) in

                if (result["result"] as! String) == RepResult.SUCCESS.rawValue {

                    print(RepMessage.PushNotification_SUCCESS.rawValue)
                    //print(result)

                } else {

                    print(result)
                }
            })
        } else {
            print("device_token is Nil!")
            return
        }
    }
    
    // Show ActivityIndicator!
    func showSendingMessageIndicator() {
        
        sendIndicator.isHidden = false
        sendIndicator.hidesWhenStopped = true
        sendIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        sendIndicator.startAnimating()
        
    }
    
}
