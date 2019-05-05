//
//  ShowAlert.swift
//  HealthSnaps
//
//  Created by Admin on 20/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

public class Alert {
    
    static var alertView: SCLAlertView!
    
    // wait Alert!
    public static func showWaiting(msg: String){
        
        let appearance = SCLAlertView.SCLAppearance(
            
            showCloseButton: false
        )
        
        alertView = SCLAlertView(appearance: appearance)
        
        alertView.showWait(
            msg, subTitle: "Please wait for a moment.", // Title of view
            colorStyle: 0xb93ef9,
            colorTextButton: 0xFFFFFF
        )
    }
    
    public static func hideWaitingAlert() {
        
        alertView.hideView()
    }
    
    public static func showError(msg: String){
        
        SCLAlertView().showInfo(
            "Error", // Title of view
            subTitle: msg, // String of view
            closeButtonTitle: "Done", // Optional button value, default: ""
            colorStyle: 0xff9700,
            colorTextButton: 0xFFFFFF
        )
    }
    
    public static func showInvalidUser(msg: String){
        
        SCLAlertView().showInfo(
            "Invalid User Info.", // Title of view
            subTitle: msg, // String of view
            closeButtonTitle: "Done", // Optional button value, default: ""
            colorStyle: 0xff31c7,
            colorTextButton: 0xFFFFFF
        )
    }
    
    public static func showInfo(msg: String){
        
        SCLAlertView().showInfo(
            "Info", // Title of view
            subTitle: msg, // String of view
            closeButtonTitle: "Done", // Optional button value, default: ""
            colorStyle: 0xff9700,
            colorTextButton: 0xFFFFFF
        )
    }
    
    public static func showSuccess(msg: String){
        
        SCLAlertView().showSuccess(
            "Congratulations", // Title of view
            subTitle: msg, // String of view
            closeButtonTitle: "Done", // Optional button value, default: ""
            colorStyle: 0x29d224,
            colorTextButton: 0xFFFFFF
        )   
        
    }
    
    public static func showWarning(msg: String){
        
        SCLAlertView().showWarning(
            "Warning", // Title of view
            subTitle: msg, // String of view
            //duration: 2.0, // Duration to show before closing automatically, default: 0.0
            closeButtonTitle: "Done", // Optional button value, default: ""
            colorStyle: 0xff9700,
            colorTextButton: 0xFFFFFF
        )
    }
    
    
}

