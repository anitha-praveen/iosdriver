//
//  ProfileVehicleDetailView.swift
//  Staxi Driver
//
//  Created by Apple on 29/06/21.
//

import UIKit

class ProfileVehicleDetailView: UIView {
    
    let backBtn = UIButton()

    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let titleLbl = UILabel()
    
    let lblVehicleType = UILabel()
    let txtVehicleType = UITextField()
    
    let lblVehicleNumber = UILabel()
    let txtVehicleNumber = UITextField()
    
    let lblVehicleModel = UILabel()
    let txtVehicleModel = UITextField()
    
    let lblZone = UILabel()
    let txtZone = UITextField()
    

    var layoutDic = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        

        backBtn.setAppImage("BackImage")
        backBtn.contentMode = .scaleAspectFit
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["backBtn"] = backBtn
        baseView.addSubview(backBtn)
        
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["scrollView"] = scrollView
        baseView.addSubview(scrollView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["containerView"] = containerView
        scrollView.addSubview(containerView)
        
        titleLbl.text = "txt_vec_info".localize().capitalized
        titleLbl.font = .appSemiBold(ofSize: 28)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDic["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLbl)
        
        [lblVehicleType,lblVehicleNumber,lblVehicleModel,lblZone].forEach({
            $0.font = .appRegularFont(ofSize: 16)
            $0.textColor = UIColor(red: 0.537, green: 0.573, blue: 0.639, alpha: 1)
            $0.textAlignment = APIHelper.appTextAlignment
        })
        
        lblVehicleType.text = "txt_veh_type".localize().uppercased()
        layoutDic["lblVehicleType"] = lblVehicleType
        lblVehicleType.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lblVehicleType)
        
        lblVehicleNumber.text = "hint_vehicle_number".localize().uppercased()
        layoutDic["lblVehicleNumber"] = lblVehicleNumber
        lblVehicleNumber.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lblVehicleNumber)
        
        lblVehicleModel.text = "hint_vehicle_model".localize().uppercased()
        layoutDic["lblVehicleModel"] = lblVehicleModel
        lblVehicleModel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lblVehicleModel)
        
    
        
        lblZone.text = "txt_zone".localize().uppercased()
        layoutDic["lblZone"] = lblZone
        lblZone.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lblZone)
        
        [txtVehicleType,txtVehicleNumber,txtVehicleModel,txtZone].forEach({
            $0.isUserInteractionEnabled = false
            $0.padding(15)
            $0.layer.cornerRadius = 5
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.hexToColor("DADADA").cgColor
            $0.backgroundColor = UIColor(red: 0.969, green: 0.973, blue: 0.98, alpha: 0.5)
            $0.font = .appSemiBold(ofSize: 16)
            $0.textColor = .txtColor
            $0.textAlignment = APIHelper.appTextAlignment
        })
        
        layoutDic["txtVehicleType"] = txtVehicleType
        txtVehicleType.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(txtVehicleType)
        
        layoutDic["txtVehicleNumber"] = txtVehicleNumber
        txtVehicleNumber.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(txtVehicleNumber)
        
        layoutDic["txtVehicleModel"] = txtVehicleModel
        txtVehicleModel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(txtVehicleModel)

        
        layoutDic["txtZone"] = txtZone
        txtZone.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(txtZone)
        
        //------------Constraints
        
        backBtn.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(30)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[backBtn(30)]-20-[scrollView]", options: [], metrics: nil, views: layoutDic))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))

        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: nil, views: layoutDic))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        containerView.widthAnchor.constraint(equalTo: baseView.widthAnchor).isActive = true
        let containerHgt = containerView.heightAnchor.constraint(equalTo: baseView.heightAnchor)
        containerHgt.priority = .defaultLow
        containerHgt.isActive = true
        
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-20-[lblVehicleType(30)]-5-[txtVehicleType(50)]-10-[lblVehicleNumber(30)]-5-[txtVehicleNumber(50)]-10-[lblVehicleModel(30)]-5-[txtVehicleModel(50)]-10-[lblZone(30)]-5-[txtZone(50)]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLbl]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        

    }
}
