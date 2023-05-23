//
//  RegisterVehicleDetailsView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit

class RegisterVehicleDetailsView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let btnBack = UIButton()
    
    let vehicleInfoLbl = UILabel()
    
    let viewIndividual = UIView()
    let collectionvw = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let stackvw = UIStackView()
    
    let vehicleModelTxtField = UITextField()
    let otherModelTxtField = UITextField()
    let vehicleNumberTxtField = UITextField()
    let serviceTypeTxtField = UITextField()
    
   
    let lblUseBrand = UILabel()
    let btnYes = UIButton()
    let btnNo = UIButton()
    
    let modelListCoverView = UIView()
    let modelListBackgroundView = UIView()
    let modelListTableView = UITableView()
 
    let btnNext = UIButton()
    
    let noTypesView = UIView()
    let lblNoTypes = UILabel()
    let imgNoTypes = UIImageView()
    
    var layoutDict = [String:AnyObject]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        baseView.backgroundColor = .secondaryColor
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["scrollView"] = scrollView
        baseView.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["contentView"] = contentView
        scrollView.addSubview(contentView)
        
        btnBack.setAppImage("BackImage")
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnBack"] = btnBack
        contentView.addSubview(btnBack)
        
        vehicleInfoLbl.text = "txt_vec_info".localize()
        vehicleInfoLbl.textColor = .hexToColor("222B45")
        vehicleInfoLbl.font = .appSemiBold(ofSize: 25)
        vehicleInfoLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["vehicleInfoLbl"] = vehicleInfoLbl
        contentView.addSubview(vehicleInfoLbl)
        
       
        viewIndividual.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewIndividual"] = viewIndividual
        contentView.addSubview(viewIndividual)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionvw.collectionViewLayout = layout
        collectionvw.showsHorizontalScrollIndicator = false
        collectionvw.backgroundColor = .secondaryColor
        collectionvw.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["collectionvw"] = collectionvw
        viewIndividual.addSubview(collectionvw)
        
        stackvw.axis = .vertical
        stackvw.distribution = .fill
        stackvw.spacing = 20
        stackvw.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["stackvw"] = stackvw
        viewIndividual.addSubview(stackvw)
        
        vehicleModelTxtField.addDropDown(text: "hint_vehicle_model".localize(), image: "filled_down_arrow")
        vehicleModelTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["vehicleModelTxtField"] = vehicleModelTxtField
        stackvw.addArrangedSubview(vehicleModelTxtField)
        
        otherModelTxtField.isHidden = true
        otherModelTxtField.addDropDown(text: "txt_model_name".localize(), image: "")
        otherModelTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["otherModelTxtField"] = otherModelTxtField
        stackvw.addArrangedSubview(otherModelTxtField)
        
        vehicleNumberTxtField.addDropDown(text: "hint_vehicle_number".localize(), image: "")
        vehicleNumberTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["vehicleNumberTxtField"] = vehicleNumberTxtField
        stackvw.addArrangedSubview(vehicleNumberTxtField)
        
        serviceTypeTxtField.isHidden = true
        serviceTypeTxtField.addDropDown(text: "txt_select_service_types".localize(), image: "filled_down_arrow")
        serviceTypeTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["serviceTypeTxtField"] = serviceTypeTxtField
        stackvw.addArrangedSubview(serviceTypeTxtField)
        
        lblUseBrand.text = "txt_brand_label_question".localize()
        lblUseBrand.numberOfLines = 0
        lblUseBrand.lineBreakMode = .byWordWrapping
        lblUseBrand.textAlignment = APIHelper.appTextAlignment
        lblUseBrand.textColor = .gray
        lblUseBrand.font = UIFont.appFont(ofSize: 15)
        lblUseBrand.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblUseBrand"] = lblUseBrand
        viewIndividual.addSubview(lblUseBrand)
        
        btnYes.isSelected = true
        btnYes.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        btnYes.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        btnYes.setImage(UIImage(named: "ic_check"), for: .selected)
        btnYes.setTitle("text_yes".localize(), for: .normal)
        btnYes.setTitleColor(.txtColor, for: .normal)
        btnYes.titleLabel?.font = UIFont.appRegularFont(ofSize: 18)
        btnYes.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnYes"] = btnYes
        viewIndividual.addSubview(btnYes)
        
        btnNo.isSelected = false
        btnNo.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        btnNo.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        btnNo.setImage(UIImage(named: "ic_check"), for: .selected)
        btnNo.setTitle("text_no".localize(), for: .normal)
        btnNo.setTitleColor(.txtColor, for: .normal)
        btnNo.titleLabel?.font = UIFont.appRegularFont(ofSize: 18)
        btnNo.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnNo"] = btnNo
        viewIndividual.addSubview(btnNo)

        btnNext.setTitle("text_submit".localize().uppercased(), for: .normal)
        btnNext.titleLabel!.font = .appSemiBold(ofSize: 18)
        btnNext.setTitleColor(.secondaryColor, for: .normal)
        btnNext.backgroundColor = .themeColor
        btnNext.layer.cornerRadius = 4
        btnNext.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnNext"] = btnNext
        contentView.addSubview(btnNext)
        
        // --------------- ModelList Cover View
        
        modelListCoverView.isHidden = true
        modelListCoverView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.3)
        modelListCoverView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["modelListCoverView"] = modelListCoverView
        baseView.addSubview(modelListCoverView)
        
        modelListBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["modelListBackgroundView"] = modelListBackgroundView
        modelListCoverView.addSubview(modelListBackgroundView)
        
        modelListTableView.layer.cornerRadius = 5
        modelListTableView.layer.borderWidth = 1
        modelListTableView.layer.borderColor = UIColor.secondaryColor.cgColor
        modelListTableView.alwaysBounceVertical = false
        modelListTableView.backgroundColor = .secondaryColor
        modelListTableView.tableFooterView = UIView()
        modelListTableView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["modelListTableView"] = modelListTableView
        modelListCoverView.addSubview(modelListTableView)
        
        
        
        // -----------No Types
        
        noTypesView.isHidden = true
        noTypesView.backgroundColor = .secondaryColor
        noTypesView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["noTypesView"] = noTypesView
        baseView.addSubview(noTypesView)
        
        lblNoTypes.text = "sry_under_maintainence_tryAgain".localize()
        lblNoTypes.textAlignment = .center
        lblNoTypes.numberOfLines = 0
        lblNoTypes.lineBreakMode = .byWordWrapping
        lblNoTypes.textColor = .txtColor
        lblNoTypes.font = UIFont.appRegularFont(ofSize: 20)
        lblNoTypes.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblNoTypes"] = lblNoTypes
        noTypesView.addSubview(lblNoTypes)
        
        imgNoTypes.contentMode = .scaleAspectFit
        imgNoTypes.image = UIImage(named: "")
        imgNoTypes.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgNoTypes"] = imgNoTypes
        noTypesView.addSubview(imgNoTypes)
        
        
        scrollView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: layoutDict))
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: [], metrics: nil, views: layoutDict))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [], metrics: nil, views: layoutDict))
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = UILayoutPriority(250)
        height.isActive = true
        
        btnBack.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btnBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[btnBack(30)]-20-[vehicleInfoLbl(35)]-30-[viewIndividual]-40-[btnNext(48)]-30-|", options: [], metrics: nil, views: layoutDict))
       
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[vehicleInfoLbl]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewIndividual]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnNext.widthAnchor.constraint(equalToConstant: 154).isActive = true
        btnNext.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
   
        
        viewIndividual.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionvw(130)]-20-[stackvw]-15-[lblUseBrand]-8-[btnYes(30)]|", options: [], metrics: nil, views: layoutDict))
        
        viewIndividual.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[collectionvw]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewIndividual.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackvw]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewIndividual.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblUseBrand]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewIndividual.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnYes(100)]-16-[btnNo(100)]", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        vehicleModelTxtField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        otherModelTxtField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        vehicleNumberTxtField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        serviceTypeTxtField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        //--------------Vehicle Model List Cover view
        
        modelListCoverView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        modelListCoverView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[modelListCoverView]|", options: [], metrics: nil, views: layoutDict))
        
        
        modelListCoverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[modelListBackgroundView]-16-|", options: [], metrics: nil, views: layoutDict))
        modelListBackgroundView.topAnchor.constraint(equalTo: vehicleModelTxtField.bottomAnchor, constant: 0).isActive = true
        modelListBackgroundView.bottomAnchor.constraint(equalTo: modelListCoverView.bottomAnchor, constant: 0).isActive = true
        
        modelListCoverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[modelListTableView]-16-|", options: [], metrics: nil, views: layoutDict))
        modelListTableView.topAnchor.constraint(equalTo: vehicleModelTxtField.bottomAnchor, constant: 0).isActive = true
        modelListTableView.bottomAnchor.constraint(equalTo: modelListCoverView.bottomAnchor, constant: 0).isActive = true
        
        // ---------------No types
        
        noTypesView.topAnchor.constraint(equalTo: vehicleInfoLbl.bottomAnchor, constant: 0).isActive = true
        noTypesView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[noTypesView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        noTypesView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[imgNoTypes(100)]-20-[lblNoTypes]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        noTypesView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblNoTypes]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        imgNoTypes.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imgNoTypes.centerXAnchor.constraint(equalTo: noTypesView.centerXAnchor, constant: 0).isActive = true
        
    }
    
}


class VehicleTypeCollectionCell: UICollectionViewCell {
    
    let viewContent = UIView()
    let imgview = UIImageView()
    let lblTypeName = UILabel()
    let viewColor = UIView()
    
    private var layoutDict = [String: AnyObject]()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupViews()
    }
    
    func setupViews() {
        
        contentView.isUserInteractionEnabled = true
        
        viewContent.layer.cornerRadius = 5
        viewContent.addShadow()
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
        imgview.contentMode = .scaleAspectFit
        layoutDict["imgview"] = imgview
        imgview.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(imgview)
        
        lblTypeName.font = UIFont.appRegularFont(ofSize: 15)
        lblTypeName.textAlignment = .center
        lblTypeName.textColor = .txtColor
        layoutDict["lblTypeName"] = lblTypeName
        lblTypeName.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTypeName)
        
        viewColor.layer.cornerRadius = 5
        viewColor.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        layoutDict["viewColor"] = viewColor
        viewColor.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(viewColor)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-6-[viewContent]-6-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[viewContent]-10-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[imgview(50)]-5-[lblTypeName(30)]-5-[viewColor(10)]|", options: [], metrics: nil, views: layoutDict))
        
        imgview.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imgview.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblTypeName]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewColor]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    }
}
