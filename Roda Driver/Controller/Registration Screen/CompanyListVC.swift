//
//  CompanyListVC.swift
//  Roda Driver
//
//  Created by Apple on 01/04/22.
//

import UIKit
import Alamofire
class CompanyListVC: UIViewController {

    let listView = CompanyDetailsView()
    var companyList = [CompanyList]()
    var selectedCompany: CompanyList?
    
    weak var delegate: CompanyListDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        listView.setupViews(Base: self.view)
        setupTarget()
        getCompanyList()
    }
    
    func setupTarget() {
        self.listView.tblCompanyList.delegate = self
        self.listView.tblCompanyList.dataSource = self
        self.listView.tblCompanyList.register(UITableViewCell.self, forCellReuseIdentifier: "companylistcell")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - TABLE DELEGATES
extension CompanyListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companylistcell") ?? UITableViewCell()
        cell.textLabel?.text = self.companyList[indexPath.row].name
        cell.textLabel?.font = UIFont.appRegularFont(ofSize: 18)
        cell.textLabel?.textColor = .txtColor
        if self.selectedCompany?.id == self.companyList[indexPath.row].id {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCompany = self.companyList[indexPath.row]
        self.delegate?.selectedCompany(company: self.companyList[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}

//MARK: - API'S
extension CompanyListVC {
    func getCompanyList() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            let url = APIHelper.shared.BASEURL + APIHelper.getCompanyList
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { (response) in
                switch response.result {
                
                case .success(_):
                    print("company list",response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let list = data["company"] as? [[String:AnyObject]] {
                                self.companyList = list.compactMap({CompanyList($0)})
                                
                                var otherObj = [String: Any]()
                                otherObj["slug"] = "Other"
                                otherObj["firstname"] = "Other"
                                otherObj["phone_number"] = ""
                                self.companyList.append(CompanyList(otherObj))
                               DispatchQueue.main.async {
                                    self.listView.tblCompanyList.reloadData()
                                    self.listView.tblCompanyList.heightAnchor.constraint(equalToConstant: self.listView.tblCompanyList.contentSize.height).isActive = true
                                }
                            }
                        }
                    }
                case .failure(_):
                    self.view.showToast("txt_no_company_list_found".localize())
                }
            }
        }
    }
}
