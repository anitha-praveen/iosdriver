//
//  InvoiceVC.swift
//  Taxiappz
//
//  Created by Ram kumar on 07/07/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import HCSStarRatingView
import NVActivityIndicatorView

class InvoiceVC: UIViewController {
    
    let invoiceView = InvoiceView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
      
        self.setupData()
        self.setupTarget()
        
        self.setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        MySocketManager.shared.socketDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(tripPaymentModeChanged), name: .paymentModeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tripPaymentCompleted), name: .paymentCompleted, object: nil)
    }
    
    func setUpViews() {
        invoiceView.setupViews(Base: self.view)
        
        if LocalDB.shared.currentTripDetail?.paymentOpt == "CARD" {
            if !(LocalDB.shared.currentTripDetail?.isPaid ?? false) {
                self.invoiceView.waitingForPaymentView.isHidden = false
                self.invoiceView.continueButton.isHidden = true
                self.invoiceView.lblWaitingForPayment.text = "Waiting for user to complete the card payment."
            } else {
                self.invoiceView.waitingForPaymentView.isHidden = true
                self.invoiceView.continueButton.isHidden = false
            }
        }
    }
    
    func setupTarget() {
        invoiceView.continueButton.addTarget(self, action: #selector(continueBtnAction(_ :)), for: .touchUpInside)
    }
    
    func setupData() {
        
        if let total = LocalDB.shared.currentTripDetail?.billDetails.totalAmount,
           let currency = LocalDB.shared.currentTripDetail?.billDetails.currency  {
            invoiceView.billAmountLabel.text = total + " " + currency
        }
        
    }
    
    @objc func continueBtnAction(_ sender: UIButton) {
        
        if LocalDB.shared.currentTripDetail?.customerDetails.id == "0" {
            LocalDB.shared.currentTripDetail = nil
            self.navigationController?.popToRootViewController(animated: true)
        } else if LocalDB.shared.currentTripDetail?.isInstantTrip == true {
            LocalDB.shared.currentTripDetail = nil
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let feedbackVC = FeedBackRatingVC()
            feedbackVC.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(feedbackVC, animated: true)
        }
    }
    
    @objc func tripPaymentModeChanged() {
        self.invoiceView.lblWaitingForPayment.text = "User change payment to cash. Please collect cash from the customer. Thank You!"
        self.invoiceView.continueButton.isHidden = false
    }
    @objc func tripPaymentCompleted() {
        self.invoiceView.lblWaitingForPayment.text = "User successfully paid the ride amount!!!"
        self.invoiceView.continueButton.isHidden = false
    }
    
}

//MARK: - Socket Delegates
extension InvoiceVC: MySocketManagerDelegate {
    func paymentCompleted(_ response: [String : AnyObject]) {
        print("socket -> Payment completed",response)
        self.invoiceView.lblWaitingForPayment.text = "User successfully paid the ride amount!!!"
        self.invoiceView.continueButton.isHidden = false
    }
    
    func paymentModeChanged(_ response: [String : AnyObject]) {
        print("socket -> Payment mode changed",response)
        self.invoiceView.lblWaitingForPayment.text = "User change payment to cash. Please collect cash from the customer. Thank You!"
        self.invoiceView.continueButton.isHidden = false
    }
}
