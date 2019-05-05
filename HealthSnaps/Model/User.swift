//
//  UserModel.swift
//  HealthSnaps
//
//  Created by Admin on 15/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SCLAlertView

public class User {
    
    init(username: String, password: String, account_id: String) {
        self.username = username
        self.password = password
        self.account_id = account_id
    }
    
    private var username: String!
    private var password: String!
    private var account_id: String!
    private var userId: String!
    private var access_token: String!
    private var status: String!
    private var mfa_enrolled: Bool!
    private var attributes: [String : Any]!
    private var group_ids: NSArray!
    
    public func getUserLoginFields() -> [String : AnyObject] {
        
        var params = [String : AnyObject]()
        params = ["username" : self.username as AnyObject,
                  "password" : self.password as AnyObject,
                  "account_id" : self.account_id as AnyObject]
        
        return params
    }
    
    public func getUserAllFields() -> [String : AnyObject] {
        //var params = getUserLoginFields()
        var params = [String : AnyObject]()
        params = ["username" : self.username as AnyObject,
                  "password" : self.password as AnyObject,
                  "account_id" : self.account_id as AnyObject,
                  "userId" : self.userId as AnyObject,
                  "access_token" : self.access_token as AnyObject,
                  "status" : self.status as AnyObject,
                  "mfa_enrolled" : self.mfa_enrolled as AnyObject,
                  "attributes" : self.attributes as AnyObject,
                  "group_ids" : self.group_ids as AnyObject]
        
        return params
    }
    
    public func getUsername() -> String {
        return username
    }
    
    public func setUsername(username: String) {
        self.username = username
    }
    
    public func getPassword() -> String {
        return password
    }
    
    public func setPassword(password: String) {
        self.password = password
    }
    
    public func getAccount_id() -> String {
        return account_id
    }
    
    public func setAccount_id(account_id: String) {
        self.account_id = account_id;
    }
    
    public func getUserId() -> String {
        return userId
    }
    
    public func setUserId(userId: String) {
        self.userId = userId;
    }
    
    public func getAccess_token() -> String {
        return access_token
    }
    
    public func setAccess_token(access_token: String) {
        self.access_token = access_token
    }
    
    public func getStatus() -> String {
        return status
    }
    
    public func setStatus(status: String) {
        self.status = status
    }
    
    public func getMfa_enrolled() -> Bool {
        return mfa_enrolled
    }
    
    public func setMfa_enrolled(mfa_enrolled: Bool) {
        self.mfa_enrolled = mfa_enrolled
    }
    
    public func getAttributes() -> [String : Any] {
        return attributes
    }

    public func setAttributes(attributes: [String: Any]) {
        self.attributes = attributes
    }

    public func getGroup_ids() -> NSArray {
        return group_ids
    }

    public func setGroup_ids(group_ids: NSArray) {
        self.group_ids = group_ids
    }
    
//
//    public func getVerified() -> Bool {
//        return isVerified
//    }
//
//    public func setVerified(verified: Bool) {
//        self.isVerified = verified
//    }
//
//    public func getActivavteToken() -> String {
//        return activavteToken
//    }
//
//    public func setActivavteToken(activavteToken: String) {
//        self.activavteToken = activavteToken
//    }
//
//    public func getCreateDate() -> String {
//        return createDate
//    }
//
//    public func setCreateDate(createDate: String) {
//        self.createDate = createDate
//    }
//
//    public func getLastUpdateDate() -> String {
//        return lastUpdateDate
//    }
//
//    public func setLastUpdateDate(lastUpdateDate: String) {
//        self.lastUpdateDate = lastUpdateDate
//    }
//
//    public func getNickname() -> String {
//        return nickname
//    }
//
//    public func setNickname(nickname: String) {
//        self.nickname = nickname
//    }
//
//    public func getFirstName() -> String {
//        return firstName
//    }
//
//    public func setFirstName(firstName: String) {
//        self.firstName = firstName
//    }
//
//    public func getLastName() -> String {
//        return lastName
//    }
//
//    public func setLastName(lastName: String) {
//        self.lastName = lastName
//    }
//
//    public func getProfileImageAdded() -> Bool {
//        return profileImageAdded
//    }
//
//    public func setProfileImageAdded(profileImageAdded: Bool) {
//        self.profileImageAdded = profileImageAdded
//    }
//
//    public func getMobileNumberBusiness() -> String {
//        return mobileNumberBusiness
//    }
//
//    public func setMobileNumberBusiness(mobileNumberBusiness: String) {
//        self.mobileNumberBusiness = mobileNumberBusiness
//    }
//
//    public func getLandlineNumberPrivate() -> String {
//        return landlineNumberPrivate
//    }
//
//    public func setLandlineNumberPrivate(landlineNumberPrivate: String) {
//        self.landlineNumberPrivate = landlineNumberPrivate
//    }
//
//    public func getLandlineNumberBusiness() -> String {
//        return landlineNumberBusiness
//    }
//
//    public func setLandlineNumberBusiness(landlineNumberBusiness: String) {
//        self.landlineNumberBusiness = landlineNumberBusiness
//    }
//
//    public func getGender() -> String {
//        return gender
//    }
//
//    public func setGender(gender: String) {
//        self.gender = gender
//    }
//
//    public func getBirthDate() -> String {
//        return birthDate
//    }
//
//    public func setBirthDate(birthDate: String) {
//        self.birthDate = birthDate
//    }
//
//    //    public func getSocialProfile() -> SocialProfile {
//    //       return socialProfile
//    //    }
//    //
//    //    public func setSocialProfile(socialProfile: SocialProfile) {
//    //       self.socialProfile = socialProfile
//    //    }
//
//    public func getAddressPrivate() -> Address {
//        return addressPrivate
//    }
//
//    public func setAddressPrivate(addressPrivate: Address) {
//        self.addressPrivate = addressPrivate
//    }
//
//    //    public func getAddressBusiness() -> Address {
//    //       return addressBusiness
//    //    }
//    //
//    //    public func setAddressBusiness(addressBusiness: Address) {
//    //       self.addressBusiness = addressBusiness
//    //    }
//
//    //    public ArrayList<Contact> getContacts() {
//    //       return contacts
//    //    }
//    //
//    //    public void setContacts(ArrayList<Contact> contacts) {
//    //    this.contacts = contacts;
//    //    }
//
//    public func getGroup() -> String {
//        return group
//    }
//
//    public func setGroup(group: String) {
//        self.group = group
//    }
    
    
}

