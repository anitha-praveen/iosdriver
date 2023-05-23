//
//  TripDetialsVC.swift
//  Roda Driver
//
//  Created by NPlus Technologies on 16/05/22.
//

import UIKit
import GoogleMaps
import NVActivityIndicatorView
import Alamofire
import HCSStarRatingView
import Kingfisher

class TripDetialsVC: UIViewController {
    
    let tripDetailView = TripDetialsView()
    
    var totalFare = String()
    var adminComissionString = String()
    
    var currency = ""
    
    typealias InvoiceContent = (key:String,value:String, textColor:UIColor)
    var invoiceContents = [InvoiceContent]()
    
    var rideHistory: HistroyDetail?
    
    var selectedRequestId = String()
    
    var scrolltotop = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripDetailView.scrollview.backgroundColor = .clear
        
        setupViews()
        setupTarget()
        //setupData()
        //setupInvoiceData()
        singleHistoryApi(reqID: selectedRequestId)
        //setupmap()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tripDetailView.tableHeight?.constant = self.tripDetailView.listBgView.contentSize.height
    }
    
    func setupViews() {
        tripDetailView.setupViews(Base: self.view)
      
        self.tripDetailView.userprofilepicture.image = UIImage(named: "historyProfilePlaceholder")
        self.tripDetailView.ratingLbl.text =  ""
        self.tripDetailView.rating.isHidden = true
    }
    
    func setupTarget() {
        //     tripDetailView.mapview.delegate = self
        tripDetailView.listBgView.delegate = self
        tripDetailView.listBgView.dataSource = self
        tripDetailView.listBgView.register(InvoiceCell.self, forCellReuseIdentifier: "InvoiceCell")
        tripDetailView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        tripDetailView.disputeBtn.addTarget(self, action: #selector(disputeBtnAction(_:)), for: .touchUpInside)
    }
    

    func setupTripData(_ tripDataDict: [String:AnyObject] ) {
        
        if let data = tripDataDict["data"] as? [String:AnyObject] {
            if let tripData = data["data"] as? [String:AnyObject] {
                
                if let userData = tripData["user"] as? [String:AnyObject] {
                    if let firstName = userData["firstname"] as? String {
                        self.tripDetailView.usernamelbl.text = firstName
                    }
                    
                    if let imgStr = userData["profile_pic"] as? String, let url = URL(string: imgStr) {
                        self.tripDetailView.userprofilepicture.kf.indicatorType = .activity
                        let resource = ImageResource(downloadURL: url)
                        self.tripDetailView.userprofilepicture.kf.setImage(with: resource, placeholder: UIImage(named: "historyProfilePlaceholder"), options: nil, progressBlock: nil, completionHandler: nil)
                        self.tripDetailView.userprofilepicture.contentMode = .scaleToFill
                    } else {
                        self.tripDetailView.userprofilepicture.image = UIImage(named: "historyProfilePlaceholder")
                    }
                    
                    
// Using S3
//                    if let profilePictureUrl = userData["profile_pic"] as? String {
//                        //    self.onlineOfflineView.activityIndicator.startAnimating()
//                        self.tripDetailView.userprofilepicture.image = UIImage(named: "historyProfilePlaceholder")
//                        self.retriveImg(key: profilePictureUrl) { data in
//                            print("IMAGE DATA",data)
//                            self.tripDetailView.userprofilepicture.image = UIImage(data: data)
//                            self.tripDetailView.userprofilepicture.contentMode = .scaleToFill
//                            //       self.onlineOfflineView.activityIndicator.stopAnimating()
//                        }
//                    } else {
//                        self.tripDetailView.userprofilepicture.image = UIImage(named: "historyProfilePlaceholder")
//                    }
                    
                    self.tripDetailView.userprofilepicture.layer.masksToBounds = true
                    self.tripDetailView.userprofilepicture.layer.cornerRadius = self.tripDetailView.userprofilepicture.layer.frame.width/2
                    
                }
                self.tripDetailView.disputeBtn.isHidden = true
                
                if let rating = tripData["user_overall_rating"] {
                    self.tripDetailView.rating.isHidden = false
                    print(rating)
                    let ratingString = "\(rating)"
                    let ratings = Double(ratingString)
                    self.tripDetailView.ratingLbl.text =  String(format: "%.2f", ratings as! CVarArg)
                }
                
                if let currency = tripData["requested_currency_symbol"] {
                    self.currency = "\(currency)"
                }
                
                if let requestId = tripData["request_number"] as? String {
                    self.tripDetailView.requestId.text = requestId.uppercased()
                }
                
                if let typeName = tripData["vehicle_name"] as? String {
                    self.tripDetailView.carLbl.text = typeName.uppercased()
                }
                
                if let time = tripData["trip_start_time"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    if let date = dateFormatter.date(from: time) {
                        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                        tripDetailView.dateTimeLbl.text = dateFormatter.string(from: date)
                    }
                }
                
                if let pickLocation = tripData["pick_address"] as? String {
                    self.tripDetailView.pickupaddrlbl.text = pickLocation
                }
                
                if let dropLocation = tripData["drop_address"] as? String {
                    self.tripDetailView.dropupaddrlbl.text = dropLocation
                }
                
                if let cancelled = tripData["is_cancelled"] as? Bool, cancelled == false {
                    // MARK: distance
                    if let distance = tripData["total_distance"] , let unitWord = tripData["unit"] {
                        self.tripDetailView.distancelbl.text = String("\(distance)") + " " + "\(unitWord)"
                    }
                    // MARK: Pay options
                    if let paymenttype = tripData["payment_opt"] as? String {
                        self.tripDetailView.paymenttypeLbl.text = paymenttype
                    }
                }
                if let billData = tripData["requestBill"] as? [String:AnyObject] {
                    
                    if let billDict = billData["data"] as? [String:AnyObject] {
                        if let totalAmt = billDict["total_amount"] {
                            self.tripDetailView.paymentamtlbl.text = self.currency + " " + "\(totalAmt)"
                            self.totalFare = "\(totalAmt)"
                        }
                        
                        if let adminComission = billDict["admin_commision"] {
                            adminComissionString = "\(adminComission)"
                        }
                        
                        
                        if let basePrice = billDict["base_price"] {
                            invoiceContents.append((key:"text_base_price".localize(),
                                                    value: self.currency + " " + "\(basePrice)" , textColor:UIColor.darkGray))
                        }
                        
                        if let distancePrice = billDict["distance_price"]  {
                            invoiceContents.append((key:"text_distance_cost".localize(),
                                                    value: self.currency + " " + String(format:"%.2f", "\(distancePrice)"), textColor:UIColor.darkGray))
                        }
                        
                        if let timePrice = billDict["time_price"] {
                            invoiceContents.append((key:"text_time_cost".localize(),
                                                    value: self.currency + " " + "\(timePrice)", textColor:UIColor.darkGray))
                        }
                        
                        if let cancellationFeeStr = billDict["cancellation_fee"] , let cancellationFee = Double("\(cancellationFeeStr)"), cancellationFee > 0 {
                            if  let total = tripData["total_amount"] {
                                let totVal = Double("\(total)")
                                let val = totVal ?? 0 - cancellationFee
                                invoiceContents.append((key:"text_total_feeCost".localize(),
                                                        value:currency + " " +  String(format:"%.2f",val) + " +", textColor:UIColor.txtColor))
                            }
                            invoiceContents.append((key:"text_cancellation_fee".localize(),
                                                    value:currency + " " +  ("\(cancellationFeeStr)"), textColor:UIColor.darkGreen))
                        }
                        
                        if let waitingPrice = tripData["waiting_charge"] {
                            invoiceContents.append((key:"waiting_time_price".localize(),
                                                    value: self.currency + " " + "\(waitingPrice)", textColor:UIColor.darkGray))
                        }
                        if let promoAmount = billDict["promo_discount"] {
                            invoiceContents.append((key:"text_promo_bonus".localize(),
                                                    value: "- \(self.currency) " + "\(promoAmount)", textColor:UIColor.red))
                        }
                        self.tripDetailView.listBgView.reloadData()
                        
                    }
                    
                }
                
            }
        }
        
    }
}

