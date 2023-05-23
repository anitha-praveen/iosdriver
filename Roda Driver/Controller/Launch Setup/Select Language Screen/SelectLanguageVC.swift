//
//  SelectLanguageVC.swift
//  Taxiappz Driver
//
//  Created by spextrum on 20/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class SelectLanguageVC: UIViewController {

    let selectLanguageView = SelectLanguageView()
    
    var selectedLang: AvailableLanguageModel?
    var availableLanguage = [AvailableLanguageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupTarget()
        self.setupData()
    }
    
    func setupViews() {
        selectLanguageView.setupViews(Base: self.view)
    }

    func setupTarget() {
        selectLanguageView.tblLanguages.delegate = self
        selectLanguageView.tblLanguages.dataSource = self
        selectLanguageView.tblLanguages.register(SelectLanguageCell.self, forCellReuseIdentifier: "languagecell")
        selectLanguageView.btnSetLanguage.addTarget(self, action: #selector(btnSetLanguagePressed(_ :)), for: .touchUpInside)

    }    
}

extension SelectLanguageVC {
    
    @objc func btnSetLanguagePressed(_ sender: UIButton) {
        if let lang = self.selectedLang {
            APIHelper.shared.currentLangDate = lang.updateTime ?? 0.00
            self.getSelectLanguage(LangCode: lang.code ?? "")
        }
    }
    
    func setupData() {
        selectLanguageView.lblChooseLanguage.text = "txt_choose_language".localize()
        selectLanguageView.btnSetLanguage.setTitle("txt_set_lang".localize().uppercased(), for: .normal)
        
        self.selectedLang = self.availableLanguage.first
        self.selectLanguageView.tblLanguages.reloadData()
    }
}

extension SelectLanguageVC {
    func getSelectLanguage(LangCode: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityPulseData, nil)
            let url = APIHelper.shared.BASEURL + APIHelper.getLanguage + "/" + LangCode
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.header)
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    print("response for languages",response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                APIHelper.currentAppLanguage = LangCode
                                if let data = result["data"] as? [String: String] {
                                    print(data.count)
                                    if let json = try? JSONSerialization.data(withJSONObject: data, options: []) {
                                        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                                        let fileUrl = documentDirectoryUrl.appendingPathComponent("lang-\(LangCode).json")
                                        try? json.write(to: fileUrl, options: [])
                                        print(fileUrl)
                                    }
                                    RJKLocalize.shared.details = [:]
                                    IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "text_Done".localize()
                                    self.navigationController?.pushViewController(PageVC(), animated: true)
                                }
                            } else {
                                if let error = result["data"] as? [String:[String]] {
                                    let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                                    self.showAlert("", message: errMsg)
                                } else if let error = result["error_message"] as? String {
                                    self.showAlert("", message: error)
                                } else if let errMsg = result["message"] as? String {
                                    self.showAlert("", message: errMsg)
                                }
                            }
                        }
                    }
                }
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
}


extension SelectLanguageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languagecell") as? SelectLanguageCell ?? SelectLanguageCell()
        cell.selectionStyle = .none
        cell.lblLanguage.text = self.availableLanguage[indexPath.row].name
        if let langCode = self.availableLanguage[indexPath.row].code {
            cell.lblIdentifier.text = " ( " + langCode.uppercased()  + " )"
        }
        
        cell.chooseAction = {
            self.selectedLang = self.availableLanguage[indexPath.row]
            tableView.reloadData()
        }
        if self.selectedLang?.code == self.availableLanguage[indexPath.row].code {
            cell.btnCheck.isSelected = true
        } else {
            cell.btnCheck.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLang = self.availableLanguage[indexPath.row]
        tableView.reloadData()
    }
}

