//
//  SearchLocationView.swift
//  Roda Driver
//
//  Created by NPlus Technologies on 06/05/22.
//

import UIKit

class SearchLocationView: UIView {
    
    let viewTop = UIView()
    let btnClose = UIButton()
    let btnFavourite = UIButton()
    let stackview = UIStackView()
    
    let viewPickup = UIView()
    let viewPickColor = UIView()
    let viewPickDot = UIView()
    let txtPickup = UITextField()
    
    let viewDrop = UIView()
    let viewDropColor = UIView()
    let viewDropDot = UIView()
    let txtDrop = UITextField()
    let line = UIView()
        
    let tblLocation = UITableView()
    
    var layoutDict = [String: AnyObject]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    func setupViews(Base baseView: UIView) {
        baseView.backgroundColor = .secondaryColor
        
//        viewTop.addShadow()
//        viewTop.layer.cornerRadius = 20
        viewTop.backgroundColor = .secondaryColor
        layoutDict["viewTop"] = viewTop
        viewTop.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewTop)
        
        btnClose.setImage(UIImage(named: "ic_close"), for: .normal)
        layoutDict["btnClose"] = btnClose
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        self.viewTop.addSubview(btnClose)
        
        btnFavourite.setImage(UIImage(named: "ic_unfav"), for: .normal)
        layoutDict["btnFavourite"] = btnFavourite
        btnFavourite.translatesAutoresizingMaskIntoConstraints = false
        self.viewTop.addSubview(btnFavourite)
        
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.spacing = 10
        layoutDict["stackview"] = stackview
        stackview.translatesAutoresizingMaskIntoConstraints = false
        self.viewTop.addSubview(stackview)
        
        viewPickup.layer.cornerRadius = 8
        viewPickup.addShadow()
        viewPickup.backgroundColor = .secondaryColor
        layoutDict["viewPickup"] = viewPickup
        viewPickup.translatesAutoresizingMaskIntoConstraints = false
        stackview.addArrangedSubview(viewPickup)
        
        viewPickColor.layer.cornerRadius = 5
        viewPickColor.backgroundColor = .txtColor
        layoutDict["viewPickColor"] = viewPickColor
        viewPickColor.translatesAutoresizingMaskIntoConstraints = false
        self.viewPickup.addSubview(viewPickColor)
        
        layoutDict["viewPickDot"] = viewPickDot
        viewPickDot.translatesAutoresizingMaskIntoConstraints = false
        self.viewPickup.addSubview(viewPickDot)
        
        txtPickup.textAlignment = APIHelper.appTextAlignment
        txtPickup.textColor = .txtColor
        txtPickup.font = UIFont.appRegularFont(ofSize: 18)
        layoutDict["txtPickup"] = txtPickup
        txtPickup.translatesAutoresizingMaskIntoConstraints = false
        self.viewPickup.addSubview(txtPickup)
        
        viewDrop.layer.cornerRadius = 8
        viewDrop.addShadow()
        viewDrop.backgroundColor = .secondaryColor
        layoutDict["viewDrop"] = viewDrop
        viewDrop.translatesAutoresizingMaskIntoConstraints = false
        stackview.addArrangedSubview(viewDrop)
        
        viewDropColor.backgroundColor = .themeColor
        layoutDict["viewDropColor"] = viewDropColor
        viewDropColor.translatesAutoresizingMaskIntoConstraints = false
        self.viewDrop.addSubview(viewDropColor)
        
        layoutDict["viewDropDot"] = viewDropDot
        viewDropDot.translatesAutoresizingMaskIntoConstraints = false
        self.viewDrop.addSubview(viewDropDot)
        
