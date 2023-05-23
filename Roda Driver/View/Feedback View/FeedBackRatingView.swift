//
//  FeedBackRatingView.swift
//  Taxiappz
//
//  Created by Apple on 18/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import HCSStarRatingView
import GoogleMaps
/*
class FeedBackRatingView: UIView {
    
    let lblHeader = UILabel()

    let ratingContent = UIView()
    let viewProfile = UIView()
    let imgProfile = UIImageView()
    let lblDriverName = UILabel()
    let lblDriverRating = HCSStarRatingView()
    let lblCarNum = UILabel()
    let lblCarType = UILabel()
    let btnProfile = UIButton()
   
    let leftView = UIView()
    let rightView = UIView()
    let lineView = UIView()
    
    let lblHowisTrip = UILabel()
    let lblHint = UILabel()
    let rating = HCSStarRatingView()
    let commentView = UITextView()
    let btnSubmit = UIButton()
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        
        baseView.backgroundColor = UIColor(red: 34/255.0, green: 43/255.0, blue: 69/255.0, alpha: 1)
        
        lblHeader.text = "txt_rating".localize()
        lblHeader.textColor = .secondaryColor
        lblHeader.textAlignment = .center
        lblHeader.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["lblHeader"] = lblHeader
        lblHeader.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblHeader)
        
        ratingContent.backgroundColor = .secondaryColor
        ratingContent.layer.cornerRadius = 10
        layoutDict["ratingContent"] = ratingContent
        ratingContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(ratingContent)
        
        layoutDict["viewProfile"] = viewProfile
        viewProfile.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(viewProfile)
        
        imgProfile.backgroundColor = .hexToColor("ACB1C0")
        imgProfile.layer.cornerRadius = 50
        imgProfile.clipsToBounds = true
        layoutDict["imgProfile"] = imgProfile
        imgProfile.translatesAutoresizingMaskIntoConstraints = false
        viewProfile.addSubview(imgProfile)
        
        lblDriverName.font = UIFont.appSemiBold(ofSize: 20)
        lblDriverName.textAlignment = APIHelper.appTextAlignment
        layoutDict["lblDriverName"] = lblDriverName
        lblDriverName.translatesAutoresizingMaskIntoConstraints = false
        viewProfile.addSubview(lblDriverName)
        
        lblDriverRating.allowsHalfStars = true
        lblDriverRating.accurateHalfStars = true
        lblDriverRating.isUserInteractionEnabled = false
        lblDriverRating.tintColor = .orange
        layoutDict["lblDriverRating"] = lblDriverRating
        lblDriverRating.translatesAutoresizingMaskIntoConstraints = false
        viewProfile.addSubview(lblDriverRating)
        
        lblCarNum.textColor = .txtColor
        lblCarNum.font = UIFont.appMediumFont(ofSize: 15)
        layoutDict["lblCarNum"] = lblCarNum
        lblCarNum.translatesAutoresizingMaskIntoConstraints = false
        viewProfile.addSubview(lblCarNum)
        
        lblCarType.textColor = .gray
        lblCarType.font = UIFont.appMediumFont(ofSize: 15)
        layoutDict["lblCarType"] = lblCarType
        lblCarType.translatesAutoresizingMaskIntoConstraints = false
        viewProfile.addSubview(lblCarType)
        
        btnProfile.layer.cornerRadius = 10
        btnProfile.backgroundColor = .themeColor
        btnProfile.setTitleColor(.secondaryColor, for: .normal)
        btnProfile.titleLabel?.font = UIFont.appRegularFont(ofSize: 14)
        btnProfile.titleLabel?.adjustsFontSizeToFitWidth = true
        layoutDict["btnProfile"] = btnProfile
        btnProfile.translatesAutoresizingMaskIntoConstraints = false
        viewProfile.addSubview(btnProfile)
        
        leftView.layer.cornerRadius = 10
        leftView.backgroundColor = UIColor(red: 34/255.0, green: 43/255.0, blue: 69/255.0, alpha: 1)
        layoutDict["leftView"] = leftView
        leftView.translatesAutoresizingMaskIntoConstraints = false
        viewProfile.addSubview(leftView)
        
        rightView.layer.cornerRadius = 10
        rightView.backgroundColor = UIColor(red: 34/255.0, green: 43/255.0, blue: 69/255.0, alpha: 1)
        layoutDict["rightView"] = rightView
        rightView.translatesAutoresizingMaskIntoConstraints = false
        viewProfile.addSubview(rightView)
        
        
        //lineView.backgroundColor = UIColor(red: 34/255.0, green: 43/255.0, blue: 69/255.0, alpha: 1)
        layoutDict["lineView"] = lineView
        lineView.translatesAutoresizingMaskIntoConstraints = false
        viewProfile.addSubview(lineView)
        
        lblHowisTrip.textAlignment = .center
        lblHowisTrip.textColor = UIColor(red: 34/255.0, green: 43/255.0, blue: 69/255.0, alpha: 1)
        lblHowisTrip.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["lblHowisTrip"] = lblHowisTrip
        lblHowisTrip.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(lblHowisTrip)
        
        lblHint.textAlignment = .center
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textColor = .gray
        lblHint.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(lblHint)
        
        rating.value = 5
        rating.allowsHalfStars = true
        rating.accurateHalfStars = true
        rating.isUserInteractionEnabled = true
        rating.tintColor = .orange
        layoutDict["rating"] = rating
        rating.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(rating)
        
        commentView.layer.borderColor = UIColor.gray.cgColor
        commentView.layer.borderWidth = 0.5
        commentView.textColor = .gray
        commentView.layer.cornerRadius = 5
        commentView.font = UIFont.appFont(ofSize: 14)
        commentView.textAlignment = APIHelper.appTextAlignment
        //commentView.addShadow()
        commentView.backgroundColor = UIColor(red: 228/255.0, green: 233/255.0, blue: 242/255.0, alpha: 0.5)
        layoutDict["commentView"] = commentView
        commentView.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(commentView)
        
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnSubmit.setTitleColor(.secondaryColor, for: .normal)
        btnSubmit.backgroundColor = .themeColor
        layoutDict["btnSubmit"] = btnSubmit
        btnSubmit.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(btnSubmit)
        
       
        lblHeader.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        ratingContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor,constant: 0).isActive = true
                                              
        lblHeader.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lblHeader(25)]-16-[ratingContent]", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[ratingContent]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewProfile]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewProfile]-16-[lblHowisTrip(30)]-8-[lblHint]-30-[rating(30)]-40-[commentView(130)]-(>=8)-[btnSubmit(50)]-10-|", options: [], metrics: nil, views: layoutDict))
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblHowisTrip]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[lblHint]-50-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        rating.widthAnchor.constraint(equalToConstant: 250).isActive = true
        rating.centerXAnchor.constraint(equalTo: ratingContent.centerXAnchor, constant: 0).isActive = true
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[commentView]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[btnSubmit]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    
    // ----------------View Profile
        
        viewProfile.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[imgProfile(100)]-16-[lblDriverName]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewProfile.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[imgProfile(100)]-32-[leftView(20)]|", options: [], metrics: nil, views: layoutDict))
        viewProfile.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[lblDriverName(30)][lblDriverRating(30)][lblCarNum(30)]", options: [], metrics: nil, views: layoutDict))
        viewProfile.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[imgProfile]-16-[lblDriverRating]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        lblDriverRating.widthAnchor.constraint(equalToConstant: 100).isActive = true
        viewProfile.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[imgProfile]-16-[lblCarNum]-5-[lblCarType]", options: [APIHelper.appLanguageDirection ], metrics: nil, views: layoutDict))
        lblCarType.topAnchor.constraint(equalTo: lblCarNum.topAnchor, constant: 0).isActive = true
        lblCarType.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        btnProfile.widthAnchor.constraint(equalTo: imgProfile.widthAnchor).isActive = true
        btnProfile.centerXAnchor.constraint(equalTo: imgProfile.centerXAnchor, constant: 0).isActive = true
        btnProfile.topAnchor.constraint(equalTo: imgProfile.bottomAnchor, constant: -10).isActive = true
        btnProfile.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        leftView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        leftView.centerXAnchor.constraint(equalTo: viewProfile.leadingAnchor, constant: 0).isActive = true
        
        rightView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        rightView.centerXAnchor.constraint(equalTo: viewProfile.trailingAnchor, constant: 0).isActive = true
        rightView.topAnchor.constraint(equalTo: leftView.topAnchor, constant: 0).isActive = true
        rightView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        viewProfile.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[leftView][lineView][rightView]", options: [], metrics: nil, views: layoutDict))
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineView.centerYAnchor.constraint(equalTo: leftView.centerYAnchor, constant: 0).isActive = true
    }
}


extension UIView {
   func createDashedLine(width: CGFloat, color: CGColor) {
      let caShapeLayer = CAShapeLayer()
      caShapeLayer.strokeColor = color
      caShapeLayer.lineWidth = width
      caShapeLayer.lineDashPattern = [12,16]
      let cgPath = CGMutablePath()
      let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
      cgPath.addLines(between: cgPoint)
      caShapeLayer.path = cgPath
      layer.addSublayer(caShapeLayer)
   }
}
*/

