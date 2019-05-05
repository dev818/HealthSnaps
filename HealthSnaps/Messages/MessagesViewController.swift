//
//  MessagesViewController.swift
//  HealthSnaps
//
//  Created by Admin on 21/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginEmailTextFld: UITextField!
    @IBOutlet weak var loginPasswordTextFld: UITextField!
    @IBOutlet weak var loginViewCancelBtn: UIButton!
    @IBOutlet weak var searchBackView: UIView!
    @IBOutlet weak var searchBackView1: UIView!
    @IBOutlet weak var patientListTable: UITableView!
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var patientAry: [[String : Any]] = []
    var patientAryAll: [[String : Any]] = []
    var patientInfo: [String : Any] = [:]
    var patientObj: [String : Any] = [:]
    
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
        
        backgroundView.isHidden = false
        backgroundView.alpha = 0.1
        loginView.isHidden = false
        centerYConstraint.constant = 0
        
        UIView.animate(withDuration: 2.3, delay: 0, usingSpringWithDamping: 0.53, initialSpringVelocity: 0, options: .curveEaseOut, animations: { self.view.layoutSubviews() }, completion: nil)
        
    }
    
    // customize...
    func customize() {
        
        loginViewCancelBtn.setTitleColor(UIColor(hexString: "#e67e22"), for: .normal)
        loginIndicator.isHidden = true
        loginView.isHidden = true
        loginView.layer.cornerRadius = 15
        loginView.layer.borderWidth = 1
        loginView.layer.borderColor = UIColor.gray.cgColor
        backgroundView.isHidden = true
        
        //formating Variables
        patientObjs = []
        
        patientListTable.delegate = self
        patientListTable.dataSource = self
        
        setStatusBarBackgroundColor(color: "orange")
        setNavigationBar()
        setSearchBar()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionFromRight(swipe:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        
        login_User()
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        
        goToCameraView()
    }    
    
    @IBAction func signupBtnTapped(_ sender: UIButton) {
        
        NetworkManager.openWebsite()
    }
    
    func goToCameraView() {
        
        performSegue(withIdentifier: "CameraViewFromMessagesView", sender: self)
    }
    
    // swipe Action - return Mainview
    @objc func swipeActionFromRight(swipe: UISwipeGestureRecognizer)
    {
        goToCameraView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ChatViewFromMessageView") {
            let vc = segue.destination as! ChatViewController
            vc.patientInfo = patientInfo
            vc.patientObj = patientObj
        }
    }
    
    //naviBar customize
    @objc func setNavigationBar() {
        
        naviBar.barTintColor = UIColor(hexString: "#2980b9")
        naviBar.topItem?.title = "Messages"
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "Thonburi-Bold", size: 23)!
        ]
        naviBar.titleTextAttributes = attrs
        
    }
    
    //searchBar Customize
    @objc func setSearchBar() {
        
        searchBackView.layer.cornerRadius = 15
        searchBackView1.backgroundColor = UIColor(hexString: "#3c97d3")
        searchBar.placeholder = "Search"
        searchBar.layer.borderWidth = 0
        searchBar.barTintColor = UIColor.white
        searchBar.layer.borderWidth = 10
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.delegate = self
        
    }
    
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            patientAry = self.patientAryAll
            patientListTable.reloadData()
        } else {
            filterTableView(text: searchText)
        }
    }
    
    func filterTableView(text: String) {
        
        patientAry = patientAryAll.filter({ (mod) -> Bool in
            
            return (mod["name"] as! String).lowercased().contains(text.lowercased())
            
        })
        patientListTable.reloadData()
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        view.endEditing(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return patientAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MessagesTableViewCell
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let patient = patientAry[indexPath.row]
        
        cell.patientName.text = patient["name"] as? String
        
        var description: String = ""
        var image = UIImage(named: "sent_unopened1")
        
        if (patient["messagesForPatient"] as! Int) > 0 {

            description = "Message Sent"

        } else if (patient["messagesForTherapist"] as! Int) > 0 {

            image = UIImage(named: "received_unopened1")!
            description = "Tap to view"

        } else if (patient["messagesForTherapist"] as! Int) == 0 && (patient["messagesForPatient"] as! Int) == 0 {

            image = UIImage(named: "opened_icon")!
            description = "Tap to Send Message"
        }
        
        cell.statusTime.text = description
        cell.statusImg.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        patientInfo = patientAry[indexPath.row]
        let no = patientInfo["no"] as! Int
        patientObj = patientObjs[no]
        //print(patientObj)
        
        fromWhichView = "MessageView"
        performSegue(withIdentifier: "ChatViewFromMessageView", sender: self)
        
    }
    
    // cameraview Button tapped
    @IBAction func onCameraViewTapped(_ sender: UIButton) {
        
        goToCameraView()
    }
    
    // Patient List Button Tapped
    @IBAction func onPatientBtnTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "PatientViewFromMessageView", sender: self)
    }
    
    
    //New chat Button Tapped,
    @IBAction func newChatBtnTapped(_ sender: UIButton) {
        
        //performSegue(withIdentifier: "NewChatViewFromMessageView", sender: self)
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
    
    //get Patient List from server API
    func getPatientList() {
        
        //Alert show
        Alert.showWaiting(msg: RepMessage.LoadingPatient.rawValue)
        
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
                //print(result)
                let data = result["data"] as! [String : AnyObject]
                if let arrayofDic = data["documents"] as? [Dictionary<String,AnyObject>] {
                    
                    var i: Int = 0
                    var sentAry: [[String : Any]] = []
                    var receivedAry: [[String : Any]] = []
                    var noneAry: [[String : Any]] = []
                    
                    for aDic in arrayofDic {
                        
                        let documentID = aDic["document_id"] as? String
                        
                        if let document = aDic["document"] as? String {
                            let patientInfo = base64Decoded(encodedString: document)
                            do {
                                
                                var patientDic = try convertToDictionary(from: patientInfo)
                                
                                if (patientDic["Deleted"] as! Bool) { continue }
                                
                                patientObjs.append(patientDic)
                                //print(patientDic)
                                
                                let lastActiveDay = self.calLastActiveDay(lastActiveDate: patientDic["LastActive"] as! String)
                                let first = patientDic["FirstName"] as? String
                                let last = patientDic["LastName"] as? String
                                let name = first! + " " + last!
                                let patientID = patientDic["PatientID"] as? String
                                
                                let device_token: String!
                                if !(patientDic["device_token"] == nil) {
                                    device_token = patientDic["device_token"] as! String
                                } else {
                                    device_token = ""
                                }
                                
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
                    
                                if messagesForPatient > 0 {
                                    sentAry.append(["no": i, "firstName": first!, "lastName": last!, "name": name, "patientID": patientID!, "messagesForTherapist": messagesForTherapist, "messagesForPatient": messagesForPatient, "documentID": documentID!, "activeDay": lastActiveDay, "device_token": device_token])
                                } else if messagesForTherapist > 0 {
                                    receivedAry.append(["no": i, "firstName": first!, "lastName": last!, "name": name, "patientID": patientID!, "messagesForTherapist": messagesForTherapist, "messagesForPatient": messagesForPatient, "documentID": documentID!, "activeDay": lastActiveDay, "device_token": device_token])
                                } else if messagesForTherapist == 0 && messagesForPatient == 0 {
                                    noneAry.append(["no": i, "firstName": first!, "lastName": last!, "name": name, "patientID": patientID!, "messagesForTherapist": messagesForTherapist, "messagesForPatient": messagesForPatient, "documentID": documentID!, "activeDay": lastActiveDay, "device_token": device_token])
                                }
                                
                                i = i + 1
                                //print(patientDic)
                            } catch {
                                //print(result)
                                print(error) //
                            }
                        }
                    }
                   
                    //loginPatientList = true
                    sentAry.sort { ($0["name"] as! String) < ($1["name"] as! String) }
                    receivedAry.sort { ($0["name"] as! String) < ($1["name"] as! String) }
                    noneAry.sort { ($0["name"] as! String) < ($1["name"] as! String) }
                    self.patientAry = sentAry + receivedAry + noneAry
                    self.patientAryAll = self.patientAry
                    
                    DispatchQueue.main.async {
                        self.patientListTable.reloadData()
                        DispatchQueue.main.async {
                            Alert.hideWaitingAlert()
                        }
                    }
                    
                }
                
                print(RepMessage.GetPatients_SUCCESS.rawValue)
                
            } else {
                
                // Alert hide
                Alert.hideWaitingAlert()
                NetworkManager.showErrorAlert(result: result)
                print(RepMessage.InvalidRequest.rawValue)
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
                self.backgroundView.isHidden = true
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
