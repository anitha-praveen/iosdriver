//
//  ManageDocumentView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit

class ManageDocumentView: UIView {

    let btnBack = UIButton()
   
    let titleLbl = UILabel()
    let noDocLbl = UILabel()
    let tableView = UITableView()
    var btnUploadDoc = UIButton()
    
    var layoutDict = [String:AnyObject]()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        baseView.backgroundColor = .secondaryColor
        
        btnBack.contentMode = .scaleAspectFit
        btnBack.setAppImage("backDark")
        btnBack.layer.cornerRadius = 20
        btnBack.addShadow()
        btnBack.backgroundColor = .secondaryColor
        layoutDict["btnBack"] = btnBack
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnBack)
        
        titleLbl.text = "text_manage_documents".localize()
        titleLbl.textColor = .txtColor
        titleLbl.font = .appSemiBold(ofSize: 25)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["titleLbl"] = titleLbl
        baseView.addSubview(titleLbl)
        
        noDocLbl.text = "text_driver_notUploaded".localize()
        noDocLbl.textColor = .themeTxtColor
        noDocLbl.textAlignment = .center
        noDocLbl.numberOfLines = 0
        noDocLbl.lineBreakMode = .byWordWrapping
        noDocLbl.backgroundColor = .themeColor
        noDocLbl.font = .appRegularFont(ofSize: 19)
        noDocLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["noDocLbl"] = noDocLbl
        baseView.addSubview(noDocLbl)
        
        tableView.alwaysBounceVertical = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["tableView"] = tableView
        baseView.addSubview(tableView)
        
        btnUploadDoc.isHidden = true
        btnUploadDoc.setTitle("text_submit".localize().uppercased(), for: .normal)
        btnUploadDoc.titleLabel?.font = .appSemiBold(ofSize: 18)
        btnUploadDoc.backgroundColor = .themeColor
        btnUploadDoc.setTitleColor(.secondaryColor, for: .normal)
        btnUploadDoc.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnUploadDoc"] = btnUploadDoc
        baseView.addSubview(btnUploadDoc)
        
        btnBack.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        btnUploadDoc.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor,constant: -10).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnBack(40)]-15-[titleLbl(35)]-15-[tableView]-10-[btnUploadDoc(45)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLbl]-15-[noDocLbl(100)]", options: [], metrics: nil, views: layoutDict))
        
       
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[btnBack(40)]", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLbl]-16-|", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[noDocLbl]|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[btnUploadDoc]-20-|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDict))

        
    }

}

// MARK: - Set Cell
class ManageDocumentCell: UITableViewCell {

    let bgView = UIView()
    let docNameLbl = UILabel()
    let requiredFieldLabel = UILabel()
    let expairedLabel = UILabel()
    let addDocBtn = UIButton()
    let attachmentBtn = UIButton()
    var layoutDic = [String:AnyObject]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        
        contentView.isUserInteractionEnabled = true
        
        self.selectionStyle = .none
        
        bgView.isUserInteractionEnabled = true
        bgView.backgroundColor = .secondaryColor
        bgView.layer.cornerRadius = 4.0
        bgView.layer.borderWidth = 1.0
        bgView.layer.borderColor = UIColor.hexToColor("E4E9F2").cgColor
        bgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["bgView"] = bgView
        addSubview(bgView)

        docNameLbl.textColor = .txtColor
        docNameLbl.font = .appSemiBold(ofSize: 15)
        docNameLbl.textAlignment = APIHelper.appTextAlignment
        docNameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["docNameLbl"] = docNameLbl
        bgView.addSubview(docNameLbl)
        
        requiredFieldLabel.isHidden = true
        requiredFieldLabel.text = "*"
        requiredFieldLabel.font = UIFont.systemFont(ofSize: 19)
        requiredFieldLabel.textColor = .red
        requiredFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["requiredFieldLabel"] = requiredFieldLabel
        bgView.addSubview(requiredFieldLabel)
        
        expairedLabel.isHidden = true
        expairedLabel.text = "txt_expired".localize()
        expairedLabel.textAlignment = .center
        expairedLabel.font = UIFont.systemFont(ofSize: 8)
        expairedLabel.textColor = .secondaryColor
        expairedLabel.backgroundColor = .red
        expairedLabel.layer.cornerRadius = 5
        expairedLabel.clipsToBounds = true
        expairedLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["expairedLabel"] = expairedLabel
        bgView.addSubview(expairedLabel)

        addDocBtn.isUserInteractionEnabled = true
        addDocBtn.contentMode = .scaleAspectFit
        addDocBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["addDocBtn"] = addDocBtn
        bgView.addSubview(addDocBtn)
        
        attachmentBtn.isHidden = true
        attachmentBtn.setImage(UIImage(named: "attachment"), for: .normal)
        attachmentBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["attachmentBtn"] = attachmentBtn
        bgView.addSubview(attachmentBtn)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(4)-[bgView]-(4)-|", options: [], metrics: nil, views: layoutDic))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[bgView]-(16)-|", options: [], metrics: nil, views: layoutDic))
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[docNameLbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[attachmentBtn(20)]-(14)-[addDocBtn(22)]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(12)-[docNameLbl(22)]-(12)-|", options: [], metrics: nil, views: layoutDic))
        
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(12)-[attachmentBtn(22)]-(12)-|", options: [], metrics: nil, views: layoutDic))
        
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(12)-[addDocBtn(22)]-(12)-|", options: [], metrics: nil, views: layoutDic))
        
        requiredFieldLabel.bottomAnchor.constraint(equalTo: docNameLbl.topAnchor, constant: 15).isActive = true
        requiredFieldLabel.leadingAnchor.constraint(equalTo: docNameLbl.trailingAnchor).isActive = true
        
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[requiredFieldLabel]-3-[expairedLabel(>=42)]", options: [], metrics: nil, views: layoutDic))
        expairedLabel.centerYAnchor.constraint(equalTo: requiredFieldLabel.centerYAnchor,constant: -4).isActive = true
        expairedLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
    }
    
}
