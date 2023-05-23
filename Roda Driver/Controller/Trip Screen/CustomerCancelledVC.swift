//
//  CustomerCancelledVC.swift
//  Captain Car
//
//  Created by Spextrum on 03/07/19.
//  Copyright © 2019 nPlus. All rights reserved.
//

import UIKit
import AVKit

class AlertVC: UIViewController {
    
    var player:AVAudioPlayer?
    var callBack:(()->Void)?
    var fileName: String?
    let lbl = UILabel()
    let lblHeader = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playSound()
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopSound()
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @objc func appMovedToForeground(_ notification: Notification) {
        playSound()
    }
    
    //MARK: - Adding UI Elements SetupView

    func setupViews() {
        view.backgroundColor = .secondaryColor
        
        let contentView = UIView()
        contentView.backgroundColor = .secondaryColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        lblHeader.textAlignment = .center
        lblHeader.textColor = .txtColor
        lblHeader.text = APIHelper.shared.appName
        lblHeader.font = UIFont.appSemiBold(ofSize: 30)
        lblHeader.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lblHeader)

        lbl.font = UIFont.appFont(ofSize: 20)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .center
        lbl.textColor = .themeColor
        lbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lbl)
        
        let okBtn = UIButton(type: .custom)
        okBtn.layer.cornerRadius = 5
        okBtn.addTarget(self, action: #selector(okBtnAction(_:)), for: .touchUpInside)
        okBtn.setTitleColor(.secondaryColor, for: .normal)
        okBtn.setTitle("text_ok".localize(), for: .normal)
        okBtn.backgroundColor = .themeColor
        okBtn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(okBtn)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[contentView]-(20)-|", options: [], metrics: nil, views: ["contentView":contentView]))
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[lblHeader]-(10)-|", options: [], metrics: nil, views: ["lblHeader":lblHeader]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[lbl]-(10)-|", options: [], metrics: nil, views: ["lbl":lbl]))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[lblHeader]-10-[lbl(>=50)]-(20)-[okBtn(35)]-(10)-|", options: [], metrics: nil, views: ["lbl":lbl,"okBtn":okBtn,"lblHeader":lblHeader]))
        okBtn.widthAnchor.constraint(equalToConstant: 140).isActive = true
        okBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
    }
    
    //MARK: - Ok Button Action

    @objc func okBtnAction(_ sender: UIButton) {
        callBack?()
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: - Playing Sound to call

    func playSound() {
        self.player?.stop()
        self.player = nil
        if let fileName = self.fileName, let path = Bundle.main.path(forResource: fileName, ofType: "mp3") {
            let url = URL(fileURLWithPath:path)
            if let player = try? AVAudioPlayer(contentsOf: url) {
                self.player = player
                self.player?.numberOfLoops = -1
                self.player?.prepareToPlay()
                self.player?.play()
            }
        }
    }
    
    //MARK: - Stop Sound to Call

    func stopSound() {
        self.player?.stop()
        self.player = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
