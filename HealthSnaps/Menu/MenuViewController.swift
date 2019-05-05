//
//  MenuViewController.swift
//  HealthSnaps
//
//  Created by Admin on 21/05/2018.
//  Copyright © 2018 getHealthSnaps. All rights reserved.
//

import UIKit
import SCLAlertView

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var searchBackView: UIView!
    @IBOutlet weak var menuItemTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customize()
       
    }
    
    func customize() {
        
        menuItemTable.layer.cornerRadius = 15
        menuItemTable.delegate = self
        menuItemTable.dataSource = self
        
        setStatusBarBackgroundColor(color: "orange")
        setNavigationBar()
    }
    
    @objc func setNavigationBar() {
        searchBackView.backgroundColor = UIColor(hexString: "#3c97d3")
        naviBar.barTintColor = UIColor(hexString: "#2980b9")
        naviBar.topItem?.title = "Menu"
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
        
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.menuItemLabel.text = menuItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            if !(login) {
                Alert.showInfo(msg: RepMessage.UnavaiableLogout.rawValue)
                return
            }
            
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("OK"){
                self.logoutAPI()
            }
            alert.addButton("CANCEL"){
                return
            }
            alert.showSuccess("Info", subTitle: "Are you sure?")
            
        } else {
            print("tapped support link!")
        }
    }
    
    @IBAction func gobackBtnTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "GobackMainPage", sender: self)
    }
    
    // Logout API!
    func logoutAPI() {
        
        let requestURL = BackendEndpoints.getLogout()
        let accessTokenEncoded = AccessTokenEncoded()
        
        let headers = ["Authorization": accessTokenEncoded as String]
        
        NetworkManager.JSON(params: [:], URL: requestURL, method: .post, headers: headers, completion: { (result) in

            //print(result)
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
               
                print("Logout success!")
                login = false
                loginPatientList = false
                getExerciseLib = false
                loginSendToList = false
                
                UserDefaults.standard.set("", forKey: "email")
                self.performSegue(withIdentifier: "GobackMainPage", sender: self)

            } else {

                NetworkManager.showErrorAlert(result: result)
                //self.LoginIndicator.stopAnimating()
            }

        })
    }
}
