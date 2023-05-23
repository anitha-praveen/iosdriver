//
//  PrivacyPolicyVC.swift
//  Taxiappz Driver
//
//  Created by spextrum on 20/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController {
    
    private let privacyView = PrivacyPolicyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupViews() {
        privacyView.setupViews(Base: self.view)
        privacyView.wkWebView.navigationDelegate = self
        
        privacyView.indicatorView.startAnimating()
        privacyView.btnBack.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
    }
    
    func setupData() {
        
        if let url = URL(string: "") {
            privacyView.wkWebView.load(URLRequest(url: url))
        }
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension PrivacyPolicyVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        privacyView.indicatorView.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        privacyView.indicatorView.stopAnimating()
    }
    
}
