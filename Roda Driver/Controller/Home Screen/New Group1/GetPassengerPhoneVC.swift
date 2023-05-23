//
//  GetPassengerPhoneVC.swift
//  Roda Driver
//
//  Created by NPlus Technologies on 06/05/22.
//

import UIKit

class GetPassengerPhoneVC: UIViewController {

    let viewService = UIView()
    let btnCloseService = UIButton()
    let lblHeaderService = UILabel()
    let phoneNumTxtFld = UITextField()
    let btnStartTrip = UIButton()
    
    var layoutDict = [String: AnyObject]()
    var callBack:((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        
        setupViews()
        
    }

    func setupViews() {

        viewService.layer.cornerRadius = 20
        viewService.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewService.backgroundColor = .secondaryColor
        layoutDict["viewService"] = viewService
        viewService.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewService)
        
        btnCloseService.addTarget(self, action: #selector(btnCloseServicePressed(_ :)), for: .touchUpInside)
        btnCloseService.setImage(UIImage(named: "cancelLightGray")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnCloseService.tintColor = .red
        btnCloseService.contentMode = .scaleAspectFit
        layoutDict["btnCloseService"] = btnCloseService
        btnCloseService.translatesAutoresizingMaskIntoConstraints = false
        viewService.addSubview(btnCloseService)
        
        lblHeaderService.text = "txt_enter_pass_num".localize()
        lblHeaderService.font = UIFont.appFont(ofSize: 16)
        lblHeaderService.textAlignment = APIHelper.appTextAlignment
        lblHeaderService.textColor = .txtColor
        layoutDict["lblHeaderService"] = lblHeaderService
        lblHeaderService.translatesAutoresizingMaskIntoConstraints = false
        viewService.addSubview(lblHeaderService)
        
        phoneNumTxtFld.layer.cornerRadius = 10
        phoneNumTxtFld.delegate = self
        phoneNumTxtFld.keyboardType = .phonePad
        phoneNumTxtFld.textAlignment = APIHelper.appTextAlignment
        phoneNumTxtFld.drawFormField(placeholder: "txt_enter_pass_num".localize())
        phoneNumTxtFld.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["phoneNumTxtFld"] = phoneNumTxtFld
        viewService.addSubview(phoneNumTxtFld)
        
        btnStartTrip.layer.cornerRadius = 5
        btnStartTrip.addTarget(self, action: #selector(btnStartTripPressed(_ :)), for: .touchUpInside)
        btnStartTrip.setTitle("text_start_trip".localize(), for: .normal)
        btnStartTrip.setTitleColor(.secondaryColor, for: .normal)
        btnStartTrip.backgroundColor = .themeColor
        layoutDict["btnStartTrip"] = btnStartTrip
        btnStartTrip.translatesAutoresizingMaskIntoConstraints = false
        viewService.addSubview(btnStartTrip)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewService]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewService.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        viewService.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[lblHeaderService(30)]-10-[phoneNumTxtFld(50)]-10-[btnStartTrip(40)]-10-|", options: [], metrics: nil, views: layoutDict))
        viewService.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[lblHeaderService]-5-[btnCloseService(25)]-15-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        viewService.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[phoneNumTxtFld]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        btnStartTrip.widthAnchor.constraint(equalToConstant: 130).isActive = true
        btnStartTrip.centerXAnchor.constraint(equalTo: viewService.centerXAnchor).isActive = true
    }
}

extension GetPassengerPhoneVC {
    @objc func btnCloseServicePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func btnStartTripPressed(_ sender: UIButton) {
        if self.phoneNumTxtFld.text!.isEmpty {
            self.showAlert("", message: "txt_mobile_num_validate".localize())
        } else if (phoneNumTxtFld.text?.count ?? 0) < 10 {
            showAlert("", message: "txt_enter_valid_phone_number".localize())
        } else {
            self.callBack?(self.phoneNumTxtFld.text ?? "")
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == self.view {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
extension GetPassengerPhoneVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center

        let currentString = textField.text! as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        if textField == self.phoneNumTxtFld {
            let maxLength = 10
            return newString.count <= maxLength
        }
        return true
    }
}

