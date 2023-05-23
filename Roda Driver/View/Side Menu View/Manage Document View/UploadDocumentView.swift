//
//  UploadDocumentView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import SwiftUI

/*
class UploadDocumentView: UIView {
    
    let viewContent = UIView()
    let btnClose = UIButton()
    let lblTitle = UILabel()
    let imgView = UIViewWithDashedLineBorder()
    let imgBtn = UIButton()
    var activityIndicator = UIActivityIndicatorView()
  
    let stackview = UIStackView()
    let viewIdentifier = UIView()
    let lblIdentifierName = UILabel()
    let txtIdentifier = UITextField()
    let txtExpiry = RJKPickerTextField()
    let txtIssuseDate = RJKPickerTextField()
    let btnUpload = UIButton()
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
        
        btnClose.setImage(UIImage(named: "BackImage"), for: .normal)
        layoutDict["btnClose"] = btnClose
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnClose)
        
        lblTitle.textAlignment = .left
        lblTitle.textColor = .txtColor
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTitle)
        
        imgView.layer.cornerRadius = 12
        imgView.layer.masksToBounds = true
        imgView.backgroundColor = .secondaryColor
        layoutDict["imgView"] = imgView
        imgView.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(imgView)
        
        imgBtn.contentMode = .scaleAspectFit
        layoutDict["imgBtn"] = imgBtn
        imgBtn.translatesAutoresizingMaskIntoConstraints = false
        imgView.addSubview(imgBtn)
    
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(activityIndicator)
        
        stackview.axis = .vertical
        stackview.distribution = .fill//.fillEqually
        stackview.spacing = 10
        layoutDict["stackview"] = stackview
        stackview.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(stackview)
        
        layoutDict["viewIdentifier"] = viewIdentifier
        viewIdentifier.translatesAutoresizingMaskIntoConstraints = false
        stackview.addArrangedSubview(viewIdentifier)
        
        lblIdentifierName.numberOfLines = 0
        lblIdentifierName.lineBreakMode = .byWordWrapping
        lblIdentifierName.textAlignment = APIHelper.appTextAlignment
        lblIdentifierName.textColor = .gray
        lblIdentifierName.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblIdentifierName"] = lblIdentifierName
        lblIdentifierName.translatesAutoresizingMaskIntoConstraints = false
        viewIdentifier.addSubview(lblIdentifierName)
        
        
        txtIdentifier.padding(10)
        txtIdentifier.layer.cornerRadius = 5
        txtIdentifier.layer.borderColor = UIColor.gray.cgColor
        txtIdentifier.layer.borderWidth = 1
        txtIdentifier.font = UIFont.appRegularFont(ofSize: 15)
        txtIdentifier.textColor = .txtColor
        txtIdentifier.textAlignment = APIHelper.appTextAlignment
        layoutDict["txtIdentifier"] = txtIdentifier
        txtIdentifier.translatesAutoresizingMaskIntoConstraints = false
        viewIdentifier.addSubview(txtIdentifier)
        
        let expView = UIView()
        expView.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        let expImg = UIButton()
        expImg.frame = CGRect(x: 10, y: 5, width: 30, height: 30)
        expImg.setImage(UIImage(named: "ic_calender"), for: .normal)
        expView.addSubview(expImg)
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            txtExpiry.leftView = expView
            txtExpiry.leftViewMode = .always
        } else {
            txtExpiry.rightView = expView
            txtExpiry.rightViewMode = .always
        }
        
        txtExpiry.changeTextFieldType(.datePicker)
        txtExpiry.configureDatePicker(Date(), maxDate: nil, dateFormat: "YYYY-MM-dd")
        txtExpiry.backgroundColor = .secondaryColor
        txtExpiry.layer.cornerRadius = 5
        txtExpiry.layer.borderColor = UIColor.gray.cgColor
        txtExpiry.layer.borderWidth = 1
        txtExpiry.placeholder = "txt_Exp_date".localize()
        txtExpiry.textColor = .txtColor
        txtExpiry.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["txtExpiry"] = txtExpiry
        txtExpiry.translatesAutoresizingMaskIntoConstraints = false
        stackview.addArrangedSubview(txtExpiry)
        
        let expView1 = UIView()
        expView1.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        let expImg1 = UIButton()
        expImg1.frame = CGRect(x: 10, y: 5, width: 30, height: 30)
        expImg1.setImage(UIImage(named: "ic_calender"), for: .normal)
        expView1.addSubview(expImg1)
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            txtIssuseDate.leftView = expView1
            txtIssuseDate.leftViewMode = .always
        } else {
            txtIssuseDate.rightView = expView1
            txtIssuseDate.rightViewMode = .always
        }
        
        txtIssuseDate.changeTextFieldType(.datePicker)
        txtIssuseDate.configureDatePicker(nil, maxDate: Date(), dateFormat: "YYYY-MM-dd")
        txtIssuseDate.backgroundColor = .secondaryColor
        txtIssuseDate.layer.cornerRadius = 5
        txtIssuseDate.layer.borderColor = UIColor.gray.cgColor
        txtIssuseDate.layer.borderWidth = 1
        txtIssuseDate.placeholder = "txt_issuse_date".localize()
        txtIssuseDate.textColor = .txtColor
        txtIssuseDate.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["txtIssuseDate"] = txtIssuseDate
        txtIssuseDate.translatesAutoresizingMaskIntoConstraints = false
        stackview.addArrangedSubview(txtIssuseDate)
        
        //text_upload_title
        btnUpload.setTitle("txt_upload".localize().uppercased(), for: .normal)
        btnUpload.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnUpload.setTitleColor(.secondaryColor, for: .normal)
        btnUpload.layer.cornerRadius = 5
        btnUpload.backgroundColor = .themeColor
        layoutDict["btnUpload"] = btnUpload
        btnUpload.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnUpload)
        
        viewContent.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [], metrics: nil, views: layoutDict))
        

        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[btnClose(32)]-20-[imgView(200)]-32-[stackview]", options: [], metrics: nil, views: layoutDict))
        
        lblTitle.centerYAnchor.constraint(equalTo: btnClose.centerYAnchor, constant: 1).isActive = true
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnUpload(50)]-20-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[btnClose(30)]-7-[lblTitle]-5-|", options: [], metrics: nil, views: layoutDict))
        
       
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-33-[imgView]-33-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[btnUpload]-32-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[stackview]-32-|", options: [], metrics: nil, views: layoutDict))
        
        imgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imgBtn]|", options: [], metrics: nil, views: layoutDict))
        imgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imgBtn]|", options: [], metrics: nil, views: layoutDict))
        
        activityIndicator.centerXAnchor.constraint(equalTo: imgBtn.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: imgBtn.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        viewIdentifier.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblIdentifierName]-8-[txtIdentifier(45)]-5-|", options: [], metrics: nil, views: layoutDict))
        viewIdentifier.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblIdentifierName]|", options: [], metrics: nil, views: layoutDict))
        viewIdentifier.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[txtIdentifier]|", options: [], metrics: nil, views: layoutDict))
        
        txtExpiry.heightAnchor.constraint(equalToConstant: 45).isActive = true
        txtIssuseDate.heightAnchor.constraint(equalToConstant: 45).isActive = true

    }
}


class UIViewWithDashedLineBorder: UIView {

    override func draw(_ rect: CGRect) {

         let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 16, height: 16))

        UIColor.secondaryColor.setFill()
        path.fill()

        UIColor.txtColor.setStroke()
        path.lineWidth = 10

        let dashPattern : [CGFloat] = [10, 4]
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.stroke()
    }
}
*/


