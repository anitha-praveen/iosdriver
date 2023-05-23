//
//  SideMenuVC.swift
//  Taxiappz Driver
//
//  Created by spextrum on 23/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SWRevealViewController
import NVActivityIndicatorView
import AVFoundation
class SideMenuVC: UIViewController {
    
    let sideMenuView = SideMenuView()
    var currentAppDirection = APIHelper.appLanguageDirection
    
    
    var menuItemsArr = MenuType.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.sideMenuView.menulistTableview.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.setupData()
        self.setUpViews()
        
        
    }

    //MARK: - Adding UI Elements SetupView

    func setUpViews() {
        sideMenuView.setupViews(Base: self.view, controller: self)
        sideMenuView.menulistTableview.delegate = self
        sideMenuView.menulistTableview.dataSource = self
        sideMenuView.menulistTableview.register(MenuTableViewCell.self, forCellReuseIdentifier: "menucell")
    }

 
    func setupData() {
        if APIHelper.shared.showRefferal == true {
            self.menuItemsArr = MenuType.allCases
        } else {
          //  let menuarray = self.menuItemsArr.filter{$0 != MenuType.refferal}
         //   self.menuItemsArr = menuarray
            self.menuItemsArr = MenuType.allCases
        }
        sideMenuView.menulistTableview.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        if currentAppDirection != APIHelper.appLanguageDirection {
            self.setUpViews()
            self.currentAppDirection = APIHelper.appLanguageDirection
        }
        
        if let firstName = LocalDB.shared.driverDetails?.firstName, let lastName = LocalDB.shared.driverDetails?.lastName {
            self.sideMenuView.profileusernamelbl.text = firstName + " " + lastName
        }

        self.loadProfilePicture()
        self.setGreetings()
       
        if let frontVC = self.revealViewController().frontViewController as? UINavigationController, let topVC = frontVC.viewControllers.first(where: { $0 is OnlineOfflineVC }) as? OnlineOfflineVC {
            topVC.sideMenuHideBtn.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let frontVC = self.revealViewController().frontViewController as? UINavigationController, let topVC = frontVC.viewControllers.first(where: { $0 is OnlineOfflineVC }) as? OnlineOfflineVC {
            topVC.sideMenuHideBtn.isHidden = true
        }
    }
}
extension SideMenuVC {
    func setGreetings() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<12: sideMenuView.greetingsLbl.text = "txt_good_morning".localize()
        case 12: sideMenuView.greetingsLbl.text = "txt_good_noon".localize()
        case 13..<17: sideMenuView.greetingsLbl.text = "txt_good_afternoon".localize()
        case 17..<24: sideMenuView.greetingsLbl.text = "txt_good_evening".localize()
        default: print(NSLocalizedString("Night", comment: "Night"))
        }
    }
    
//  MARK: - Load Profile Picture and set profile picture
    func loadProfilePicture() {
        
        
        if let imgStr = LocalDB.shared.driverDetails?.profilePictureUrl, let url = URL(string: imgStr) {
            self.sideMenuView.profilepictureiv.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            self.sideMenuView.profilepictureiv.kf.setImage(with: resource, placeholder: UIImage(named: "profile"), options: nil, progressBlock: nil, completionHandler: nil)
           
        } else {
            self.sideMenuView.profilepictureiv.image = UIImage(named: "profile")
        }
        
// Using S3
//        if let imgData = LocalDB.shared.profilePictureData {
//
//            sideMenuView.profilepictureiv.image = UIImage(data: imgData)
//        } else {
//            if let profilePictureUrl = LocalDB.shared.driverDetails?.profilePictureUrl {
//                self.retriveImg(key: profilePictureUrl) { data in
//                    self.sideMenuView.profilepictureiv.image = UIImage(data: data)
//
//                    LocalDB.shared.profilePictureData = data
//                }
//            } else {
//                self.sideMenuView.profilepictureiv.image = UIImage(named: "profile")
//            }
//
//        }
    }
}
extension SideMenuVC: UITableViewDelegate,UITableViewDataSource {
    
// MARK:  Tableview Methods & Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menucell", for: indexPath) as? MenuTableViewCell ?? MenuTableViewCell()

       
        cell.img.image = menuItemsArr[indexPath.row].icon
        cell.lblname.text = menuItemsArr[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            self.revealViewController().revealToggle(animated: true)
        } else {
            self.revealViewController().rightRevealToggle(animated: true)
        }
        
        if menuItemsArr[indexPath.row] == .profile {
            (self.revealViewController().frontViewController as? UINavigationController)?.pushViewController(ProfileVC(), animated: false)
        }
        else if menuItemsArr[indexPath.row] == .dashboard {
            (self.revealViewController().frontViewController as? UINavigationController)?.pushViewController(DashboardVC(), animated: false)
        }
//        else if menuItemsArr[indexPath.row] == .subscription {
//            (self.revealViewController().frontViewController as? UINavigationController)?.pushViewController(SubscriptionVC(), animated: false)
//        }
        else if menuItemsArr[indexPath.row] == .history {
            (self.revealViewController().frontViewController as? UINavigationController)?.pushViewController(HistoryVC(), animated: false)
        }
        else if menuItemsArr[indexPath.row] == .wallet {
            (self.revealViewController().frontViewController as? UINavigationController)?.pushViewController(WalletVC(), animated: false)
        }
        else if menuItemsArr[indexPath.row] == .manageDocuments {
            (self.revealViewController().frontViewController as? UINavigationController)?.pushViewController(ManageDocumentVC(), animated: false)
        }
        else  if menuItemsArr[indexPath.row] == .appStatus {
            (self.revealViewController().frontViewController as? UINavigationController)?.pushViewController(AppStatusVC(), animated: false)
        }
        
        if menuItemsArr[indexPath.row] == .notification {
            (self.revealViewController().frontViewController as? UINavigationController)?.pushViewController(NotificationVC(), animated: false)
        }
        else if menuItemsArr[indexPath.row] == .support {
            (self.revealViewController().frontViewController as? UINavigationController)?.pushViewController(SupportVC(), animated: false)
        }
        else if menuItemsArr[indexPath.row] == .refferal {
            
            (self.revealViewController().frontViewController as? UINavigationController)?.pushViewController(RefferalVC(), animated: false)
        }
        else if menuItemsArr[indexPath.row] == .share {
            guard let url = URL(string:"") else { return }
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = cell
            activityViewController.popoverPresentationController?.sourceRect = cell.bounds
            present(activityViewController, animated: true, completion: {})
        }
        else if menuItemsArr[indexPath.row] == .logout {
            let vc = LogoutVC()
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
}
