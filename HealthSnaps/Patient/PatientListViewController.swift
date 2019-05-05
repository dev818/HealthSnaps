//
//  PatientListViewController.swift
//  HealthSnaps
//
//  Created by Admin on 29/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SCLAlertView

class PatientListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginEmailTextFld: UITextField!
    @IBOutlet weak var loginPasswordTextFld: UITextField!
    @IBOutlet weak var LoginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginViewCancelBtn: UIButton!
    
    @IBOutlet weak var patientListTable: UITableView!
    @IBOutlet weak var searchBackView1: UIView!
    @IBOutlet weak var searchBack: UIView!
    @IBOutlet weak var searchBarPatient: UISearchBar!
    @IBOutlet weak var addPatientView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var naviBar: UINavigationBar!    
    @IBOutlet weak var centerYLoginModal: NSLayoutConstraint!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!    
    
    var dischargedAry: [[String : Any]] = []
    var buttons = [UIButton]()
    var patientID: String = ""
    var patientLogID: String = ""
    var spellText: String = ""
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
    
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: "orange")
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
        centerYLoginModal.constant = 0
        
        UIView.animate(withDuration: 2.3, delay: 0, usingSpringWithDamping: 0.53, initialSpringVelocity: 0, options: .curveEaseOut, animations: { self.view.layoutSubviews() }, completion: nil)
        
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        
        login_User()
        
    }
    
    @IBAction func loginCancelBtnTapped(_ sender: UIButton) {
        
        goToCameraView()
        
    }
    
    @IBAction func signupBtnTapped(_ sender: UIButton) {
        
        NetworkManager.openWebsite()
    }
    
    func customize() {
        
        loginViewCancelBtn.setTitleColor(UIColor(hexString: "#e67e22"), for: .normal)
        cancelBtn.setTitleColor(UIColor(hexString: "#e67e22"), for: .normal)
        LoginIndicator.isHidden = true
        loginView.layer.cornerRadius = 15
        loginView.isHidden = true
        loginView.layer.borderWidth = 1
        loginView.layer.borderColor = UIColor.gray.cgColor
        
        patientListTable.delegate = self
        patientListTable.dataSource = self
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
        //setStatusBarBackgroundColor(color: "orange")
        setNavigationBar()
        setSearchBar()
        //setupSearchButtons()
        
        addPatientView.layer.cornerRadius = 15
    }   
    
    func goToCameraView() {
        
        performSegue(withIdentifier: "CameraViewfromPatientView", sender: self)
    }
    
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        
        goToCameraView()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dischargedAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PatientListTableViewCell
        let dividercell = tableView.dequeueReusableCell(withIdentifier: "dividercell") as! PatientListTableViewCell
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        dividercell.separatorInset = UIEdgeInsets.zero
        dividercell.layoutMargins = UIEdgeInsets.zero
        
        let patient = dischargedAry[indexPath.row]
        
        if (patient["divider"] as! Bool == true) {
            
            return dividercell
            
        } else {
            
            cell.nameLabel.text = patient["name"] as? String
            cell.activeLabel.text = patient["activeDay"] as? String
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        patientInfo = dischargedAry[indexPath.row]
        
        if (patientInfo["divider"] as! Bool == true) {
            return
        }
        
        let no = patientInfo["no"] as! Int
        patientObj = patientObjs[no]
        //print(patientObj)
        getExercise = false
        performSegue(withIdentifier: "HepViewFromPatientView", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HepViewFromPatientView") {
            let vc = segue.destination as! HepViewController
            vc.patientInfo = patientInfo
            vc.patientObj = patientObj
            //fromWhichToHep = "patientView"
        }
    }
    
    @IBAction func returnCameraViewTapped(_ sender: UIButton) {
        
        goToCameraView()
    }
    
    @IBAction func messageBtnTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "MessageViewFromPatientView", sender: self)
    }
    
    @IBAction func addPatient(_ sender: UIButton) {
        
        backgroundView.isHidden = false
        backgroundView.alpha = 0.45
        addPatientView.isHidden = false
        showAnimate()
    }
    
    // Add Patient View Animation!
    func showAnimate()
    {
        addPatientView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        addPatientView.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.addPatientView.alpha = 1.0
            self.addPatientView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    //naviBar customize
    @objc func setNavigationBar() {
        
        naviBar.barTintColor = UIColor(hexString: "#2980b9")
        naviBar.topItem?.title = "Patient List"
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "Thonburi-Bold", size: 23)!
        ]
        naviBar.titleTextAttributes = attrs
        
    }
    
    //searchBar Customize
    @objc func setSearchBar() {
        
        searchBackView1.backgroundColor = UIColor(hexString: "#3c97d3")
        searchBack.layer.cornerRadius = 15
        searchBarPatient.placeholder = "Search"
        searchBarPatient.layer.borderWidth = 10
        searchBarPatient.barTintColor = UIColor.white
        searchBarPatient.layer.borderColor = UIColor.white.cgColor
        searchBarPatient.delegate = self
        
    }
    
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        spellText = ""
        if searchText.isEmpty {
            dischargedAry = dischargedAryAll
            patientListTable.reloadData()
        } else {
            filterTableView(text: searchText)
        }
        
    }
    
    func filterTableView(text: String) {
        
        dischargedAry = dischargedAryAll.filter({ (mod) -> Bool in
            
            return (mod["name"] as! String).lowercased().contains(text.lowercased())
            
        })
        
        var charge: [[String : Any]] = []
        var discharge: [[String : Any]] = []
        var divider: [[String : Any]] = []
        
        for patient in dischargedAry {
            if (patient["discharged"] as? Bool == false) {
                charge.append(patient)
            } else {
                discharge.append(patient)
            }
        }
        if discharge.count == 0 {
            dischargedAry = charge
        } else {
            divider.append(["name": "", "divider": true])
            dischargedAry = charge + divider + discharge
        }
        
        patientListTable.reloadData()
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        view.endEditing(true)
    }
    
    //setup A-Z buttons
    func setupSearchButtons() {
        
        spellText = ""
        var i = 0
        
        for spell in spells {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: Int(self.view.bounds.width - 23), y: 126 + i * 17, width: 15, height: 15)
            button.setTitle(spell, for: [])
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.tag = i
            button.addTarget(self, action: #selector(spellButtonTapped), for: .touchUpInside)
            self.view.addSubview(button)
            buttons.append(button)
            i += 1
        }
        
    }
    
    //A-Z buttons tapped
    @objc func spellButtonTapped(_sender: UIButton!) {
        
        spellText = spellText + spells[_sender.tag]
        filterTableView(text: spellText)
        print(spellText)
    }
    
    // emailAddress Validation
    func validateemailAddress(testStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", validemail)
        return emailTest.evaluate(with: testStr)
    }
    
    // show password length message
    func showToast() {
        
        let toastLabel =
            UILabel(frame:
                CGRect(x: self.view.frame.size.width/2 - 80,
                       y: self.view.frame.size.height-350,
                       width: 160,
                       height: 35))
        toastLabel.backgroundColor = UIColor.orange
        toastLabel.font = toastLabel.font.withSize(14)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(toastLabel)
        toastLabel.text = "Invalid Email!"
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 2.0, animations: {
            toastLabel.alpha = 0.0
        })
    }
    
    // when emailAddress text changed, Check Email!
    @IBAction func emailEditingChanged(_ sender: UITextField) {
        
        if !(validateemailAddress(testStr: emailTextField.text!)) {
            
            showToast()            
        }
    }
    
    // "Add Patient" button of addPatientView tapped
    @IBAction func addPatientBtnTapped(_ sender: UIButton) {
        //print(device_tokenString)
        // when there are All items, Save Patient Info!
        
        if firstNameTextField.text == "" {

            Alert.showInfo(msg: RepMessage.fillFirstName.rawValue)

        } else if lastNameTextField.text == "" {

            Alert.showInfo(msg: RepMessage.fillLastName.rawValue)

        } else if emailTextField.text == "" {

            Alert.showInfo(msg: RepMessage.fillEmail.rawValue)

        } else { // nor API Call!

            if !(validateemailAddress(testStr: emailTextField.text!)) {

                Alert.showInfo(msg: RepMessage.InvalidEmail.rawValue)

            } else {

                addPatientToList()
                //sendEmailToPatient()
            }

        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        
        addPatientView.isHidden = true
        backgroundView.isHidden = true
    }
    
    // convert FirstName and LastName's first Spell
    @IBAction func firstNameEditingDidEnd(_ sender: UITextField) {
        
        let firstName = firstNameTextField.text!
        firstNameTextField.text = firstName.firstUppercased
    }
    
    @IBAction func lastNameEditingDidEnd(_ sender: UITextField) {
        
        let lastName = lastNameTextField.text!
        lastNameTextField.text = lastName.firstUppercased
    }
    
    //get Patient List API
    func getPatientList() {
        
        //when start app, did login?
        if (loginPatientList) {
            self.dischargedAry = dischargedAryAll
            print("Already login PatientList!")
            return
        }
        
        //format Variables!
        patientObjs = []
        dischargedAryAll = []
        
        //Alert show
        if !(reloadPatientList) {
            
            Alert.showWaiting(msg: RepMessage.LoadingPatient.rawValue)
            
        }        
        
        let requestURL = BackendEndpoints.getpatientsList() + Ids.Vault_ID.rawValue + "/search"
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Content-Type": HeaderType.ContentType.rawValue as String,
                       "Authorization": accessTokenEncoded as String]
        
        //let userId = StaticData.getUser().getUserId()   // "ClinicID" "TherapistID" 539 448
        let attributes = StaticData.getUser().getAttributes()
        let clinicIDString = attributes["ClinicID"] as! String
        let clinicID = Int(clinicIDString) //clinicID ?? 0
        let queryParams = ["filter":
            ["ClinicID":["type":"range","value":["gte":clinicID,"lte":clinicID]],
             "Deleted":[["type": "eq"], ["value": false]]
            ],
                           "filter_type": "and",
                           "full_document": true,
                           "per_page": 500,
                           "schema_id": Ids.Schema_ID.rawValue] as [String : Any]
        
        let dictAsString: String = JSONStringify(value: queryParams)
        let base64CredentialDictAsString = base64Encoded(auth: dictAsString)
        let encodedQueryParams = ["search_option": base64CredentialDictAsString] 
       
//        print(requestURL)
//        print(headers)
//        print(queryParams)
        
        // Get Patient List Request!
        NetworkManager.JSON(params: encodedQueryParams as [String : AnyObject], URL: requestURL, method: .post, headers: headers, completion: { (result) in
            
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                
                //print(result)
                let data = result["data"] as! [String : AnyObject]
                if let arrayofDic = data["documents"] as? [Dictionary<String,AnyObject>] {
                    
                    var i: Int = 0
                    var charge: [[String : Any]] = []
                    var discharge: [[String : Any]] = []
                    var divider: [[String : Any]] = []
                    for aDic in arrayofDic {
                        
                        let documentID = aDic["document_id"] as? String
                        
                        if let document = aDic["document"] as? String {
                            let patientInfo = base64Decoded(encodedString: document)
                            do {
                                var patientDic = try convertToDictionary(from: patientInfo)
                                
                                if (patientDic["Deleted"] as! Bool) { continue }
                                //print(patientDic)
                                patientObjs.append(patientDic)
                                
                                let lastActiveDay = self.calLastActiveDay(lastActiveDate: patientDic["LastActive"] as! String)
                                let first = patientDic["FirstName"] as? String
                                let last = patientDic["LastName"] as? String
                                let name = first! + " " + last!
                                let patientID = patientDic["PatientID"] as? String
                                let dischargeBool = patientDic["Discharged"] as? Bool
                                
                                let device_token: String!
                                if !(patientDic["device_token"] == nil) {
                                    device_token = patientDic["device_token"] as? String
                                } else {
                                    device_token = ""
                                }
                                
                                let messagesForTherapist: Int!
                                if !(patientDic["MessagesForTherapist"] == nil) {
                                    messagesForTherapist = patientDic["MessagesForTherapist"] as? Int
                                } else {
                                    messagesForTherapist = 0
                                }
                                
                                let messagesForPatient: Int!
                                if !(patientDic["MessagesForPatient"] == nil) {
                                    messagesForPatient = patientDic["MessagesForPatient"] as? Int
                                } else {
                                    messagesForPatient = 0
                                }
                                
                                if (dischargeBool)! {
                                    discharge.append(["no": i, "firstName": first!, "lastName": last!, "name": name, "patientID": patientID!, "documentID": documentID!, "activeDay": lastActiveDay, "discharged": dischargeBool ?? false,"divider": false, "messagesForTherapist": messagesForTherapist, "messagesForPatient": messagesForPatient, "device_token": device_token])
                                } else {
                                    charge.append(["no": i, "firstName": first!, "lastName": last!, "name": name, "patientID": patientID!, "documentID": documentID!, "activeDay": lastActiveDay, "discharged": dischargeBool ?? false, "divider": false, "messagesForTherapist": messagesForTherapist, "messagesForPatient": messagesForPatient, "device_token": device_token])
                                }
                                i += 1
                                
                            } catch {
                                //print(result)
                                print(error) //
                            }
                        }
                    }
                    
                    divider.append(["name": "", "divider": true])
                    charge.sort { ($0["name"] as! String) < ($1["name"] as! String) }
                    if discharge.count == 0 {
                        self.dischargedAry = charge
                    } else {
                        discharge.sort { ($0["name"] as! String) < ($1["name"] as! String) }
                        self.dischargedAry = charge + divider + discharge
                    }
                    dischargedAryAll = self.dischargedAry
                    
                    self.patientListTable.reloadData()
                }
                // WaitingAlert hide
                NetworkManager.hidePatientWaitingAlert()
                
                loginPatientList = true
                print(RepMessage.GetPatients_SUCCESS.rawValue)
                
            } else {
                
                // WaitingAlert hide
                NetworkManager.hidePatientWaitingAlert()
                
                NetworkManager.showErrorAlert(result: result)
                print(RepMessage.InvalidRequest.rawValue)
                print(result)
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
    
    // add patient to Patient List API 2!
    func addPatientToList() {
        
        //Alert show
        Alert.showWaiting(msg: RepMessage.SavingPatient.rawValue)

        let requestURL = BackendEndpoints.getaddPatient()
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Authorization": accessTokenEncoded as String,
                       "Content-Type": HeaderType.ContentType.rawValue as String]

        let attributes = StaticData.getUser().getAttributes()
        let username = emailTextField.text! //"d.johnson324@hotmail.com"
        let password = "firstPassword"
        let userId = StaticData.getUser().getUserId() as String
        let accountType = attributes["AccountType"] as! String
        
        let accountData = ["TherapistID": userId, "AccountType": accountType]
        let dictAsString: String = JSONStringify(value: accountData)
        let encodedaccountData = base64Encoded(auth: dictAsString)
        
        let data = ["username": username,
                    "password": password,
                    "attributes": encodedaccountData] as [String : Any]
        
        // Add Patient to List Request!
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: headers, completion: { (result) in
            
            //print(result)
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {

                let addedPatient = result["user"] as! [String : Any]
                self.patientID = addedPatient["user_id"] as! String
                
                print(RepMessage.AddPatient_SUCCESS.rawValue)

                self.addPatientToGroup()

            } else {

                // Alert hide
                Alert.hideWaitingAlert()

                NetworkManager.showErrorAlert(result: result)
                print(RepMessage.InvalidRequest.rawValue)
            }

        })
    }
    
    // Add Patient to Group API 3!
    func addPatientToGroup() {
        
        let requestURL = BackendEndpoints.getaddPatientToGroup()
        let data = ["userID": patientID]
        
        // Add Patient to Group Request!
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: [:], completion: { (result) in
            
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                
                //print(result)
                print(RepMessage.AddPatientToGroup_SUCCESS.rawValue)
                
                //self.createPatientLog()
                self.sendEmailToPatient()
                
            } else {
                
                // Alert hide
                Alert.hideWaitingAlert()
                NetworkManager.showErrorAlert(result: result)
            }
            
        })
        
    }
    
    // send Email To Patient API 4!
    func sendEmailToPatient() {
        
        let requestURL = BackendEndpoints.getemailPatient()
        let email = emailTextField.text! //"d.johnson324@hotmail.com"
        let attributes = StaticData.getUser().getAttributes()
        let ptName = attributes["FirstName"] as! String
        let patientName = firstNameTextField.text!  //"daniel"
        let org = attributes["Organization"] as! String
        let code = Int(arc4random_uniform(900000)) + 100000
        let url = BackendEndpoints.getHealthSite()
        let phoneNumber = phoneTextField.text!  //"08615567665340"
        
        let theData = ["email": email, "template": template, "ptName": ptName,
                       "patientName": patientName, "organization": org, "code": code,
                       "url": url, "phoneNumber": phoneNumber] as [String : Any]
        
        Alamofire.request(requestURL, method: .post, parameters: theData, headers: [:])
            .responseString { response in
                
                let result: String = response.description
                let index = result.index(result.startIndex, offsetBy: 7)
                let head = String(result[..<index])
                
                if (head == RepResult.uperSUCCESS.rawValue) {
                    
                    print("Sending email success!")
                    self.saveActivationCode(usercode: code)
                    
                } else {
                    
                    // Alert hide
                    Alert.hideWaitingAlert()
                    Alert.showError(msg: RepMessage.SendingEmailFailed.rawValue)
                }
        }
        
    }
    
    // Save Activation code
    func saveActivationCode(usercode: Int) {
        
        let requestURL = BackendEndpoints.getSaveActivationCode()
        let email = emailTextField.text!
        let attributes = StaticData.getUser().getAttributes()
        let clinicID = attributes["ClinicID"] as! String
        
        let data = ["Email": email, "Code": usercode, "ClinicID": clinicID] as [String : Any]
        
        // Add Patient to Group Request!
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: [:], completion: { (result) in
            
            if !(result["id"] as! String == "") {

                self.createPatientLog()
                print(RepMessage.SaveActivationCode_SUCCESS.rawValue)

            } else {
                print(result)
                // Alert hide
                Alert.hideWaitingAlert()
                NetworkManager.showErrorAlert(result: result)
            }
            
        })
    }
    
    // Make Patient's Log API 5
    func createPatientLog() {
        
        let now = NSDate()
        let nowString = dateToString(date: now as Date)
        
        let theData = ["currentScore": 0, "totalAssigned": 0,
                       "totalCompleted": 0, "lastDate": nowString, "PatientID": patientID] as [String : Any]
        let newData: String = JSONStringify(value: theData)
        
        let requestURL = BackendEndpoints.getpatientsList() + Ids.PatientLog_ID.rawValue + "/documents"
        
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Authorization": accessTokenEncoded as String,
                       "Content-Type": HeaderType.ContentType.rawValue as String]
        
        let base64Data = base64Encoded(auth: newData)
        let data = ["document": base64Data]
        
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: headers, completion: { (result) in
            
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                
                let logDocument = result["document"] as! [String : Any]
                self.patientLogID = logDocument["id"] as! String
                print(RepMessage.CreatePatientLog_SUCCESS.rawValue)
                
                self.savePatientData()
                
            } else {
                
                // Alert hide
                Alert.hideWaitingAlert()
                NetworkManager.showErrorAlert(result: result)
            }
        })
    }
    
    // Save Patient Data API 6!
    func savePatientData() {
        
        let firstName = firstNameTextField.text! //"daniel"
        let lastName = lastNameTextField.text! //"johnson"
        let email = emailTextField.text! //"d.johnson324@hotmail.com"
        let attributes = StaticData.getUser().getAttributes()
        let clinicID = attributes["ClinicID"] as! String
        let therapistID = StaticData.getUser().getUserId()
        let now = NSDate()
        let lastActive = dateToString(date: now as Date)
        let phoneNumber = phoneTextField.text! //"08615567665340"
        
        let theData = ["PatientID": patientID, "FirstName": firstName, "LastName": lastName,
                       "Email": email, "BodyPart": "body", "ClinicID": clinicID, "TherapistDeviceToken": device_tokenString,
                       "TherapistID": therapistID, "GoalsSet": false, "Discharged": false,
                       "Deleted": false, "LastActive": lastActive, "Activated": false,
                       "PhoneNumber": phoneNumber, "PatientLogID": patientLogID]  as [String : Any]
        let newData: String = JSONStringify(value: theData)
        
        let requestURL = BackendEndpoints.getpatientsList() + Ids.Vault_ID.rawValue + "/documents"
        
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Authorization": accessTokenEncoded as String,
                       "Content-Type": HeaderType.ContentType.rawValue as String]
        
        let base64Data = base64Encoded(auth: newData)
        let data = ["document": base64Data,
                    "schema_id": Ids.Schema_ID.rawValue]
        
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: headers, completion: { (result) in
            
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                
                // Alert hide
                Alert.hideWaitingAlert()
                
                //print(result)
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("Done"){
                    self.closeAddPatientView()
                }
                alert.showSuccess("Congratulations", subTitle: RepMessage.SavePatient_SUCCESS.rawValue)
                
                print(RepMessage.SavePatient_SUCCESS.rawValue)
                self.dismissKeyboard()
                
                //relaod patient list
                loginPatientList = false
                loginSendToList = false
                reloadPatientList = true
                
                self.getPatientList()
                
            } else {
                
                // Alert hide
                Alert.hideWaitingAlert()
                NetworkManager.showErrorAlert(result: result)
            }
        })
    }
    
    func closeAddPatientView() {
        
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        phoneTextField.text = ""
        addPatientView.isHidden = true
        backgroundView.isHidden = true
        
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
                
                //print(result)
                
                StaticData.getUser().setUserId(userId: (user["id"] as? String)!)
                StaticData.getUser().setAccess_token(access_token: (user["access_token"] as? String)!)
                StaticData.getUser().setStatus(status: (user["status"] as? String)!)
                StaticData.getUser().setMfa_enrolled(mfa_enrolled: (user["mfa_enrolled"] as? Bool)!)
                
                login = true
                print(RepMessage.Login_SUCCESS.rawValue)
                
                self.dismissKeyboard()
                //self.getUserInfo()
                self.saveDeviceToken()
                
            } else {
                
                //print(result)
                NetworkManager.showErrorAlert(result: result)
                self.LoginIndicator.stopAnimating()
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
                    
                    print(attributes)
                    
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
                //print(defaults.string(forKey: "login_time") ?? "There is no")
                
                print(RepMessage.GetUserInfo_SUCCESS.rawValue)
                // ActivityIndicator hide
                self.LoginIndicator.stopAnimating()
                
                self.centerYLoginModal.constant = 900
                self.backgroundView.isHidden = true
                self.getPatientList()
                
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
        LoginIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        //LoginIndicator.color = UIColor.blue
        LoginIndicator.startAnimating()
        
    }
    
}

extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}
