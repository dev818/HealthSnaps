//
//  BackendEndPoints.swift
//  HealthSnaps
//
//  Created by Admin on 14/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//
import UIKit
import Alamofire

public class BackendEndpoints {
    
    private static var healthSite: String = "https://healthsnaps.com"
    private static var server: String = "https://api.truevault.com"
    private static var login: String = "/v1/auth/login"
    private static var logout: String = "/v1/auth/logout"
    private static var auto_login: String = "/v1/auth/me"
    private static var users: String = "/v1/users/"
    private static var patientsList: String = "/v1/vaults/"
    private static var addPatient: String = "/v1/users"
    private static var healthServer: String = "https://healthconnection.io"
    private static var addPatientToGroup: String = "/hcPassword/php/addToGroupFromApp2.php"
    private static var emailPatient: String = "/app/php/sendPatientEmail2.php"
    private static var saveActivationCode: String = "/hcAPI/web/index.php/api/v1/activateAccount"
    private static var signedUrl: String = "/s3PHP/getSignedURL.php"
    private static var s3URL: String = "https://s3.us-east-2.amazonaws.com/ptmylibrary/"
    private static var saveToLibrary: String = "/testAPI/web/index.php/api/v1/snapVideo"
    private static var pushPatient: String = "https://fcm.googleapis.com/fcm/send"
    private static var saveDeviceTokenToDB: String = "/testAPI/web/index.php/api/v1/deviceToken"
    
    public static func getHealthSite() -> String {
        return healthSite
    }
    
    public static func getServer() -> String {
        return server
    }
    
    public static func getHealthServer() -> String {
        return healthServer
    }
    
    public static func getLogin() -> String {
        return server + login
    }
    
    public static func getLogout() -> String {
        return server + logout
    }
    
    public static func getAutoLogin() -> String {
        return server + auto_login
    }
    
    public static func getUsers() -> String {
        return server + users
    }
    
    public static func getpatientsList() -> String {
        return server + patientsList
    }
    
    public static func getaddPatient() -> String {
        return server + addPatient
    }
    
    public static func getaddPatientToGroup() -> String {
        return healthServer + addPatientToGroup
    }
    
    public static func getemailPatient() -> String {
        return healthServer + emailPatient
    }
    
    public static func getSaveActivationCode() -> String {
        
        return healthServer + saveActivationCode
    }
    
    public static func getSignedUrl() -> String {
        
        return healthServer + signedUrl
    }
    
    public static func getS3URL() -> String {
        
        return s3URL
    }
    
    public static func getSaveToLibrary() -> String {
        
        return healthServer + saveToLibrary
    }
    
    public static func getPushPatient() -> String {
        
        return pushPatient
    }
    
    public static func getSaveDeviceTokenToDB() -> String {
        
        return healthServer + saveDeviceTokenToDB
    }
}


