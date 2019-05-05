//
//  JSONStringify.swift
//  HealthSnaps
//
//  Created by Admin on 17/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit
import Alamofire

// Stringify JSON
public func JSONStringify(value: [String: Any], prettyPrinted: Bool = false) -> String{
    let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
    
    if JSONSerialization.isValidJSONObject(value) {
        do {
            let data = try JSONSerialization.data(withJSONObject: value, options: options)
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return string as String
            }
        } catch {
            print("error")
        }
    }
    
    return ""
}

public func convertToDictionary(from: String) throws -> [String: Any] {
    
    guard let data = from.data(using: .utf8) else { return [:] }
    let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
    
    return anyResult as? [String: Any] ?? [:]
}

// Dtae Converters!
public func dateToString(date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateString = dateFormatter.string(from: date as Date)
    
    return dateString
}

public func dateToStringYMD_HMS_SSSZ(date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let dateString = dateFormatter.string(from: date as Date)
    
    return dateString
}

public func dateToStringYMD_HMS(date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let dateString = dateFormatter.string(from: date as Date)
    
    return dateString
}

public func stringToDateYMD_HMS(stringDate: String) -> Date {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let date = dateFormatter.date(from: stringDate)!
    
    return date
}

public func dateToStringMDY(date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M-dd-yyyy"
    let dateString = dateFormatter.string(from: date as Date)
    
    return dateString
}

public func stringToDate(stringDate: String) -> Date {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: stringDate)!
    
    return date
}

public func dateToStringMDhm12(date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, h:mm a"
    let dateString = dateFormatter.string(from: date as Date)
    
    return dateString
}

public func checkIntOrString(variable: Any) -> String {
    
    var correcctedVariable: String!
    
    if variable is Int {
        correcctedVariable = String(variable as! Int)
    } else {
        correcctedVariable = variable as! String
        if correcctedVariable == "" {
            correcctedVariable = "0"
        }
    }
    
    return correcctedVariable
}



