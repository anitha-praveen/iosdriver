//
//  RateRewardVC.swift
//  Captain Car
//
//  Created by Spextrum on 04/07/19.
//  Copyright © 2019 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class DBRateRewardVC: UIViewController {
    
    let acptValLbl = UILabel(), rewardValLbl = UILabel()
    let pointsLbl = UILabel(), totalRewardValLbl = UILabel()
    let upDownImgview = UIImageView()
    let pctView = UIProgressView()//UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMassage),name: Notification.Name("dashboardData"),object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("dashboardData"), object: nil)
    }
    
    @objc func handleMassage(notification: NSNotification) {
        if let notificationData = notification.object as? [String: AnyObject] {
            self.setupData(notificationData)
        }
    }
    
    func setupData(_ dict: [String: AnyObject]) {
        if let acceptanceRatio = dict["accept_ratio"] as? Double {
           // self.pctView.addDashedBorder(CGFloat(acceptanceRatio))
            self.pctView.progress = Float(acceptanceRatio)/100
            self.acptValLbl.text = " \(acceptanceRatio)%"
        }
        if let review = dict["review"] as? String {
            self.rewardValLbl.text = " \(review)*"
        }
        
    }
    // MARK:Adding new UI Elements in setupViews
    func setupViews() {
        var layoutDic = [String: Any]()
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .secondaryColor
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        layoutDic["scrollView"] = scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.backgroundColor = .hexToColor("F2F2F2")
        contentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["contentView"] = contentView
        scrollView.addSubview(contentView)
        
        let headerLbl = UILabel()
        headerLbl.backgroundColor = .secondaryColor
        headerLbl.textAlignment = APIHelper.appTextAlignment
        headerLbl.numberOfLines = 0
        headerLbl.lineBreakMode = .byWordWrapping
        headerLbl.textColor = .txtColor
        headerLbl.font = UIFont.appRegularFont(ofSize: 15)
        let str = "text_rateReward_header".localize()
        if let index = str.firstIndex(of: "(") {
            let attStr = NSMutableAttributedString(string: str)
            attStr.addAttributes([.font : UIFont.appBoldFont(ofSize: 16)], range: NSRange(location: index.encodedOffset, length: str.distance(from: index, to: str.endIndex)))
            headerLbl.attributedText = attStr
        } else {
            headerLbl.text = str
        }
        headerLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerLbl"] = headerLbl
        contentView.addSubview(headerLbl)
        
        let acptView = RoundedShadowView()
        acptView.addBorder(edges: .bottom, colour: .hexToColor("FB4A46"), thickness: 3.0)
        acptView.backgroundColor = .secondaryColor
        acptView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["acptView"] = acptView
        contentView.addSubview(acptView)
        
        let acptLbl = UILabel()
        acptLbl.textAlignment = APIHelper.appTextAlignment
        acptLbl.textColor = .txtColor
        acptLbl.font = UIFont.appMediumFont(ofSize: 15)
        acptLbl.text = "txt_acceptance_rate".localize()
        acptLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["acptLbl"] = acptLbl
        acptView.addSubview(acptLbl)
        
        let amountLbl = UILabel()
        amountLbl.contentMode = .bottom
        amountLbl.text = "txt_dash_amnt".localize()
        amountLbl.textColor = .hexToColor("00AE73")
        amountLbl.font = UIFont.appMediumFont(ofSize: 12)
        amountLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["amountLbl"] = amountLbl
        acptView.addSubview(amountLbl)
        
        acptValLbl.textColor = .hexToColor("00AE73")
        acptValLbl.font = UIFont.appMediumFont(ofSize: 36)
        acptValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["acptValLbl"] = acptValLbl
        acptView.addSubview(acptValLbl)
        
        let acptNoteLbl = UILabel()
        acptNoteLbl.textAlignment = APIHelper.appTextAlignment
        acptNoteLbl.textColor = .hexToColor("555555")
        acptNoteLbl.font = UIFont.appMediumFont(ofSize: 15)
        acptNoteLbl.text = "txt_total_orders".localize()
        acptNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["acptNoteLbl"] = acptNoteLbl
        acptView.addSubview(acptNoteLbl)
        
        let zeroLbl = UILabel()
        zeroLbl.textAlignment = APIHelper.appTextAlignment
        zeroLbl.textColor = .hexToColor("FB4A46")
        zeroLbl.font = UIFont.appMediumFont(ofSize: 12)
        zeroLbl.text = "0%"
        zeroLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["zeroLbl"] = zeroLbl
        acptView.addSubview(zeroLbl)
        
        let fiftyLbl = UILabel()
        fiftyLbl.textAlignment = APIHelper.appTextAlignment
        fiftyLbl.textColor = .hexToColor("FB4A46")
        fiftyLbl.font = UIFont.appMediumFont(ofSize: 12)
        fiftyLbl.text = "50%"
        fiftyLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["fiftyLbl"] = fiftyLbl
        acptView.addSubview(fiftyLbl)
        
        let hundredLbl = UILabel()
        hundredLbl.textAlignment = APIHelper.appTextAlignment
        hundredLbl.textColor = .hexToColor("FB4A46")
        hundredLbl.font = UIFont.appMediumFont(ofSize: 12)
        hundredLbl.text = "100%"
        hundredLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["hundredLbl"] = hundredLbl
        acptView.addSubview(hundredLbl)
        
        
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            
        }else{
            pctView.transform = CGAffineTransform(rotationAngle: 180.degreesToRadians)
        }
        pctView.progressTintColor = .hexToColor("00AE73")
        pctView.layer.cornerRadius = 5
        pctView.clipsToBounds = true
        pctView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pctView"] = pctView
        acptView.addSubview(pctView)
        
        let acptRateLbl = UILabel()
        acptRateLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        acptRateLbl.textColor = .gray
        acptRateLbl.font = UIFont.appFont(ofSize: 14)
        acptRateLbl.text = "txt_acceptance_rate".localize()
        acptRateLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["acptRateLbl"] = acptRateLbl
        acptView.addSubview(acptRateLbl)
        
        let noteLbl = UILabel()
        noteLbl.numberOfLines = 0
        noteLbl.lineBreakMode = .byWordWrapping
        noteLbl.textAlignment = APIHelper.appTextAlignment
        noteLbl.textColor = .txtColor
        noteLbl.font = UIFont.appRegularFont(ofSize: 15)
        noteLbl.text = "txt_cptain_reward_header".localize()
        noteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["noteLbl"] = noteLbl
        contentView.addSubview(noteLbl)
        
        let rewardView = RoundedShadowView()
        rewardView.addBorder(edges: .bottom, colour: .hexToColor("00AE73"), thickness: 3.0)
        rewardView.backgroundColor = .secondaryColor
        rewardView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["rewardView"] = rewardView
        contentView.addSubview(rewardView)
        
        let rewardLbl = UILabel()
        rewardLbl.textAlignment = APIHelper.appTextAlignment
        rewardLbl.textColor = .txtColor
        rewardLbl.font = UIFont.appMediumFont(ofSize: 15)
        rewardLbl.text = "txt_reward_points".localize()
        rewardLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["rewardLbl"] = rewardLbl
        rewardView.addSubview(rewardLbl)
        
        let rateTitleLbl = UILabel()
        rateTitleLbl.contentMode = .bottom
        rateTitleLbl.text = "text_rate".localize()
        rateTitleLbl.textColor = .hexToColor("619CF8")
        rateTitleLbl.font = UIFont.appMediumFont(ofSize: 12)
        rateTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["rateTitleLbl"] = rateTitleLbl
        rewardView.addSubview(rateTitleLbl)
        
        rewardValLbl.textAlignment = APIHelper.appTextAlignment
        rewardValLbl.textColor = .hexToColor("619CF8")
        rewardValLbl.font = UIFont.appMediumFont(ofSize: 30)
        rewardValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["rewardValLbl"] = rewardValLbl
        rewardView.addSubview(rewardValLbl)
        
        let rewardNoteLbl = UILabel()
        rewardNoteLbl.textAlignment = APIHelper.appTextAlignment
        rewardNoteLbl.textColor = .gray
        rewardNoteLbl.font = UIFont.appFont(ofSize: 14)
        rewardNoteLbl.text = "txt_amntRate".localize()
        rewardNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["rewardNoteLbl"] = rewardNoteLbl
       // rewardView.addSubview(rewardNoteLbl)
        
        let rewardPointsLbl = UILabel()
        rewardPointsLbl.textAlignment = APIHelper.appTextAlignment
        rewardPointsLbl.textColor = .txtColor
        rewardPointsLbl.font = UIFont.appBoldFont(ofSize: 16)
        rewardPointsLbl.text = "txt_reward_points".localize()
        rewardPointsLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["rewardPointsLbl"] = rewardPointsLbl
       // rewardView.addSubview(rewardPointsLbl)
        
        upDownImgview.contentMode = .scaleAspectFit
        upDownImgview.layer.cornerRadius = 0.4
        upDownImgview.layer.masksToBounds = true
        upDownImgview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["upDownImgview"] = upDownImgview
       // rewardView.addSubview(upDownImgview)
        
        pointsLbl.textAlignment = APIHelper.appTextAlignment
        pointsLbl.textColor = .txtColor
        pointsLbl.font = UIFont.appBoldFont(ofSize: 16)
        pointsLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pointsLbl"] = pointsLbl
      //  rewardView.addSubview(pointsLbl)
        
        totalRewardValLbl.textColor = .hexToColor("619CF8")
        totalRewardValLbl.font = UIFont.appMediumFont(ofSize: 15)
        totalRewardValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totalRewardValLbl"] = totalRewardValLbl
        rewardView.addSubview(totalRewardValLbl)
        
        let totalRewardLbl = UILabel()
        totalRewardLbl.textColor = .hexToColor("555555")
        totalRewardLbl.font = UIFont.appMediumFont(ofSize: 15)
        totalRewardLbl.text = "txt_total_rewards".localize()
        totalRewardLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totalRewardLbl"] = totalRewardLbl
        rewardView.addSubview(totalRewardLbl)
        
        if #available(iOS 11.0, *) {
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        }
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[scrollView]-(0)-|", options: [], metrics: nil, views: layoutDic))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [], metrics: nil, views: layoutDic))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: [], metrics: nil, views: layoutDic))
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = .defaultLow
        height.isActive = true
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[headerLbl(>=30)]-(16)-[acptView]-(16)-[noteLbl(>=30)]-(16)-[rewardView]-(>=10)-|", options: [], metrics: nil, views: layoutDic))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[headerLbl]-(10)-|", options: [], metrics: nil, views: layoutDic))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[acptView]-(10)-|", options: [], metrics: nil, views: layoutDic))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[noteLbl]-(10)-|", options: [], metrics: nil, views: layoutDic))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[rewardView]-(10)-|", options: [], metrics: nil, views: layoutDic))

        acptView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[acptLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        acptView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[amountLbl][acptValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        acptView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[acptNoteLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        acptView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[zeroLbl]-(>=5)-[fiftyLbl]-(>=5)-[hundredLbl]-(5)-|", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDic))
        fiftyLbl.centerXAnchor.constraint(equalTo: acptView.centerXAnchor).isActive = true
        acptView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[pctView]-(5)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        acptView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[acptRateLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        acptView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(15)-[acptLbl(30)]-(20)-[acptValLbl(30)]-(5)-[acptNoteLbl(21)]-(10)-[zeroLbl(21)]-(5)-[pctView(10)]-(10)-[acptRateLbl(21)]-(15)-|", options: [], metrics: nil, views: layoutDic))
        acptView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[amountLbl]-(5)-[acptNoteLbl]", options: [], metrics: nil, views: layoutDic))
        
        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[rewardLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[rateTitleLbl][rewardValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
     
        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[totalRewardValLbl]-(5)-|", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDic))
        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[totalRewardLbl]-(5)-|", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDic))

        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(15)-[rewardLbl(30)]-(10)-[rewardValLbl(30)]-(5)-[totalRewardLbl(30)]-5-[totalRewardValLbl(25)]-(15)-|", options: [], metrics: nil, views: layoutDic))
        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[rateTitleLbl]-5-[totalRewardLbl]", options: [], metrics: nil, views: layoutDic))
        
//        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[rewardLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
//        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[rateTitleLbl][rewardValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
//        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[rewardNoteLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
//        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[rewardPointsLbl]-(>=5)-[totalRewardValLbl]-(5)-|", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDic))
//        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[upDownImgview(30)]-(5)-[pointsLbl]-(5)-[totalRewardLbl]-(5)-|", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDic))
//
//        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(15)-[rewardLbl(30)]-(10)-[rewardValLbl(30)]-(5)-[rewardNoteLbl(21)]-(10)-[rewardPointsLbl(25)]-(10)-[upDownImgview(30)]-(15)-|", options: [], metrics: nil, views: layoutDic))
//        rewardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[rateTitleLbl][rewardNoteLbl]", options: [], metrics: nil, views: layoutDic))
        
        contentView.layoutIfNeeded()
        contentView.setNeedsLayout()
        
        
    }
    
 
}
// MARK: DegreesToRadians
extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}
