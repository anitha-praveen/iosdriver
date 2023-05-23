//
//  UpdateAppVC.swift
//  Taxiappz Driver
//
//  Created by Apple on 22/02/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit

class UpdateAppVC: UIViewController {

    let updateAppView = UpdateAppView()

    override func viewDidLoad() {
        super.viewDidLoad()

        updateAppView.setupViews(Base: self.view)
        updateAppView.btnSubmit.addTarget(self, action: #selector(btnSubmitPressed(_ :)), for: .touchUpInside)

    }
    
    @objc func btnSubmitPressed(_ sender: UIButton) {
        
        guard let url = URL(string: "") else {
                return
        }

        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
