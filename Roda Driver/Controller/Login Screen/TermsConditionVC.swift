//
//  TermsConditionVC.swift
//  Taxiappz Driver
//
//  Created by spextrum on 20/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import WebKit

class TermsConditionVC: UIViewController {
    
    private let termsView = TermsConditionView()
    
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
        termsView.setupViews(Base: self.view)
        
        termsView.wkWebView.navigationDelegate = self
        
        termsView.indicatorView.startAnimating()
        termsView.btnBack.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
    }
    
    func setupData() {
        if let url = URL(string: "") {
            termsView.wkWebView.load(URLRequest(url: url))
        }
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension TermsConditionVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        termsView.indicatorView.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        termsView.indicatorView.stopAnimating()
    }
    
}
