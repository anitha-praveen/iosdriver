//
//  HistoryVC.swift
//  TapNGo Driver
//
//  Created by Spextrum on 10/11/17.
//  Copyright © 2017 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Kingfisher

class HistoryVC: UIViewController {
    
    let historyView = HistoryView()
    
    var completedPage: Int?
    var completedLastPage: Int?
    var completedList:[HistroyDetail]? = []
    var cancelledPage: Int?
    var cancelledLastPage: Int?
    var cancelledList:[HistroyDetail]? = []

    var histroyDetailList = [HistroyDetail]()

    var histroySelectionType:SelectedHistory = .completed

    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.navigationBar.isHidden = true
        self.setUpViews()
        self.setupTarget()
        self.completedPage = 1
        self.gethistorydetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
// MARK: Adding UI Elements in setupViews
    func setUpViews() {
        historyView.setupViews(Base: self.view)
    }
    
    func setupTarget() {
        historyView.historytbv.delegate = self
        historyView.historytbv.dataSource = self
        historyView.historytbv.register(HistoryTableViewCell.self, forCellReuseIdentifier: "HistoryTableViewCell")

        historyView.segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)

        historyView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
      
    }
}

extension HistoryVC {
    @objc func segmentAction(_ sender: UISegmentedControl) {
        self.histroyDetailList.removeAll()
        self.historyView.historytbv.reloadData()
        if sender.selectedSegmentIndex == 0 {

            self.histroySelectionType = .completed
            if let list = self.completedList, !list.isEmpty {
                self.histroyDetailList = list
                self.historyView.historytbv.reloadData()
                self.historyView.historytbv.isHidden = false
            } else {
                self.completedPage = 1
                self.gethistorydetails()
            }
            
        } else if sender.selectedSegmentIndex == 1 {
            
            self.histroySelectionType = .cancelled
            if let list = self.cancelledList, !list.isEmpty {
                self.histroyDetailList = list
                self.historyView.historytbv.reloadData()
                self.historyView.historytbv.isHidden = false
            } else {
                self.cancelledPage = 1
                self.gethistorydetails()
            }
        }
        
    }
    
