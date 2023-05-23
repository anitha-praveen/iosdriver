//
//  SearchLocationGetVC.swift
//  Roda Driver
//
//  Created by NPlus Technologies on 06/05/22.
//

import UIKit
import Alamofire
import CoreLocation
import NVActivityIndicatorView

class SearchLocationGetVC: UIViewController {
    
    let searchLocationView = SearchLocationView()
    
    var searchLocationList: [SearchLocation] = []
    var selectedLocation:((SearchLocation) -> Void)?
    
    var selectedPickupLocation: SearchLocation?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    func setupView() {
        searchLocationView.setupViews(Base: self.view)
        setupTarget()

        searchLocationView.tblLocation.delegate = self
        searchLocationView.tblLocation.dataSource = self
        searchLocationView.tblLocation.register(SearchListTableViewCell.self, forCellReuseIdentifier: "SearchListTableViewCell")
    }
    func setupTarget() {
        searchLocationView.btnClose.addTarget(self, action: #selector(btnClosePressed(_ :)), for: .touchUpInside)
        searchLocationView.txtPickup.addTarget(self, action: #selector(searchPlace(_ :)), for: .editingChanged)
        searchLocationView.txtDrop.addTarget(self, action: #selector(searchPlace(_ :)), for: .editingChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        searchLocationView.viewPickDot.createVerticalDottedLine(width: 3, color: UIColor.txtColor.cgColor)
        searchLocationView.viewDropDot.createVerticalDottedLine(width: 3, color: UIColor.txtColor.cgColor)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        searchLocationView.btnFavourite.isHidden = true

        if self.selectedPickupLocation == nil {
            searchLocationView.viewDrop.isHidden = true
            searchLocationView.viewPickDot.isHidden = true
            searchLocationView.txtPickup.isUserInteractionEnabled = true
            searchLocationView.txtPickup.becomeFirstResponder()
        } else {
            searchLocationView.viewDrop.isHidden = false
            searchLocationView.viewPickDot.isHidden = false
            
            searchLocationView.txtPickup.text = self.selectedPickupLocation?.placeId
            
            searchLocationView.txtPickup.isUserInteractionEnabled = true
            searchLocationView.txtPickup.clearButtonMode = .always
            
            searchLocationView.txtDrop.becomeFirstResponder()
        }
    }
    
}

extension SearchLocationGetVC {
    @objc func btnClosePressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SearchLocationGetVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchLocationList.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchListTableViewCell") as? SearchListTableViewCell ?? SearchListTableViewCell()
        
        cell.placenameLbl.text = searchLocationList[indexPath.row].nickName
        cell.placeaddLbl.text = searchLocationList[indexPath.row].placeId
        cell.favDeleteBtn.isHidden = true
        cell.favDeleteBtnAction = nil
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLocation?(searchLocationList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        viewFooter.backgroundColor = .hexToColor("EDF1F7")
        
        return viewFooter
    }
}
extension SearchLocationGetVC {
    @objc func searchPlace(_ sender: UITextField) {
        guard let searchText = sender.text else {
            return
        }

        if searchText.isEmpty {
            self.searchLocationList = []
            self.searchLocationView.tblLocation.reloadData()
            return
        } else {
            if searchText.count > 3 && searchText.count < 10 && (searchText.count % 2) == 0{
                
                if ConnectionCheck.isConnectedToNetwork() {
                    
                    var paramDict = [String: Any]()
                    paramDict["input"] = searchText
                    paramDict["key"] = APIHelper.shared.gmsPlacesKey
                    if let location = AppLocationManager.shared.locationManager.location?.coordinate {
                        paramDict["location"] = "\(location.latitude),\(location.longitude)"
                    }
                    paramDict["radius"] = "500"
                    
                   // paramDict["components"] = "country:" + "AE"
                    
                    if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                        print("Locale country", countryCode)
                        paramDict["components"] = "country:" + countryCode
                    }
                    
                    
                    let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/place/autocomplete/json", queryItem: [])
                    print("Search Location API",url,paramDict)
                    Alamofire.request(url, method: .get, parameters: paramDict, headers: APIHelper.shared.header)
                        .responseJSON { response in
                            print(response.result.value as Any)
                            if let result = response.result.value as? [String:AnyObject] {
                                if let status = result["status"] as? String, status == "OK" {
                                    if let predictions = result["predictions"] as? [[String:AnyObject]] {
                                        self.searchLocationList = predictions.compactMap({
                                            if let googlePlaceId = $0["place_id"] as? String,
                                               let address = $0["description"] as? String,
                                               let structuredFormat = $0["structured_formatting"] as? [String:AnyObject],
                                               let title = structuredFormat["main_text"] as? String {
                                                return SearchLocation(googlePlaceId,title:title,address: address)
                                            }
                                            return nil
                                        })
                                        DispatchQueue.main.async {
                                            self.searchLocationView.tblLocation.reloadData()
                                        }
                                    }
                                } else if let status = result["status"] as? String {
                                    self.searchLocationList = []
                                    self.searchLocationView.tblLocation.reloadData()
                                    print(status)
                                }
                            }
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        }
                }
            }
        }
    }
}