class UploadDocumentsView: UIView {

    let btnBack = UIButton()
    let titleView = UIView()
    let documentNameLbl = UILabel()
    
    let scrollview = UIScrollView()
    let contentView = UIView()
    
    
    let stackDocument = UIStackView()
    
    let docNumberView = UIView()
    let docNumTitleLbl = UILabel()
    let docNumTxtField = UITextField()
    
    let expDateView = UIView()
    let expDateTitleLbl = UILabel()
    let expDateTxtField = RJKPickerTextField()
    
    let issueDateView = UIView()
    let issueDateTitleLbl = UILabel()
    let issueDateTxtField = RJKPickerTextField()
    
    let docImgCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

  
    let uploadBtn = UIButton()
    
    var layoutDict = [String:AnyObject]()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        btnBack.setImage(UIImage(named: "back_img"), for: .normal)
        btnBack.layer.cornerRadius = 25
        btnBack.addShadow()
        layoutDict["btnBack"] = btnBack
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnBack)
        
        titleView.layer.cornerRadius = 7
        titleView.addShadow()
        titleView.backgroundColor = .secondaryColor
        titleView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["titleView"] = titleView
        baseView.addSubview(titleView)
        
        
        documentNameLbl.textAlignment = APIHelper.appTextAlignment
        documentNameLbl.font = UIFont.appBoldFont(ofSize: 17)
        documentNameLbl.textColor = .txtColor
        documentNameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["documentNameLbl"] = documentNameLbl
        titleView.addSubview(documentNameLbl)
        
        scrollview.bounces = false
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["scrollview"] = scrollview
        baseView.addSubview(scrollview)
        
        contentView.backgroundColor = .secondaryColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["contentView"] = contentView
        scrollview.addSubview(contentView)
        
        
        stackDocument.axis = .vertical
        stackDocument.spacing = 18
        stackDocument.distribution = .fill
        stackDocument.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["stackDocument"] = stackDocument
        contentView.addSubview(stackDocument)
        
        //Document Number
        
        docNumberView.isHidden = true
        docNumberView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["docNumberView"] = docNumberView
        stackDocument.addArrangedSubview(docNumberView)
        
        docNumTitleLbl.textColor = .txtColor
        docNumTitleLbl.textAlignment = APIHelper.appTextAlignment
        docNumTitleLbl.font = UIFont.appSemiBold(ofSize: 14)
        docNumTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["docNumTitleLbl"] = docNumTitleLbl
        docNumberView.addSubview(docNumTitleLbl)
        
        docNumTxtField.layer.borderColor = UIColor.hexToColor("#E4E9F2").cgColor
        docNumTxtField.layer.borderWidth = 1
        docNumTxtField.layer.cornerRadius = 6
        docNumTxtField.addPadding(.both(10))
        docNumTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["docNumTxtField"] = docNumTxtField
        docNumberView.addSubview(docNumTxtField)
        
        
        // Document Expairy Date
        
        expDateView.isHidden = true
        expDateView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["expDateView"] = expDateView
        stackDocument.addArrangedSubview(expDateView)
        
        expDateTitleLbl.text = "txt_Exp_date".localize()
        expDateTitleLbl.textColor = .txtColor
        expDateTitleLbl.textAlignment = APIHelper.appTextAlignment
        expDateTitleLbl.font = UIFont.appSemiBold(ofSize: 14)
        expDateTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["expDateTitleLbl"] = expDateTitleLbl
        expDateView.addSubview(expDateTitleLbl)
        
        expDateTxtField.changeTextFieldType(.datePicker)
        expDateTxtField.configureDatePicker(Date(), maxDate: nil, dateFormat: "YYYY-MM-dd")
        expDateTxtField.placeholder = "txt_Exp_date".localize()
        expDateTxtField.layer.borderColor = UIColor.hexToColor("#E4E9F2").cgColor
        expDateTxtField.layer.borderWidth = 1
        expDateTxtField.layer.cornerRadius = 6
        expDateTxtField.addPadding(.both(10))
        expDateTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["expDateTxtField"] = expDateTxtField
        expDateView.addSubview(expDateTxtField)
        
        // Document Issue Date
        
        issueDateView.isHidden = true
        issueDateView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["issueDateView"] = issueDateView
        stackDocument.addArrangedSubview(issueDateView)
        
        issueDateTitleLbl.text = "txt_issuse_date".localize()
        issueDateTitleLbl.textColor = .txtColor
        issueDateTitleLbl.textAlignment = APIHelper.appTextAlignment
        issueDateTitleLbl.font = UIFont.appSemiBold(ofSize: 14)
        issueDateTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["issueDateTitleLbl"] = issueDateTitleLbl
        issueDateView.addSubview(issueDateTitleLbl)
        
        issueDateTxtField.changeTextFieldType(.datePicker)
        issueDateTxtField.configureDatePicker(nil, maxDate: Date(), dateFormat: "YYYY-MM-dd")
        issueDateTxtField.placeholder = "txt_issuse_date".localize()
        issueDateTxtField.layer.borderColor = UIColor.hexToColor("#E4E9F2").cgColor
        issueDateTxtField.layer.borderWidth = 1
        issueDateTxtField.layer.cornerRadius = 6
        issueDateTxtField.addPadding(.both(10))
        issueDateTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["issueDateTxtField"] = issueDateTxtField
        issueDateView.addSubview(issueDateTxtField)
        
        
        // Document Image Collection View
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        docImgCollectionView.collectionViewLayout = layout
        docImgCollectionView.alwaysBounceHorizontal = false
        docImgCollectionView.showsVerticalScrollIndicator = false
        docImgCollectionView.backgroundColor = .secondaryColor
        docImgCollectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["docImgCollectionView"] = docImgCollectionView
        contentView.addSubview(docImgCollectionView)
        
      
        // Upload button
        uploadBtn.setTitle("Upload", for: .normal)
        uploadBtn.layer.cornerRadius = 8
        uploadBtn.backgroundColor = .themeColor
        uploadBtn.setTitleColor(.themeTxtColor, for: .normal)
        uploadBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        uploadBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["uploadBtn"] = uploadBtn
        baseView.addSubview(uploadBtn)
        
        btnBack.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        titleView.heightAnchor.constraint(equalTo: btnBack.heightAnchor).isActive = true
        titleView.centerYAnchor.constraint(equalTo: btnBack.centerYAnchor).isActive = true
        
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[documentNameLbl]|", options: [], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[documentNameLbl]-5-|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnBack(50)]-12-[titleView]-20-|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDict))
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnBack(50)]-5-[scrollview][uploadBtn(45)]", options: [], metrics: nil, views: layoutDict))
    
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollview]|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDict))
        
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDict))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDict))
        contentView.widthAnchor.constraint(equalTo: scrollview.widthAnchor, constant: 0).isActive = true
        let contentHgt = contentView.heightAnchor.constraint(equalTo: scrollview.heightAnchor, constant: 0)
        contentHgt.priority = .defaultLow
        contentHgt.isActive = true
        
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[stackDocument]-20-[docImgCollectionView]-10-|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[stackDocument]-15-|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[docImgCollectionView]-15-|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDict))
        

        
        uploadBtn.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[uploadBtn]-20-|", options: [], metrics: nil, views: layoutDict))
        
        
        docNumberView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[docNumTitleLbl(15)]-8-[docNumTxtField(45)]|", options: [], metrics: nil, views: layoutDict))
        docNumberView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[docNumTitleLbl]-8-|", options: [], metrics: nil, views: layoutDict))
        docNumberView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[docNumTxtField]-8-|", options: [], metrics: nil, views: layoutDict))
        
        expDateView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[expDateTitleLbl(15)]-8-[expDateTxtField(45)]|", options: [], metrics: nil, views: layoutDict))
        expDateView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[expDateTitleLbl]-8-|", options: [], metrics: nil, views: layoutDict))
        expDateView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[expDateTxtField]-8-|", options: [], metrics: nil, views: layoutDict))
        
        
        issueDateView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[issueDateTitleLbl(15)]-8-[issueDateTxtField(45)]|", options: [], metrics: nil, views: layoutDict))
        issueDateView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[issueDateTitleLbl]-8-|", options: [], metrics: nil, views: layoutDict))
        issueDateView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[issueDateTxtField]-8-|", options: [], metrics: nil, views: layoutDict))
        
    }

}

