//
//  historycancelleddetailsVC.swift
//  TapNGo Driver
//
//  Created by Mohammed Arshad on 20/03/18.
//  Copyright © 2018 nPlus. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Kingfisher

class HistoryCancelledDetailsVC: UIViewController {
    
    let historyCancelledView = HistoryCancelledView()
    
    var rideHistory: HistroyDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpViews()
        self.setupTarget()
        self.setupdata()
    }
    
    // MARK: Adding UI Elements in setupViews
    func setUpViews() {
        historyCancelledView.setupViews(Base: self.view)
    }
    
    func setupTarget() {
        self.historyCancelledView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
    }
    
    @objc func backBtnAction(_ sender: UIButton) {
        self.rideHistory = nil
        self.navigationController?.popViewController(animated: true)
    }
}

extension HistoryCancelledDetailsVC {
    //--------------------------------------
    // MARK: - Populating history info
    //--------------------------------------
    
    func setupdata() {
        if let userdict = self.rideHistory?.userDetails {
           
            if let imgStr = userdict.userProfilePicUrlStr, let url = URL(string: imgStr) {
                self.historyCancelledView.userprofilepicture.kf.indicatorType = .activity
                let resource = ImageResource(downloadURL: url)
                self.historyCancelledView.userprofilepicture.kf.setImage(with: resource, placeholder: UIImage(named: "historyProfilePlaceholder"), options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                self.historyCancelledView.userprofilepicture.image = UIImage(named: "historyProfilePlaceholder")
            }
            
// Using S3
//            if let profilePictureUrl = userdict.userProfilePicUrlStr {
//                self.historyCancelledView.userprofilepicture.image = UIImage(named: "historyProfilePlaceholder")
//                self.historyCancelledView.activityIndicator.startAnimating()
//                self.retriveImg(key: profilePictureUrl) { data in
//                    print("IMAGE DATA",data)
//                    self.historyCancelledView.userprofilepicture.image = UIImage(data: data)
//                   self.historyCancelledView.activityIndicator.stopAnimating()
//                }
//            } else {
//                self.historyCancelledView.userprofilepicture.image = UIImage(named: "historyProfilePlaceholder")
//            }
            
            if let firstName = userdict.userFirstName, let lastName = userdict.userLastName {
                self.historyCancelledView.usernamelbl.text = firstName + " " + lastName
            }
        }
        
        if let rating = rideHistory?.review {
            self.historyCancelledView.ratingLbl.text =  String(format: "%.2f", rating)
        }
        if let res = rideHistory?.requestId {
            self.historyCancelledView.carLbl.text = res
        }
        self.historyCancelledView.pickupaddrlbl.text = rideHistory?.pickLocation
        
        if let dropLocation = self.rideHistory?.dropLocation {
            self.historyCancelledView.dropupaddrlbl.text = dropLocation
        } else {
            print("HERE...")
            self.historyCancelledView.dropupaddrlbl.text = "---"
        }
        
        
        if let time = rideHistory?.tripStartTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: time) {
                dateFormatter.dateFormat = "EEE,MMM dd, hh:mm a"
                self.historyCancelledView.dateTimeLbl.text = dateFormatter.string(from: date)
            }
        }
    }
}