extension TripDetialsVC {
    
    func singleHistoryApi(reqID: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            var paramDict = Dictionary<String, Any>()
            paramDict["request_id"] = reqID
            
            let url = APIHelper.shared.BASEURL + APIHelper.singleHistory
            print("SINGLE HISTORY API & PARAMS",url,paramDict)
            
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { response in
                print("SINGLE HISTORY API RESPONSE",response.result.value)
                NKActivityLoader.sharedInstance.hide()
                if let result = response.result.value as? [String: AnyObject] {
                    if response.response?.statusCode == 200 {
                        print("SUCCESS")
                        self.setupTripData(result)
                    }
                }
            }
        } else {
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
   
}
extension TripDetialsVC {
    
// MARK:  Dispute Action
    @objc func disputeBtnAction(_ sender: UIButton) {
        let complaintsVC = ComplaintsVC()
        complaintsVC.historyRequestId = self.rideHistory?.requestId ?? ""
        self.navigationController?.pushViewController(complaintsVC, animated: true)
    }
    
    @objc func backBtnAction(_ sender: UIButton) {
        self.rideHistory = nil
        self.navigationController?.popViewController(animated: true)
    }
}



extension TripDetialsVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceContents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell") as? InvoiceCell ?? InvoiceCell()
        cell.selectionStyle = .none
        
