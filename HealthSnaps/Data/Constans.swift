//
//  Constans.swift
//  HealthSnaps
//
//  Created by Admin on 17/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import Foundation

public var authKey = "key=AAAACBgJucY:APA91bEuZIrz85fyGnvErsKYjskhrdpODX93L7v0BnOdB-bJ5R7VM7n-1h7ynTxGMtgc42EDcVq8KLgdmB1GnP_6Mo8L-A8_1QjUcOF3luNC1Ulwmc-nTWYIApT80rCiLI-hmTuV16cj"
public var menuItems = ["Log Out", "Support"]
public var spells = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
public var spells1 = ["","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
public var validemail: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

public var device_tokenString = ""
public var login: Bool = false
public var loginPatientList: Bool = false
public var loginSendToList: Bool = false
public var reloadPatientList: Bool = false
public var fromWhichView: String = ""
public var fromHepToOverlay: Bool = false
public var fromLibrary: Bool = false

public var videoFileURL: URL!
public var exportedVideoURL: URL!
public var exerciseData: [String:Any] = [:]
public var exerciseAryOld: [[String : Any]] = []
public var exerciseIDAryOld: [String] = []
public var getExercise: Bool = false
public var videoName: String!
public var exerciseLibAry: [[String : Any]] = []
public var getExerciseLib: Bool = false
public var exerciseObj: [String:Any] = [:]
public var firstSpellAryAll: [String] = []
public var constantfirstSpellAry: [String] = []

public var sortedPatientAryAll: [[String : Any]] = []
public var constantPatientAryAll: [[String : Any]] = []
public var dischargedAryAll: [[String : Any]] = []
public var patientObjs: [[String : Any]] = []

public var template = "patient-welcome-email-2-code"

public enum userInfo: String {
    
    case username = "jordan@healthconnection.io"
    case password = "test"
    
}

public enum Ids: String {
    
    case Account_ID = "686fb6aa-f671-4532-94ac-29d69d0d1e5a"
    case Schema_ID = "345baa11-1b82-4123-bce5-be40efa0dd6b"
    case Vault_ID = "67a0d242-ad06-4db4-8819-f6f78dfe7a79"
    case PatientLog_ID = "d59f5dd1-1d34-4f4a-8b6a-c0b81849987b"
    case GetMessage_ID = "52c70421-67ab-4ac2-9fc9-b173e3a4833c"
    case GetMessageSchema_ID = "b6f3b8f5-1161-4759-b97c-0f8b6c900e3a"
    case GetExercises_ID = "f00dafae-5050-4149-8a4c-fc861f110cfd"
    case GetExercisesSchema_ID = "50d2a16f-8d59-4a49-bfca-8be362eae085"
    case GetSaveVideoFile_ID = "f5d33810-44b5-4a3f-9362-7441724b5833"
    case GetVideoAuth_ID = "eaa1d6fc-14b0-4005-8bcb-991fa16fab22"
    
}

public enum RepResult: String {
    
    case SUCCESS = "success"
    case ERROR = "error"
    case uperSUCCESS = "SUCCESS"

}

public enum exerciseDays: String {
    
    case everyday = "Everyday"
    case everyotherday = "Every Other Day"
    case weekday = "Week Days"
}

public enum HeaderType: String {
    
    case ContentType = "application/x-www-form-urlencoded"
    case ContentType_json = "application/json"
}

public enum RepMessage: String {
    
    case Login_SUCCESS = "Login success!"
    case GetUserInfo_SUCCESS = "Get User Info success!"
    case InvalidRequest = "Invalid request!"
    case InvalidUser = "Please try again!"
    case GetPatients_SUCCESS = "Get All Patients success!"
    case AddPatient_SUCCESS = "Added Patient successfully!"
    case fillFirstName = "Please fill up First Name!"
    case fillLastName = "Please fill up Last Name!"
    case fillEmail = "Please fill up Email Address!"
    case fillPhone = "Please fill up PhoneNumber!"
    case InvalidEmail = "Invalid Email Address!"
    case AlreadyUseIn = "Email already in use."
    case RequestFailed = "An error occurred. Please try again later."
    case AddPatientToGroup_SUCCESS = "Added Patient to Group successfully!"
    case EmailToPatient_SUCCESS = "Email to Patient successfully!"
    case CreatePatientLog_SUCCESS = "Created Patient Log successfully!"
    case SavePatient_SUCCESS = "Patient was saved successfully!"
    case SavingPatient = "Saving Patient..."
    case LoadingPatient = "Loading Patient..."
    case LoadingMessages = "Loading Messages..."
    case UpdatingExercise = "Updating Exercise..."
    case SendingMessage = "Sending Message..."
    case SendingMessageFailed = "Sending Message Failed. Please try again."
    case SendMessage_SUCCESS = "Sent Message successfully!"
    case updatePatient_SUCCESS = "Updated Patient successfully!"
    case updatePatientFailed = "Updating Patient Failed. Please try again."
    case GetExercise_SUCCESS = "Get Exercises Success!"
    case TimeOut = "The request timed out."
    case UpdatingPatient = "Updating Patient..."
    case UpdatePatient_SUCCESS = "Patient was updated successfully!"
    case UpdateName_SUCCESS = "Patient's Name was updated."
    case SaveActivationCode_SUCCESS = "Activation Code was saved successfully!"
    case SavingActivationCode = "Saving Activation Code..."
    case enterExerciseName = "Please enter Exercise Name!"
    case VideoUpload_SUCCESS = "Video was uploaded successfully!"
    case SaveVideo_UpdatePatientLog = "Saving Video, Updating Patient Log..."
    case SaveVideoInfo_SUCCESS = "Saved Video Info successfully!"
    case GetPatientLog_SUCCESS = "Get PatientLog Success!"
    case SavePatientLog_SUCCESS = "Saved Patient Log successfully!"
    case NotFinishOverlay = "Please wait,overlaying Exercise Name to Video."
    case SaveToLibrary_SUCCESS = "Saved to Library successfully!"
    case SavingToLibray = "Saving Video to Library..."
    case LoadingExercise = "Loading Exercises..."
    case SavedExercise = "Already saved to Library!"
    case EnteredExerciseName = "Exercise Name has already been entered!"
    case NotNeedFlash = "Not need torch on front camera mode!"
    case videoLimited = "The Maximum length for this video has been reached."
    case SendingEmailFailed = "Sending email to Patient failed. Please try again!"
    case Getbase64StringFailed = "Getting Video Failed. Please try again!"
    case GettingVideo = "Loading Video..."
    case UnavaiableLogout = "There is no Login Information. First, please Login."
    case PushNotification_SUCCESS = "Push notification success!"
}

public enum modalDescription: String {
    
    case deleteModaldesc = "Do you want to delete the patient? This cannot be undone"
    case dischargeModaldesc = "Do you want to discharge this patient?"
    
}

public enum ErrorCode: String {
    
    case In_USE = "USER.USERNAME_IN_USE"
    case Time_OUT = "-1001"
    
}