class DocumentImageCollectionViewCell: UICollectionViewCell {
    
    let viewContent = UIView()
    let docTitleLbl = UILabel()
    let docImgView = UIImageView()
    
    let activityIndicator = UIActivityIndicatorView()
    
    var layoutDict = [String:AnyObject]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupViews()
        
    }
    
    func setupViews() {
        
        contentView.isUserInteractionEnabled = true
        
        
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
        docTitleLbl.textColor = .txtColor
        docTitleLbl.textAlignment = .center
        docTitleLbl.font = UIFont.appRegularFont(ofSize: 14)
        docTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["docTitleLbl"] = docTitleLbl
        viewContent.addSubview(docTitleLbl)
        
       // docImgView.contentMode = .scaleAspectFill
      //  docImgView.backgroundColor = .gray
        docImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["docImgView"] = docImgView
        viewContent.addSubview(docImgView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["activityIndicator"] = activityIndicator
        viewContent.addSubview(activityIndicator)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewContent]|", options: [], metrics: nil, views: layoutDict))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[docTitleLbl(15)]-8-[docImgView(100)]-1-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[docTitleLbl]|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[docImgView]|", options: [], metrics: nil, views: layoutDict))
        
        
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: docImgView.centerXAnchor, constant: 0).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: docImgView.centerYAnchor, constant: 0).isActive = true
        
        
    }
    
}
