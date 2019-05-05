//
//  ParamsEncoded.swift
//  HealthSnaps
//
//  Created by Admin on 17/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import Foundation

public func AccessTokenEncoded() -> String {
    
    let auth = StaticData.getUser().getAccess_token() + ":"
    let base64Credentials = base64Encoded(auth: auth)
    let authEncoded = "Basic " + base64Credentials
    
    return authEncoded
}

public func base64Encoded(auth: String) -> String {
    
    let credentialData = auth.data(using: String.Encoding.utf8)!
    let base64Credentials = credentialData.base64EncodedString(options: [])
    
    return base64Credentials
    
}

public func base64Decoded(encodedString: String) -> String {
    let newdoc = encodedString.replacingOccurrences(of: "\n", with: "")
    let decodedData = Data(base64Encoded: newdoc)!
    let decodedString = String(data: decodedData, encoding: .utf8)!
    
    return decodedString as String
}