    @objc func backBtnAction(_ sender: UIButton){
        self.completedPage = 1
        self.cancelledPage = 1
        self.completedList = nil
        self.cancelledList = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension HistoryVC {
    // MARK: Get History Details
        func gethistorydetails() {
            if ConnectionCheck.isConnectedToNetwork() {
                
                NKActivityLoader.sharedInstance.show()
                var paramDict = Dictionary<String, Any>()
                
                if self.histroySelectionType == .completed {
                    paramDict["trip_type"] = "COMPLETED"
                    paramDict["page"] = self.completedPage
                } else if self.histroySelectionType == .cancelled {
                    paramDict["trip_type"] = "CANCELLED"
                    paramDict["page"] = self.cancelledPage
                }
                paramDict["ride_type"] = "RIDE NOW"
              
                let url = APIHelper.shared.BASEURL + APIHelper.getHistoryList
                print(url,paramDict)
                Alamofire.request(url, method:.post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                    .responseJSON { response in
                        NKActivityLoader.sharedInstance.show()
                        print("HISTORY API",response.result.value as AnyObject)
                        self.isLoading = false

                        if case .failure(let error) = response.result {
                            self.isLoading = false
                            self.noDataAvailable()
                            print(error.localizedDescription)
                        } else if case .success = response.result {
                            
                            if let result = response.result.value as? [String: AnyObject], response.response?.statusCode == 200 {
                                NKActivityLoader.sharedInstance.hide()
                                if let dataList = result["data"] as? [String: AnyObject] {
                                    if let data = dataList["data"] as? [[String: AnyObject]],
                                       let lastPageNumber = dataList["last_page"] as? Int {
                                    
                                        if self.histroySelectionType == .completed {
                                            self.completedLastPage = lastPageNumber
                                            self.completedList?.append(contentsOf: data.compactMap({HistroyDetail($0)}))
                                            if let list = self.completedList {
                                                self.histroyDetailList = list
                                            }
                                        } else if self.histroySelectionType == .cancelled {
                                            self.cancelledLastPage = lastPageNumber
                                            self.cancelledList?.append(contentsOf: data.compactMap({HistroyDetail($0)}))
                                            if let list = self.cancelledList {
                                                self.histroyDetailList = list
                                            }
                                        }
                                    }
                                    if self.histroyDetailList.isEmpty {
                                        
                                        self.noDataAvailable()
                                    } else {
                                        self.historyView.historytbv.reloadData()
                                        self.historyView.lblNoRides.isHidden = true
                                        self.historyView.imgNoRides.isHidden = true
                                        self.historyView.historytbv.isHidden = false
                                    }
                                    
                                }
                            } else {
                                self.noDataAvailable()
                            }
                        }
                    }
               
            } else {
               
                self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
            }
        }
        
    func noDataAvailable() {
       
        self.historyView.imgNoRides.isHidden = false
        self.historyView.lblNoRides.isHidden = false
        
        self.historyView.historytbv.isHidden = true
    }
    }
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.histroyDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell ?? HistoryTableViewCell()
        cell.selectionStyle = .none

        if let name = self.histroyDetailList[indexPath.row].userDetails?.userFirstName {
            cell.nameLbl.text = name
        } else {
            cell.nameLbl.text = self.histroyDetailList[indexPath.row].instantPhoneNumber
        }
        
        cell.tripreqidlbl.text = self.histroyDetailList[indexPath.row].requestId
        cell.fromaddrlbl.text = self.histroyDetailList[indexPath.row].pickLocation
        
        if let dropLoc = histroyDetailList[indexPath.row].dropLocation {
            cell.toaddrlbl.text = dropLoc
        } else {
            cell.toaddrlbl.text = "---"
        }

        if let currency = self.histroyDetailList[indexPath.row].requestBill?.currency, let total = self.histroyDetailList[indexPath.row].requestBill?.total {
            cell.tripcostlbl.text = currency + " " + total
        }
        


            if let imgStr = histroyDetailList[indexPath.row].userDetails?.userProfilePicUrlStr, let url = URL(string: imgStr) {
                cell.driverimageIv.kf.indicatorType = .activity
                let resource = ImageResource(downloadURL: url)
                cell.driverimageIv.kf.setImage(with: resource, placeholder: UIImage(named: "profilePlaceHolder"), options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                cell.driverimageIv.image = UIImage(named: "profilePlaceHolder")
            }
            
            
// Using S3
//        if let imgStr = histroyDetailList[indexPath.row].userDetails?.userProfilePicUrlStr {
//            self.retriveImgFromBucket(key: imgStr) { image in
//                cell.driverimageIv.image = image
//            }
//        } else {
//            cell.driverimageIv.image = UIImage(named: "historyProfilePlaceholder")
//        }
        
    
        if let serviceType = self.histroyDetailList[indexPath.row].serviceCatagory {
            cell.lblRideType.text = serviceType
        }
        
        if self.histroyDetailList[indexPath.row].isCancelled {
            cell.btnDispute.isHidden = true
            cell.viewDate.backgroundColor = .hexToColor("#E76565")
            cell.tripcostlbl.isHidden = true
            
            if let reason = self.histroyDetailList[indexPath.row].cancelReason {
                cell.viewCancelReason.isHidden = false
                cell.lblCancelReason.text = reason
            } else {
                cell.viewCancelReason.isHidden = true
            }
            if let cancelBy = self.histroyDetailList[indexPath.row].cancelBy {
                cell.lblDate.text = "txt_cancelled_by".localize() + " " + cancelBy
                cell.lblTime.text = ""
            }
            
        } else {
            cell.tripcostlbl.isHidden = false
            cell.viewCancelReason.isHidden = true
            cell.viewDate.backgroundColor = .hexToColor("#48CB90")
            if self.histroyDetailList[indexPath.row].enableDispute ?? false {
                cell.btnDispute.isHidden = false
                cell.disputeAction = {[weak self] in
                    self?.moveToDispute(self?.histroyDetailList[indexPath.row].id ?? "")
                }
            } else {
                cell.btnDispute.isHidden = true
            }
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            
            if let date = dateFormatter.date(from: self.histroyDetailList[indexPath.row].tripStartTime ?? "") {
                dateFormatter.dateFormat = "MMM dd, yyyy"
                cell.lblDate.text = dateFormatter.string(from: date)
                dateFormatter.dateFormat = "hh:mm a"
                cell.lblTime.text = dateFormatter.string(from: date)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.histroyDetailList[indexPath.row].isCompleted {
            let historyDetailsVC = HistoryDetailsVC()
            historyDetailsVC.rideHistory = self.histroyDetailList[indexPath.row]

            self.navigationController?.pushViewController(historyDetailsVC, animated: true)
        }
    }
    
    func moveToDispute(_ id: String) {
        let complaintsVC = ComplaintsVC()
        complaintsVC.historyRequestId = id
        self.navigationController?.pushViewController(complaintsVC, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollValue = scrollView.contentOffset.y
        if scrollValue > (self.historyView.historytbv.contentSize.height - 100 - scrollView.frame.size.height) {
            if self.histroySelectionType == .completed {
                if self.completedPage ?? 0 < self.completedLastPage ?? 0 && !isLoading {
                    if var page = self.completedPage {
                        
                        page += 1
                        self.completedPage = page
                        self.gethistorydetails()
                    }
                }
            } else if self.histroySelectionType == .cancelled {
                if self.cancelledPage ?? 0 < self.cancelledLastPage ?? 0 && !isLoading {
                    if var page = self.cancelledPage {
                        page += 1
                        self.cancelledPage = page
                        self.gethistorydetails()
                    }
                }
            }
        }
    }
    
}
