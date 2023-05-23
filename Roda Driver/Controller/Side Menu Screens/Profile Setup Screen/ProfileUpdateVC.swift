//
//  ProfileUpdateVC.swift
//  Taxiappz
//
//  Created by Ram kumar on 29/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire

enum ProfileUpdateType {
    case firstName
    case lastName
    case email
}

class ProfileUpdateVC: UIViewController {
    
    let backBtn = UIButton()
    let titleLbl = UILabel()
    let textTfd = UITextField()
    let descriptionLbl = UILabel()
    let updateBtn = UIButton()
    
    var profileField: ProfileUpdateType?
    var originalName: String?
    
    var layoutDic = [String: AnyObject]()
    
    var bottomSpace: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        initialSetup()
        
    }
    
    func setUpViews() {
        
        self.view.backgroundColor = .secondaryColor
        
        backBtn.setAppImage("BackImage")
        backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        backBtn.contentMode = .scaleAspectFit
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.backgroundColor = .secondaryColor
        layoutDic["backBtn"] = backBtn
        self.view.addSubview(backBtn)
        
        titleLbl.font = .appSemiBold(ofSize: 21)
        titleLbl.textColor = UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1)
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDic["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLbl)
        
        
//        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        let cancelBtn = UIButton()
//        cancelBtn.setImage(UIImage(named: "cancelLightGray"), for: .normal)
//        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_ :)), for: .touchUpInside)
//        cancelBtn.imageView?.contentMode = .scaleToFill
//        cancelBtn.sizeToFit()
//        rightView.addSubview(cancelBtn)
//        textTfd.rightView = rightView
//        textTfd.rightViewMode = .always
        
        textTfd.addTarget(self, action: #selector(editingChanged(_ :)), for: .editingChanged)
        textTfd.clearButtonMode = .always
        textTfd.autocorrectionType = .no
        textTfd.autocapitalizationType = .none
        textTfd.font = UIFont.appRegularFont(ofSize: 21)
        textTfd.addBorder(edges: .bottom , colour: .themeColor , thickness: 2)
        textTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["textTfd"] = textTfd
        self.view.addSubview(textTfd)
        
        
        descriptionLbl.font = .appRegularFont(ofSize: 15)
        descriptionLbl.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1)
        descriptionLbl.numberOfLines = 0
        descriptionLbl.lineBreakMode = .byWordWrapping
        descriptionLbl.textAlignment = APIHelper.appTextAlignment
        layoutDic["descriptionLbl"] = descriptionLbl
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(descriptionLbl)
        
        updateBtn.isEnabled = false
        updateBtn.alpha = 0.3
        updateBtn.setTitle("txt_update".localize().uppercased(), for: .normal)
        updateBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 19)
        updateBtn.addTarget(self, action: #selector(updateBtnAction(_ :)), for: .touchUpInside)
        updateBtn.setTitleColor(.secondaryColor, for: .normal)
        updateBtn.backgroundColor = UIColor.themeColor
        updateBtn.layer.cornerRadius = 5
        updateBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["updateBtn"] = updateBtn
        self.view.addSubview(updateBtn)
        
       
     
        
        backBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor , constant: 10).isActive = true
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[backBtn(30)]-15-[titleLbl(50)]-15-[textTfd(40)]-10-[descriptionLbl]", options: [], metrics: nil, views: layoutDic))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(30)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[textTfd]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[descriptionLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        updateBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.bottomSpace = updateBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        self.bottomSpace.isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[updateBtn]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
    }
    
    func initialSetup() {
        if self.profileField == .firstName {
            originalName = LocalDB.shared.driverDetails?.firstName
        } else if self.profileField == .lastName {
            originalName = LocalDB.shared.driverDetails?.lastName
        } else if self.profileField == .email {
            originalName = LocalDB.shared.driverDetails?.email
        }
        if self.profileField == .firstName {
            titleLbl.text = "txt_update_first_name".localize()
            if let fname = LocalDB.shared.driverDetails?.firstName {
                textTfd.text = fname
            }
            descriptionLbl.text = "txt_update_first_name_desc".localize()
        } else if self.profileField == .lastName {
            titleLbl.text = "txt_update_last_name".localize()
            if let lname = LocalDB.shared.driverDetails?.lastName {
                textTfd.text = lname
            }
            descriptionLbl.text = "txt_update_last_name_desc".localize()
        } else if self.profileField == .email {
            titleLbl.text = "txt_update_email".localize()
            if let email = LocalDB.shared.driverDetails?.email {
                textTfd.text = email
                textTfd.keyboardType = .emailAddress
            }
            descriptionLbl.text = "txt_update_email_desc".localize()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShown(_ sender:Notification) {
        if let keyBoardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue?.size {
            self.bottomSpace.constant = -keyBoardSize.height
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func keyboardHidden(_ sender:Notification) {
        self.bottomSpace.constant = -20
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func backBtnAction(_ sender: UIButton) {
        self.profileField = nil
        self.originalName = nil
        self.navigationController?.popViewController(animated: true)
    }
    @objc func cancelBtnAction(_ sender: UIButton) {
        self.textTfd.text = ""
    }
    @objc func editingChanged(_ sender: UITextField) {
        
        if sender.text == self.originalName {
            self.updateBtn.isEnabled = false
            self.updateBtn.alpha = 0.3
        } else if sender.text == "" {
            self.updateBtn.isEnabled = false
            self.updateBtn.alpha = 0.3
        } else {
            self.updateBtn.isEnabled = true
            self.updateBtn.alpha = 1
        }
        
    }
    @objc func updateBtnAction(_ sender: UIButton) {
        var errmsg = ""
        
        if self.profileField == .firstName && self.textTfd.text == "" {
            errmsg = "Validate_FirstName".localize()
        } else if self.profileField == .lastName && self.textTfd.text == "" {
            errmsg = "Validate_LastName".localize()
        } else if self.profileField == .email && self.textTfd.text == "" {
            errmsg = "Validate_Email".localize()
        } else if self.profileField == .email && !(self.textTfd.text?.isValidEmail ?? false) {
            errmsg = "text_error_email_valid".localize()
        }
        
        if errmsg.count > 0 {
            self.showAlert(errmsg)
        } else {
            self.updateprofileapicall()
        }
    }

    func updateprofileapicall() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())

            var paramDict = Dictionary<String, Any>()
           
            if self.profileField == .firstName {
                paramDict["firstname"] = self.textTfd.text
            } else if self.profileField == .lastName {
                paramDict["lastname"] = self.textTfd.text
            } else if self.profileField == .email {
                paramDict["email"] = self.textTfd.text
            } else {
                self.view.showToast("txt_something_wrong".localize())
            }
           
            let url = APIHelper.shared.BASEURL + APIHelper.getDriverProfile
            
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String: AnyObject] {
                                    if let userdetails = data["user"] as? [String:AnyObject] {
                                        LocalDB.shared.updateUserDetails(userdetails)
                                        self.profileField = nil
                                        self.originalName = nil
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            } else {
                                if let error = result["data"] as? [String:[String]] {
                                    let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                                    self.showAlert("", message: errMsg)
                                } else if let errMsg = result["error_message"] as? String {
                                    self.showAlert("", message: errMsg)
                                } else if let msg = result["message"] as? String {
                                    self.showAlert("", message: msg)
                                }
                            }
                        }
                    }
            }
        }
    }
}
extension ProfileUpdateVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if self.profileField == .firstName || self.profileField == .lastName {
            
            let allowedCharacters = CharacterSet.alphanumerics.inverted
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            
            if string == filtered {
                let maxLength = 15
                let currentString = self.textTfd.text! as NSString
                let newString =
                    currentString.replacingCharacters(in: range, with: string)
                return newString.count <= maxLength
               
            } else {
                return false
            }
        }
        return true
    }
}
