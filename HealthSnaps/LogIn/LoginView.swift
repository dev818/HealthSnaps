//
//  LoginView.swift
//  HealthSnaps
//
//  Created by Admin on 13/02/2018.
//  Copyright © 2018 getHealthSnaps. All rights reserved.
//

import UIKit
import SCLAlertView

class LoginView: UIView {    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        loginIndicator.isHidden = true
        
    }

    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        
        //Alert.showInfo(msg: RepMessage.SavedExercise.rawValue)
        //PatientListViewController().goToCameraView()
        
    }
}
