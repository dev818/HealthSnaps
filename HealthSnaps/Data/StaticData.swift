//
//  StaticData.swift
//  HealthSnaps
//
//  Created by Admin on 15/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit

public class StaticData {
    
    private static var user: User!
    
    public static func getUser() -> User {
        return user
    }
    
    public static func setUser(user: User) {
        StaticData.user = user
    }    
    
}