        cell.keyLbl.text = invoiceContents[indexPath.row].key
        cell.valueLbl.text = invoiceContents[indexPath.row].value
        cell.keyLbl.textColor = invoiceContents[indexPath.row].textColor
        cell.valueLbl.textColor = invoiceContents[indexPath.row].textColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 101
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = UIView()
        footer.backgroundColor = .clear
        
        var layoutDict = [String: AnyObject]()
        
        let invoiceLineView2 = UIView()
        invoiceLineView2.backgroundColor = UIColor.hexToColor("E4E9F2")
        invoiceLineView2.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["invoiceLineView2"] = invoiceLineView2
        footer.addSubview(invoiceLineView2)
        
        let cuttedlineIv = UIImageView()
        cuttedlineIv.image = UIImage(named:"Zig_zag")
        cuttedlineIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["cuttedlineIv"] = cuttedlineIv
        footer.addSubview(cuttedlineIv)
        
        let bgView = UIView()
        bgView.backgroundColor = .secondaryColor
        bgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["bgView"] = bgView
        footer.addSubview(bgView)
        
        let totheaderlbl = UILabel()
        totheaderlbl.text = "txt_Total".localize()
        totheaderlbl.textAlignment = APIHelper.appTextAlignment
        totheaderlbl.font = UIFont.appSemiBold(ofSize: 20)
        totheaderlbl.textColor = .txtColor
        totheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totheaderlbl"] = totheaderlbl
        bgView.addSubview(totheaderlbl)
        
        let totLbl = UILabel()
         
        self.tripDetailView.totalamtlbl.text = self.currency + " " + totalFare + " /"
        self.tripDetailView.paymentamtlbl.text = self.currency + " " + totalFare
        totLbl.text = self.currency + " " + totalFare

        totLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        totLbl.font = UIFont.appSemiBold(ofSize: 20)
        totLbl.textColor = .txtColor
        totLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totLbl"] = totLbl
        bgView.addSubview(totLbl)
        
        let adminTitleLbl = UILabel()
        adminTitleLbl.numberOfLines = 0
        adminTitleLbl.lineBreakMode = .byWordWrapping
        adminTitleLbl.textColor = .themeColor
        adminTitleLbl.text = "admin_commission".localize()
        adminTitleLbl.textAlignment = APIHelper.appTextAlignment
        adminTitleLbl.font = UIFont.appRegularFont(ofSize: 14)
        adminTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["adminTitleLbl"] = adminTitleLbl
        bgView.addSubview(adminTitleLbl)
        
        let adminLbl = UILabel()
        adminLbl.textColor = .themeColor
        adminLbl.text = self.currency + " " + adminComissionString
        adminLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        adminLbl.font = UIFont.appRegularFont(ofSize: 15)
        adminLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["adminLbl"] = adminLbl
        bgView.addSubview(adminLbl)
        
       

        
        footer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[invoiceLineView2(1)]-(0)-[bgView(85)]-(0)-[cuttedlineIv(10)]|", options: [APIHelper.appLanguageDirection,.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        footer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceLineView2]-(15)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        footer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bgView]-(0)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[totheaderlbl(25)]-(15)-[adminTitleLbl(20)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[totheaderlbl]-(10)-[totLbl]-(15)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        totheaderlbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[adminTitleLbl]-(10)-[adminLbl]-(15)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        adminTitleLbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
       
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}

// MARK: CancelDetails Deledates
extension TripDetialsVC: CancelDetailsViewDelegate {
    func tripCancelled(_ msg: String) {
        self.navigationController?.showToast(msg)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
