//
//  NetworkManager.swift
//  HealthSnaps
//
//  Created by Admin on 14/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit
import Alamofire

public class NetworkManager {
    
    
    // JSON - Request
    public static func JSON(params: [String : AnyObject], URL: String, method: HTTPMethod, headers: [String : String], completion: @escaping (_ result: [String : Any]) -> ()){
        
        //print(params)
        var readableJSON: [String: Any]!
        
        Alamofire.request(URL, method: method, parameters: params, headers: headers)
            .responseJSON { response in
                print(response)
                
                switch(response.result) {
                case .success(_):
                    
                    do {
                        readableJSON = try JSONSerialization.jsonObject(with: response.data!, options:.mutableContainers) as? [String : Any]
                        
                        //print(readableJSON)
                        
                    }
                    catch {
                        print(error)
                    }
                    
                    if (readableJSON == nil) {break}
                    
                    completion(readableJSON)
                    break
                    
                case .failure(_):
                    print(response)
                    //completion(response.result)
                    //Alert.hideWaitingAlert()
                    break
                }
                
        }
        
    }
    
    public static func showErrorAlert(result: [String : Any]) {

        let errorInfo = result["error"] as! [String : Any]
        let errorcode = errorInfo["code"] as! String
        
        if errorcode == ErrorCode.In_USE.rawValue {
            
            Alert.showError(msg: RepMessage.AlreadyUseIn.rawValue)
            
        } else if errorcode == ErrorCode.Time_OUT.rawValue {
            
            Alert.showError(msg: RepMessage.TimeOut.rawValue)
            
        } else if errorcode == "" {
            
             Alert.showInvalidUser(msg: RepMessage.InvalidUser.rawValue)
        }
        
        else {
            
            Alert.showError(msg: RepMessage.RequestFailed.rawValue)
            
        }

    }
    
    public static func hidePatientWaitingAlert() {
        
        // WaitingAlert hide
        if !(reloadPatientList) {
            Alert.hideWaitingAlert()
        } else {
            reloadPatientList = false
        }
        
    }
    
    public static func openWebsite() {
        
        let url = URL(string: BackendEndpoints.getHealthSite())!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

