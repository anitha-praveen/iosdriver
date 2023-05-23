//
//  LaunchView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 20/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit

class LaunchView: UIView {

    let bgImgView = UIView()
    /*
    let logoImgView: UIImageView = {
        guard let gifImage = try? UIImage(gifName: "Taxiappznew.gif") else {
            return UIImageView()
        }
        return UIImageView(gifImage: gifImage, loopCount: -1)
    }()
    */
    let logoImgView = UIImageView()
    let backView = UIView()
    let contentView = UIView()
    let titleLbl = UILabel()
    let descLbl = UILabel()
    let updateBtn = UIButton()
    
    var layoutDict = [String:AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        logoImgView.contentMode = .scaleAspectFit
        logoImgView.image = UIImage(named: "splash")
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["logoImgView"] = logoImgView
        baseView.addSubview(logoImgView)
        
       
        logoImgView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        logoImgView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor,constant: -30).isActive = true
        logoImgView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor,constant: 30).isActive = true
        logoImgView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
        
       
    }

}
