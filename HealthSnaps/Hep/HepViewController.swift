//
//  HepViewController.swift
//  HealthSnaps
//
//  Created by Admin on 27/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit
import SCLAlertView
import AVFoundation
import Alamofire

class HepViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {    
    
    @IBOutlet weak var cancelBtnUpdateModal: UIButton!
    @IBOutlet weak var delDischargeView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var centerDeleteModalConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelBtnDeleteModal: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var deleteModalLabel: UILabel!
    @IBOutlet weak var exerciseTable: UITableView!
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var searchBackView: UIView!
    
    @IBOutlet weak var centerConstraintUpdateModal: NSLayoutConstraint!
    @IBOutlet weak var updateModalView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var exerciseAry: [[String : Any]] = []
    var exerciseIDAry: [String] = []
    var exerciseObj: [String : Any] = [:]
    var patientInfo: [String : Any] = [:]
    var dischargeAction: Bool = true
    var patientObj: [String : Any] = [:]    
    var updateEmail: Bool = false
    var selExerID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customize()
        getExercises()
    }
    
    //UI and function customize!
    func customize() {
        
        cancelBtnUpdateModal.setTitleColor(UIColor(hexString: "#e67e22"), for: .normal)
        cancelBtnDeleteModal.setTitleColor(UIColor(hexString: "#e67e22"), for: .normal)
        
        setStatusBarBackgroundColor(color: "orange")
        setNavigationBar()
        
        exerciseTable.layer.cornerRadius = 15
        exerciseTable.delegate = self
        exerciseTable.dataSource = self
        
        delDischargeView.layer.cornerRadius = 15
        updateModalView.layer.cornerRadius = 15
        
    }
    
    @objc func setNavigationBar() {
        searchBackView.backgroundColor = UIColor(hexString: "#3c97d3")
        naviBar.barTintColor = UIColor(hexString: "#2980b9")
        naviBar.topItem?.title = patientObj["FirstName"] as? String
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "Thonburi-Bold", size: 23)!
        ]
        naviBar.titleTextAttributes = attrs
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return exerciseAry.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let exercise = exerciseAry[indexPath.row]
        self.exerciseObj = exercise
        self.selExerID = exerciseIDAry[indexPath.row]
        
        let reps = checkIntOrString(variable: exercise["Reps"] ?? "0")
        let sets = checkIntOrString(variable: exercise["Sets"] ?? "0")
        let hold = checkIntOrString(variable: exercise["Hold"] ?? "0")
        let freq = checkIntOrString(variable: exercise["Frequency"] ?? "0")
        
        exerciseData["name"] = exercise["Name"] as! String
        exerciseData["reps"] = Int(reps)
        exerciseData["sets"] = Int(sets)
        exerciseData["hold"] = Int(hold)
        exerciseData["freq"] = Int(freq)
        exerciseData["days"] = exercise["Days"] as! String
        let videoFileURLString = exercise["Video"] as! String
        videoFileURL = URL(string: videoFileURLString)
        
        fromHepToOverlay = true
        performSegue(withIdentifier: "overlayFromHep", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hepCell") as! HepTableViewCell
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let exercise = exerciseAry[indexPath.row]
        cell.exerciseName.text = exercise["Name"] as? String
        
        let reps = checkIntOrString(variable: exercise["Reps"] ?? "0")
        let sets = checkIntOrString(variable: exercise["Sets"] ?? "0")
        let hold = checkIntOrString(variable: exercise["Hold"] ?? "0")
        let desc = "Reps: " + reps + "   " + "Sets: " + sets + "   " + "Hold: " + hold + "s"
        
        cell.exerciseDesc.text = desc
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete"){
            (rowAction, indexPath) in
            
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("OK"){
                self.exerciseObj = self.exerciseAry[indexPath.row]
                let exerciseID = self.exerciseIDAry[indexPath.row]
                self.deleteAPI(exerciseID: exerciseID)
            }
            alert.addButton("CANCEL"){
                return
            }
            alert.showSuccess("Info", subTitle: "Are you sure?")
        }
        
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
        
    }
    
    // show Action Sheet!
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancel.setValue(UIColor.gray, forKey: "titleTextColor")
        
        let editPatient = UIAlertAction(title: "Edit Patient", style: .default) { action in
            self.showEditPatientView()
        }
        //editPatient.setValue(UIColor.cyan, forKey: "titleTextColor")
               
        let dischargePatient = UIAlertAction(title: "Discharge Patient", style: .default) { action in
            self.dischargeAction = true
            self.DeleteDischargePatient()
        }
        //dischargePatient.setValue(UIColor.cyan, forKey: "titleTextColor")
        
        let deletePatient = UIAlertAction(title: "Delete Patient", style: .default) { action in
            self.dischargeAction = false
            self.DeleteDischargePatient()
        }
        //deletePatient.setValue(UIColor.cyan, forKey: "titleTextColor")
        
        actionSheet.addAction(editPatient)
        actionSheet.addAction(dischargePatient)
        actionSheet.addAction(deletePatient)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    //
    func showEditPatientView() {
        
        backgroundView.isHidden = false
        updateModalView.isHidden = false
        centerConstraintUpdateModal.constant = 0
        firstNameTextField.text = patientObj["FirstName"] as? String
        lastNameTextField.text = patientObj["LastName"] as? String
        emailTextField.text = patientObj["Email"] as? String
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: { self.view.layoutIfNeeded() }, completion: nil)
        UIView.animate(withDuration: 0.2, animations: { self.backgroundView.alpha = 0.45 })
        
    }
    
    @IBAction func firstNameEditingDidEnd(_ sender: UITextField) {
        
        let firstName = firstNameTextField.text!
        firstNameTextField.text = firstName.firstUppercased
    }
    
    @IBAction func lastNameEditingDidEnd(_ sender: UITextField) {
        
        let lastName = lastNameTextField.text!
        lastNameTextField.text = lastName.firstUppercased
    }
    
    //ActionSheet(update, resend Button Events)
    @IBAction func updatePatientBtnTapped(_ sender: UIButton) {
        
        // when there are All items, Save Patient Info!
        if firstNameTextField.text == "" {
            
            Alert.showInfo(msg: RepMessage.fillFirstName.rawValue)
            
        } else if lastNameTextField.text == "" {
        
            Alert.showInfo(msg: RepMessage.fillLastName.rawValue)
            
        } else if emailTextField.text == "" {
            
            Alert.showInfo(msg: RepMessage.fillEmail.rawValue)
            
        } else if emailTextField.text != patientObj["Email"] as? String {
            
            if (validateemailAddress(testStr: emailTextField.text!)) {
                self.updateEmail = true
                updatePatient(updateDueTo: "email")
            } else {
                Alert.showInfo(msg: RepMessage.InvalidEmail.rawValue)
            }
            
        } else if firstNameTextField.text != patientObj["FirstName"] as? String || lastNameTextField.text != patientObj["LastName"] as? String {
            
            print("updateName")
            updatePatient(updateDueTo: "Name")
            
        }
    }
    
    // emailAddress Validation
    func validateemailAddress(testStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", validemail)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func resendActivationBtnTapped(_ sender: UIButton) {
        
        if emailTextField.text == "" {
            
            Alert.showInfo(msg: RepMessage.fillEmail.rawValue)
        } else {
            
            if (validateemailAddress(testStr: emailTextField.text!)) {
                
                saveActivationCode()
            } else {
                Alert.showInfo(msg: RepMessage.InvalidEmail.rawValue)
            }
        }        
    }
    
    @IBAction func cancelBtnUpdateModalTapped(_ sender: UIButton) {
        
        closeUpdateView()
    }
    
    // close
    func closeUpdateView() {
        
        centerConstraintUpdateModal.constant = 700
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.2, animations:  {
                self.view.layoutIfNeeded()
                self.backgroundView.alpha = 0
            })
            
            self.backgroundView.isHidden = true
            self.updateModalView.isHidden = true
        }
        
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        
    }
    
    //ActionSheet(Delete, Discharge Button Events)
    func DeleteDischargePatient() {
        
        backgroundView.isHidden = false
        delDischargeView.isHidden = false
        //backgroundView.alpha = 0.45
        centerDeleteModalConstraint.constant = 0
        
        if (dischargeAction) {
            deleteModalLabel.text = modalDescription.dischargeModaldesc.rawValue
            deleteBtn.setImage(UIImage(named: "discharge1"), for: .normal)
        } else {
            deleteModalLabel.text = modalDescription.deleteModaldesc.rawValue
            deleteBtn.setImage(UIImage(named: "delete1"), for: .normal)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: { self.view.layoutIfNeeded() }, completion: nil)
        UIView.animate(withDuration: 0.2, animations: { self.backgroundView.alpha = 0.45 })
        
    }
    
    //Delete_Discharge Modal Buttons Tapped!
    @IBAction func delDischargeBtnTapped(_ sender: UIButton) {
        
        if (dischargeAction) {
            //print("discharge!")
            updatePatient(updateDueTo: "Discharge")
        } else {
            //print("delete")
            updatePatient(updateDueTo: "Delete")
        }
    }
    
    @IBAction func cancelBtnDelDischargeTapped(_ sender: UIButton) {
        
        closeDel_DischargeView()
    }
    
    // close Delete/Discharge View!
    func closeDel_DischargeView() {
        
        centerDeleteModalConstraint.constant = -700
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.2, animations:  {
                self.view.layoutIfNeeded()
                self.backgroundView.alpha = 0
            })
            
            self.backgroundView.isHidden = true
            self.delDischargeView.isHidden = true
        }
    }
    
    //Different Actions
    @IBAction func editBtnTapped(_ sender: Any) {
        
        //showActionSheet()
//        if fromWhichToHep == "patientView" {
//            getExercise = false
//            performSegue(withIdentifier: "PatientViewFromHepView", sender: self)
//        } else if fromWhichToHep == "sendView" {
//            performSegue(withIdentifier: "sendViewFromHepView", sender: self)
//        }
        getExercise = false
        performSegue(withIdentifier: "PatientViewFromHepView", sender: self)
    }
    
    // go to Chat View!
    @IBAction func chatBtnTapped(_ sender: UIButton) {
        
//        fromWhichView = "HepView"
//        performSegue(withIdentifier: "ChatViewFromHepView", sender: self)
        showActionSheet()
    }
    
    // convert patientInfo to Chat View!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ChatViewFromHepView") {
            let vc = segue.destination as! ChatViewController
            vc.patientInfo = patientInfo
            vc.patientObj = patientObj
        } else if (segue.identifier == "overlayFromHep") {
            
            let OverlayViewController = segue.destination as! CameraOverlayViewController
            OverlayViewController.patientInfo = patientInfo
            OverlayViewController.patientObj = patientObj
            OverlayViewController.exerciseObj = self.exerciseObj
            OverlayViewController.exerciseID = self.selExerID
            
            if videoFileURL != nil {
                OverlayViewController.player = AVPlayer(url: videoFileURL)
            }
        }
        
    }
    
    // go to Main View!
    @IBAction func cameraBtnTapped(_ sender: UIButton) {
        
        getExercise = false
        performSegue(withIdentifier: "CameraViewFromHepView", sender: self)
    }
    
    // go to Patient List View!
    @IBAction func patientBtnTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "LibraryViewFromHepView", sender: self)
    }
    
    // go to Message View!
    @IBAction func MessageBtnTapped(_ sender: UIButton) {
        
        //performSegue(withIdentifier: "MessageViewFromHepView", sender: self)
        fromWhichView = "HepView"
        performSegue(withIdentifier: "ChatViewFromHepView", sender: self)
    }
    
    
    // API Call 9: Get Exercises
    func getExercises() {
        
        //did get?
        if (getExercise) {
            self.exerciseAry = exerciseAryOld
            self.exerciseIDAry = exerciseIDAryOld
            print("Already got Exercise!")
            return
        }
        
        //formating exerciseAry!
        exerciseAry = []
        exerciseIDAry = []
        
        let requestURL = BackendEndpoints.getpatientsList() + Ids.GetExercises_ID.rawValue + "/search"
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Content-Type": HeaderType.ContentType.rawValue as String,
                       "Authorization": accessTokenEncoded as String]
        
        let patientId = patientInfo["patientID"]
        let queryParams = ["filter":
                                 ["PatientID": [["type": "eq"], ["value": patientId]],
                                  "Deleted":[["type": "eq"], ["value": false]]],
                           "filter_type": "and",
                           "full_document": true,
                           "schema_id": Ids.GetExercisesSchema_ID.rawValue] as [String : Any]
        //print(queryParams)
        
        let dictAsString: String = JSONStringify(value: queryParams)
        let base64CredentialDictAsString = base64Encoded(auth: dictAsString)
        let encodedQueryParams = ["search_option": base64CredentialDictAsString]
        
        // Get Exercises Request!
        NetworkManager.JSON(params: encodedQueryParams as [String : AnyObject], URL: requestURL, method: .post, headers: headers, completion: { (result) in
            
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                
                let data = result["data"] as! [String : AnyObject]
                if let arrayofDic = data["documents"] as? [Dictionary<String,AnyObject>] {

                    for aDic in arrayofDic {

                        let documentID = aDic["document_id"] as? String

                        if let document = aDic["document"] as? String {
                            let exerciseInfo = base64Decoded(encodedString: document)
                            do {
                                let exerciseDic = try convertToDictionary(from: exerciseInfo)
                                //print(exerciseDic)
                                if !(exerciseDic["Deleted"] as! Bool) {
                                    self.exerciseAry.append(exerciseDic)
                                    self.exerciseIDAry.append(documentID!)
                                } else {
                                    continue
                                }
                            } catch {
                                //print(result)
                                print(error) //
                            }
                        }
                    }
                    
                    exerciseAryOld = self.exerciseAry
                    exerciseIDAryOld = self.exerciseIDAry
                    //print(self.exerciseIDAry)
                    self.exerciseTable.reloadData()
                }
                // Alert hide
//                Alert.hideWaitingAlert()

                print(RepMessage.GetExercise_SUCCESS.rawValue)
                getExercise = true
                
            } else {
                
                NetworkManager.showErrorAlert(result: result)
            }
            
        })
        
    }
    
    // Updating Patient - API 10!
    func updatePatient(updateDueTo: String) {
        
        let documentID = patientInfo["documentID"] as! String
        let requestURL = BackendEndpoints.getpatientsList() + Ids.Vault_ID.rawValue + "/documents/" + documentID
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Authorization": accessTokenEncoded as String,
                       "Content-Type": HeaderType.ContentType.rawValue as String]
        
        var theData = patientObj
        //print(theData)
        
        if (updateDueTo == "Discharge") {
            theData["Discharged"] = true
        } else if (updateDueTo == "Delete") {
            theData["Deleted"] = true
        } else if (updateDueTo == "Name") {
            theData["FirstName"] = firstNameTextField.text!
            theData["LastName"] = lastNameTextField.text!
        } else {
            //Alert show
            Alert.showWaiting(msg: RepMessage.UpdatingPatient.rawValue)
            theData["FirstName"] = firstNameTextField.text!
            theData["LastName"] = lastNameTextField.text!
            theData["Deleted"] = true
        }
        
        let newData: String = JSONStringify(value: theData)
        let base64CredentialDictAsString = base64Encoded(auth: newData)
        let data = ["document": base64CredentialDictAsString]
        
        // Get Message Request!
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .put, headers: headers, completion: { (result) in

            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {

                print(RepMessage.updatePatient_SUCCESS.rawValue)
                //print(result)

                loginPatientList = false
                
                if updateDueTo == "Delete" {
                    
                    loginSendToList = false
                    self.closeDel_DischargeView()
                    self.performSegue(withIdentifier: "PatientViewFromHepView", sender: self)
                    
                } else if updateDueTo == "Discharge" {
                    
                    self.patientObj["Discharged"] = true
                    self.closeDel_DischargeView()
                    self.performSegue(withIdentifier: "PatientViewFromHepView", sender: self)
                    
                } else if updateDueTo == "Name" {
                    
                    self.changeNameInfo()
                    Alert.showSuccess(msg: RepMessage.UpdateName_SUCCESS.rawValue)
                    //self.closeUpdateView()
                } else {
                    
                    //self.closeUpdateView()
                    self.patientObj["Deleted"] = true
                    self.addPatientToList()
                }

            } else {

                Alert.showError(msg: RepMessage.updatePatientFailed.rawValue)
                print(result)

            }

        })
        
    }
    
    func changeNameInfo() {
        
        self.patientObj["FirstName"] = self.firstNameTextField.text!
        self.patientObj["LastName"] = self.lastNameTextField.text!
        self.patientInfo["firstName"] = self.firstNameTextField.text!
        self.patientInfo["lastName"] = self.lastNameTextField.text!
        self.setNavigationBar()
    }
    
    // add patient to Patient List API 2!
    func addPatientToList() {
        
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
            
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                
                let addedPatient = result["user"] as! [String : Any]
                self.patientInfo["patientID"] = addedPatient["user_id"] as! String
                self.patientObj["PatientID"] = addedPatient["user_id"] as! String
                
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
        let patientID = patientInfo["patientID"] as! String
        let data = ["userID": patientID]

        // Add Patient to Group Request!
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: [:], completion: { (result) in

            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {

                //print(result)
                print(RepMessage.AddPatientToGroup_SUCCESS.rawValue)
                
                let code = Int(arc4random_uniform(1000000))
                self.sendEmailToPatient(code: code)

            } else {

                // Alert hide
                Alert.hideWaitingAlert()
                NetworkManager.showErrorAlert(result: result)
            }

        })

    }

    // send Email To Patient API 4!
    func sendEmailToPatient(code: Int) {

        let requestURL = BackendEndpoints.getemailPatient()
        let email = emailTextField.text! //"d.johnson324@hotmail.com"
        let attributes = StaticData.getUser().getAttributes()
        let ptName = attributes["FirstName"] as! String
        let patientName = firstNameTextField.text!  //"daniel"
        let org = attributes["Organization"] as! String
        let url = BackendEndpoints.getHealthSite()
        let phoneNumber = patientObj["PhoneNumber"] as! String //"08615567665340"
        
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
                    if (self.updateEmail) {
                        self.updateEmail = false
                        self.savePatientData()
                    }
                    
                } else {
                    
                    // Alert hide
                    Alert.hideWaitingAlert()
                    Alert.showError(msg: RepMessage.SendingEmailFailed.rawValue)
                }
        }
        
    }

    // Save Patient Data API 6!
    func savePatientData() {
        
        let patientID = patientInfo["patientID"] as! String
        let patientLogID = patientObj["PatientLogID"] as! String
        let firstName = firstNameTextField.text! //"daniel"
        let lastName = lastNameTextField.text! //"johnson"
        let email = emailTextField.text! //"d.johnson324@hotmail.com"
        let attributes = StaticData.getUser().getAttributes()
        let clinicID = attributes["ClinicID"] as! String
        let therapistID = StaticData.getUser().getUserId()
        let now = NSDate()
        let lastActive = dateToString(date: now as Date)
        let phoneNumber: String
        if !(patientObj["PhoneNumber"] == nil) {
            phoneNumber = patientObj["PhoneNumber"] as! String  //"08615567665340"
        } else {
            phoneNumber = ""
        }        

        let theData = ["PatientID": patientID, "FirstName": firstName, "LastName": lastName,
                       "Email": email, "BodyPart": "body", "ClinicID": clinicID, 
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
                Alert.showSuccess(msg: RepMessage.UpdatePatient_SUCCESS.rawValue)

                print(RepMessage.SavePatient_SUCCESS.rawValue)

                //relaod patient list
                loginPatientList = false
                
                self.patientObj["Email"] = self.emailTextField.text!
                self.changeNameInfo()
                self.view.endEditing(true)
                
            } else {

                // Alert hide
                Alert.hideWaitingAlert()
                NetworkManager.showErrorAlert(result: result)
            }
        })
    }
    
    //Save Activation Code API 11!
    func saveActivationCode() {
        
        //Alert show
        Alert.showWaiting(msg: RepMessage.SavingActivationCode.rawValue)
        
        let requestURL = BackendEndpoints.getSaveActivationCode()
        let email = emailTextField.text! //"d.johnson324@hotmail.com"
        let usercode = Int(arc4random_uniform(1000000))
        let attributes = StaticData.getUser().getAttributes()
        let clinicID = attributes["ClinicID"] as! String
        
        let data = ["Email": email, "Code": usercode, "ClinicID": clinicID] as [String : Any]
        
        // Add Patient to Group Request!
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: [:], completion: { (result) in

            if !(result["id"] as! String == "") {
                
                self.sendEmailToPatient(code: usercode)
                
                print(RepMessage.SaveActivationCode_SUCCESS.rawValue)

                // Alert hide
                Alert.hideWaitingAlert()

                // Show Success Alert!
                Alert.showSuccess(msg: RepMessage.SaveActivationCode_SUCCESS.rawValue)
                
            } else {
                print(result)
                // Alert hide
                Alert.hideWaitingAlert()
                NetworkManager.showErrorAlert(result: result)
            }

        })
    }
    
    //Delete Exercise API Call!
    func deleteAPI(exerciseID: String) {
        
        exerciseObj["Deleted"] = true
        if (exerciseObj["ImgBlobID"] != nil) {
            exerciseObj["ImgBlobID"] = ""
        }
        if (exerciseObj["VideoBlobID"] != nil) {
            exerciseObj["VideoBlobID"] = ""
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
                
                print("Deleteing Exercise Success!")
                
                //print(result)
                
                getExercise = false
                self.getExercises()
                
                // Alert hide
                //Alert.hideWaitingAlert()
                
            } else {
                
                // Alert hide
                //Alert.hideWaitingAlert()
                NetworkManager.showErrorAlert(result: result)
            }
        })
    }
}
