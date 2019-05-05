//
//  UICustomize.swift
//  HealthSnaps
//
//  Created by Admin on 13/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import Foundation
import UIKit

public func setStatusBarBackgroundColor(color: String) {
    
    UIApplication.shared.statusBarStyle = .lightContent
    UINavigationBar.appearance().clipsToBounds = true
    
    let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
    
    if color == "orange" {
        
        statusBar.backgroundColor = UIColor(hexString: "#e67e22") //UIColor.orange
        statusBar.setValue(UIColor.white, forKey: "_foregroundColor")
        
    } else if color == "white" {
        
        statusBar.backgroundColor = UIColor.white
        statusBar.setValue(UIColor.black, forKey: "_foregroundColor")
        
    } else {
        
        statusBar.backgroundColor = .none
        statusBar.setValue(UIColor.black, forKey: "_foregroundColor")
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
