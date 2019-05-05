//
//  LibraryViewController.swift
//  HealthSnaps
//
//  Created by Admin on 03/12/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import AVKit
import SCLAlertView

class LibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var loginViewCancelBtn: UIButton!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundView: UIView!    
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginEmailTextFld: UITextField!
    @IBOutlet weak var loginPasswordTextFld: UITextField!
    @IBOutlet weak var searchBackView: UIView!
    
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarBackView: UIView!
    @IBOutlet weak var libraryTableView: UITableView!
    
    var exerciseLib: [[String : Any]] = []
    var spellText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customize()
        
        if (login) {
            getLibraryVideos()
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
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.53, initialSpringVelocity: 0, options: .curveEaseOut, animations: { self.view.layoutSubviews() }, completion: nil)
        
    }
    
    //
    func customize() {
        
        loginViewCancelBtn.setTitleColor(UIColor(hexString: "#e67e22"), for: .normal)
        loginIndicator.isHidden = true
        loginView.isHidden = true
        loginView.layer.cornerRadius = 15
        loginView.layer.borderWidth = 1
        loginView.layer.borderColor = UIColor.gray.cgColor
        backgroundView.isHidden = true
        
        setStatusBarBackgroundColor(color: "orange")
        setNavigationBar()
        setSearchBar()
        
        libraryTableView.delegate = self
        libraryTableView.dataSource = self
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
        
        performSegue(withIdentifier: "CameraViewFromLibraryView", sender: self)
    }
    
    @objc func setNavigationBar() {
        
        naviBar.barTintColor = UIColor(hexString: "#2980b9")
        naviBar.topItem?.title = "Library"
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "Thonburi-Bold", size: 23)!
        ]
        naviBar.titleTextAttributes = attrs
        
    }
    
    //searchBar Customize
    @objc func setSearchBar() {
        
        searchBackView.backgroundColor = UIColor(hexString: "#3c97d3")
        searchBarBackView.layer.cornerRadius = 15
        searchBar.placeholder = "Search"
        searchBar.layer.borderWidth = 0
        searchBar.barTintColor = UIColor.white
        searchBar.layer.borderWidth = 10
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.delegate = self        
    }
    
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        spellText = ""
        if searchText.isEmpty {
            exerciseLib = exerciseLibAry
            libraryTableView.reloadData()
        } else {
            filterTableView(text: searchText)
        }
        
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        view.endEditing(true)
    }
    
    func filterTableView(text: String) {
        
        exerciseLib = exerciseLibAry.filter({ (mod) -> Bool in
            
            return (mod["Name"] as! String).lowercased().contains(text.lowercased())
            
        })
        libraryTableView.reloadData()
    }
    
    // TableView Delegate!
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return exerciseLib.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryCell") as! LibraryTableViewCell
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let exercise = exerciseLib[indexPath.row]
        cell.exerciseName.text = exercise["Name"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        exerciseObj = exerciseLib[indexPath.row]
        
        let videoFileURLString = exerciseObj["S3URL"] as! String
        videoFileURL = URL(string: videoFileURLString)
        //print(videoFileURL)
        performSegue(withIdentifier: "overlayViewFromLibraryView", sender: self)
        
    }
    
    // Delete video from library
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete"){
            (rowAction, indexPath) in
            
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("OK"){
                
                exerciseObj = self.exerciseLib[indexPath.row]
                
                self.deleteFromLibAPI()
                
            }
            alert.addButton("CANCEL"){
                return
            }
            alert.showSuccess("Info", subTitle: "Are you sure?")
        }
        
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "overlayViewFromLibraryView" {
            
            let OverlayViewController = segue.destination as! CameraOverlayViewController
            OverlayViewController.player = AVPlayer(url: videoFileURL)
            OverlayViewController.finishedOverlay = true
            fromLibrary = true
            exerciseData["name"] = exerciseObj["Name"] as! String
            exerciseData["reps"] = 0
            exerciseData["sets"] = 0
            exerciseData["hold"] = 0
            exerciseData["freq"] = 0
            exerciseData["days"] = exerciseDays.everyday.rawValue
        }
    }
    
    // go back To CameraView
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        
        goToCameraView()
    }
    
    // API Call 18 - Get Library Videos!
    func getLibraryVideos() {
        
        if (getExerciseLib) {
            
            self.exerciseLib = exerciseLibAry
            return
        }
        
        //format Variables!
        exerciseLibAry = []
        
        // show Alert!
        Alert.showWaiting(msg: RepMessage.LoadingExercise.rawValue)
        
        let userId = StaticData.getUser().getUserId() as String
        let requestURL = BackendEndpoints.getSaveToLibrary() + "/" + userId
        
        Alamofire.request(requestURL, method: .get, parameters: [:], headers: [:])
            .responseJSON { response in
                
                //print(response)
                if let dict = response.result.value as! NSArray? {
                    
                    for element in dict {
                        
                        let data = element as! NSDictionary
                    
                        let s3Url = data["S3URL"] as! String
                        let len = s3Url.count
                        let index = s3Url.index(s3Url.startIndex, offsetBy: len - 3)
                        let videoExtension = String(s3Url[index...])
                        if videoExtension == "png" || videoExtension == "peg" || videoExtension == "bmp" {
                            continue
                        }
                    
                        self.exerciseLib.append(data as! [String : Any])
                    }
                    
                    //print(self.exerciseLib)
                    exerciseLibAry = self.exerciseLib
                    print(RepMessage.GetExercise_SUCCESS.rawValue)
                
                    self.libraryTableView.reloadData()
                    getExerciseLib = true
                
                }
                
                // Alert hide
                Alert.hideWaitingAlert()
        }
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
                self.getLibraryVideos()
                
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
    
    // deleting Exercise video from Library API!
    func deleteFromLibAPI() {
        
        let requestURL = BackendEndpoints.getSaveToLibrary()
        
        let id = exerciseObj["SnapVideoID"] as! String
        let data = ["id": id]
        print(id)
        
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .delete, headers: [:], completion: { (result) in
            
            print(result)
            
        })
    }
    
}