        txtDrop.textAlignment = APIHelper.appTextAlignment
        txtDrop.placeholder = "txt_destination".localize()
        txtDrop.textColor = .txtColor
        txtDrop.font = UIFont.appRegularFont(ofSize: 18)
        layoutDict["txtDrop"] = txtDrop
        txtDrop.translatesAutoresizingMaskIntoConstraints = false
        self.viewDrop.addSubview(txtDrop)
        
        
        line.backgroundColor = .hexToColor("D8D8D8")
        layoutDict["line"] = line
        line.translatesAutoresizingMaskIntoConstraints = false
        self.viewDrop.addSubview(line)
        
        
        tblLocation.backgroundColor = .secondaryColor
        layoutDict["tblLocation"] = tblLocation
        tblLocation.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tblLocation)
        
        
        viewTop.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tblLocation.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewTop]-10-[tblLocation]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewTop]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        self.viewTop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[btnClose(30)]-20-[stackview]-20-|", options: [], metrics: nil, views: layoutDict))
        self.viewTop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[btnFavourite(30)]", options: [], metrics: nil, views: layoutDict))
        
        self.viewTop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnClose(30)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.viewTop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnFavourite(30)]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.viewTop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackview]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        self.viewPickup.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[viewPickColor(10)]-16-[txtPickup]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        self.viewPickup.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[txtPickup(30)]-10-|", options: [], metrics: nil, views: layoutDict))
        viewPickColor.topAnchor.constraint(equalTo: txtPickup.centerYAnchor, constant: -5).isActive = true
        self.viewPickup.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPickColor(10)][viewPickDot]|", options: [], metrics: nil, views: layoutDict))
        viewPickDot.centerXAnchor.constraint(equalTo: viewPickColor.centerXAnchor, constant: 0).isActive = true
        viewPickDot.widthAnchor.constraint(equalToConstant: 6).isActive = true
        
        
        self.viewDrop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[viewDropColor(10)]-16-[txtDrop]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        self.viewDrop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(1)]-10-[txtDrop(30)]-5-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        viewDropColor.bottomAnchor.constraint(equalTo: txtDrop.centerYAnchor, constant: 5).isActive = true
        self.viewDrop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewDropDot][viewDropColor(10)]", options: [], metrics: nil, views: layoutDict))
        viewDropDot.centerXAnchor.constraint(equalTo: viewDropColor.centerXAnchor, constant: 0).isActive = true
        viewDropDot.widthAnchor.constraint(equalToConstant: 6).isActive = true
        
    }
}
class SearchListTableViewCell: UITableViewCell {
    
    var layoutDic = [String:AnyObject]()
    var placenameLbl = UILabel()
    var placeImv = UIImageView()
    var placeaddLbl = UILabel()
    var favDeleteBtn = UIButton()
    var favDeleteBtnAction:(()->Void)?

  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpViews() { // adding ui elements to superview
        
        self.backgroundColor = .secondaryColor
        
        placenameLbl.textColor = .txtColor
        placeaddLbl.textColor = .txtColor
        
        selectionStyle = .none
        placenameLbl.textAlignment = APIHelper.appTextAlignment
        placenameLbl.font = UIFont.appRegularFont(ofSize: 18)
        placeaddLbl.textAlignment = APIHelper.appTextAlignment
        placeaddLbl.font = UIFont.appRegularFont(ofSize: 14)
        placenameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["placenameLbl"] = placenameLbl
        addSubview(placenameLbl)
        
        placeImv.contentMode = .scaleAspectFill
        placeImv.image = UIImage(named: "ic_destination_pin")
        placeImv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["placeImv"] = placeImv
        addSubview(placeImv)
        
        placeaddLbl.translatesAutoresizingMaskIntoConstraints = false
        placeaddLbl.numberOfLines = 0
        placeaddLbl.lineBreakMode = .byWordWrapping
        layoutDic["placeaddLbl"] = placeaddLbl
        addSubview(placeaddLbl)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[placeImv(22)]-(15)-[placenameLbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        placeImv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        placeImv.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[placenameLbl(21)]-(3)-[placeaddLbl(>=15)]-(5)-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
    }
}

