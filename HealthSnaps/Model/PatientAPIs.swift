//
//  PatientAPIs.swift
//  HealthSnaps
//
//  Created by Admin on 29/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import Foundation


    
    //API @ 2 @
    public func addPatientAPI2(email: String) -> String {
        
        var patientID: String = ""
        //Alert show
        Alert.showWaiting(msg: RepMessage.SavingPatient.rawValue)
        
        let requestURL = BackendEndpoints.getaddPatient()
        let accessTokenEncoded = AccessTokenEncoded()
        let headers = ["Authorization": accessTokenEncoded as String,
                       "Content-Type": HeaderType.ContentType.rawValue as String]
        
        let attributes = StaticData.getUser().getAttributes()
        let username = email //"d.johnson324@hotmail.com"
        let password = "firstPassword"
        let userId = StaticData.getUser().getUserId() as String
        let accountType = attributes["AccountType"] as! String
        let data = ["username": username,
                    "password": password,
                    "attributes": [userId, accountType]] as [String : Any]
        
        // Add Patient to List Request!
        NetworkManager.JSON(params: data as [String : AnyObject], URL: requestURL, method: .post, headers: headers, completion: { (result) in
            
            if (result["result"] as! String) == RepResult.SUCCESS.rawValue {
                
                let addedPatient = result["user"] as! [String : Any]
                patientID = addedPatient["user_id"] as! String
                print(patientID)
                print(RepMessage.AddPatient_SUCCESS.rawValue)
                
            } else {
                
                // Alert hide
                Alert.hideWaitingAlert()
                
                NetworkManager.showErrorAlert(result: result)
                print(RepMessage.InvalidRequest.rawValue)
            }
        })
        
        return patientID
    }
    
    
    
    