class FeedBackRatingView: UIView {
    
    let mapview = GMSMapView()
    let titleView = UIView()
    let titleLbl = UILabel()

    let ratingContent = UIView()
    let imgProfile = UIImageView()
    let lblDriverName = UILabel()
   
    
    let lblHowisTrip = UILabel()
    let lblHint = UILabel()
    let rating = HCSStarRatingView()
    let commentView = UITextView()
    let btnSubmit = UIButton()
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        
        baseView.backgroundColor = .secondaryColor
        
        mapview.isUserInteractionEnabled = false
        layoutDict["mapview"] = mapview
        mapview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(mapview)
        
        titleView.layer.cornerRadius = 10
       // titleView.addShadow()
        titleView.backgroundColor = .secondaryColor
        layoutDict["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleView)
        
        titleLbl.text = "txt_rating".localize().uppercased()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = .center
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        ratingContent.addShadow()
        ratingContent.backgroundColor = .secondaryColor
        ratingContent.layer.cornerRadius = 30
        layoutDict["ratingContent"] = ratingContent
        ratingContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(ratingContent)
        
        
        imgProfile.image = UIImage(named: "profilePlaceHolder")
        imgProfile.backgroundColor = .hexToColor("ACB1C0")
        imgProfile.layer.cornerRadius = 8
        imgProfile.clipsToBounds = true
        layoutDict["imgProfile"] = imgProfile
        imgProfile.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(imgProfile)
        
        lblDriverName.textColor = .txtColor
        lblDriverName.font = UIFont.appMediumFont(ofSize: 25)
        lblDriverName.textAlignment = .center
        layoutDict["lblDriverName"] = lblDriverName
        lblDriverName.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(lblDriverName)
        
        
        
        lblHowisTrip.textAlignment = .center
        lblHowisTrip.textColor = .hexToColor("2F2E2E")
        lblHowisTrip.font = UIFont.appBoldFont(ofSize: 18)
        layoutDict["lblHowisTrip"] = lblHowisTrip
        lblHowisTrip.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(lblHowisTrip)
        
        lblHint.textAlignment = .center
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textColor = .hexToColor("606060")
        lblHint.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(lblHint)
        
        rating.value = 5
        rating.allowsHalfStars = true
        rating.accurateHalfStars = true
        rating.isUserInteractionEnabled = true
        rating.tintColor = .orange
        layoutDict["rating"] = rating
        rating.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(rating)
        
        commentView.layer.borderColor = UIColor.gray.cgColor
        commentView.layer.borderWidth = 0.5
        commentView.textColor = .gray
        commentView.layer.cornerRadius = 5
        commentView.font = UIFont.appFont(ofSize: 14)
        commentView.textAlignment = APIHelper.appTextAlignment
        commentView.backgroundColor = UIColor(red: 228/255.0, green: 233/255.0, blue: 242/255.0, alpha: 0.5)
        layoutDict["commentView"] = commentView
        commentView.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(commentView)
        
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnSubmit.setTitleColor(.themeTxtColor, for: .normal)
        btnSubmit.backgroundColor = .themeColor
        layoutDict["btnSubmit"] = btnSubmit
        btnSubmit.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(btnSubmit)
        
        
        // -------------Title
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[titleView]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl]-5-|", options: [], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[titleLbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // --------------
        
        mapview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mapview.bottomAnchor.constraint(equalTo: ratingContent.topAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        ratingContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[ratingContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        imgProfile.centerYAnchor.constraint(equalTo: ratingContent.topAnchor, constant: 0).isActive = true
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imgProfile(80)]-8-[lblDriverName(30)]-20-[lblHowisTrip(30)]-8-[lblHint]-20-[rating(30)]-20-[commentView(120)]-(15)-[btnSubmit(45)]-10-|", options: [], metrics: nil, views: layoutDict))
        
        imgProfile.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imgProfile.centerXAnchor.constraint(equalTo: ratingContent.centerXAnchor, constant: 0).isActive = true
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblDriverName]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblHowisTrip]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[lblHint]-50-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        rating.widthAnchor.constraint(equalToConstant: 250).isActive = true
        rating.centerXAnchor.constraint(equalTo: ratingContent.centerXAnchor, constant: 0).isActive = true
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[commentView]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[btnSubmit]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    
    }
}
