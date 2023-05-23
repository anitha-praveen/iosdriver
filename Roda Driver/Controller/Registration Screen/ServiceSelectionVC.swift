//
//  ServiceSelectionVC.swift
//  Roda Driver
//
//  Created by Apple on 04/04/22.
//

import UIKit

class ServiceSelectionVC: UIViewController {

    private let serviceView = ServiceSelectionView()
    
    var serviceTypes = [String]()
    
    var selectedServiceTypes = [String]()
    var selectedindexPath = [IndexPath]()
    
    var callBack:((String) ->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        serviceView.setupViews(Base: self.view)
        serviceView.tblServiceList.delegate = self
        serviceView.tblServiceList.dataSource = self
        serviceView.tblServiceList.register(UITableViewCell.self, forCellReuseIdentifier: "servicecell")
        
        serviceView.btnConfirm.addTarget(self, action: #selector(confirmPressed(_ :)), for: .touchUpInside)
    }
    
    @objc func confirmPressed(_ sender: UIButton) {
        if self.selectedServiceTypes.isEmpty {
            self.view.showToast("txt_select_service_types".localize())
        } else {
            print(self.selectedServiceTypes.joined(separator: ","))
            self.dismiss(animated: true) {
                self.callBack?(self.selectedServiceTypes.joined(separator: ","))
            }
        }
    }

}

extension ServiceSelectionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "servicecell") ?? UITableViewCell()
        cell.textLabel?.text = self.serviceTypes[indexPath.row]
        cell.textLabel?.font = UIFont.appFont(ofSize: 18)
        cell.textLabel?.textColor = .txtColor
        cell.selectionStyle = .none
        if self.selectedindexPath.contains(indexPath) {
            cell.imageView?.image = UIImage(named: "ic_check")
        } else {
            cell.imageView?.image = UIImage(named: "ic_uncheck")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedindexPath.contains(indexPath) {
            if let index = self.selectedindexPath.firstIndex(of: indexPath) {
                self.selectedindexPath.remove(at: index)
            }
            if let serviceIndex = self.selectedServiceTypes.firstIndex(of: self.serviceTypes[indexPath.row]) {
                self.selectedServiceTypes.remove(at: serviceIndex)
            }
        } else {
            self.selectedindexPath.append(indexPath)
            self.selectedServiceTypes.append(self.serviceTypes[indexPath.row])
        }
        print(self.selectedServiceTypes)
        self.serviceView.tblServiceList.reloadData()
    }
    
}
