//
//  InstantTripVC.swift
//  Roda Driver
//
//  Created by NPlus Technologies on 06/05/22.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces
import NVActivityIndicatorView

class InstantTripVC: UIViewController {
    
    let instantTripView = InstantTripView()
    
    var selectedPickUpLocation:SearchLocation?
    var selectedDropLocation:SearchLocation?
    var dropLocationSelectedClousure:((SearchLocation) -> Void)?
        
    var isMapDragged = false
    var isAddressSearched = false
    
    var typeID = ""
    var animatedPolyline:AnimatedPolyLine?
    
    var polyLineString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .secondaryColor
        setupViews()
        setupTarget()
        setupData()
        currentLocation()
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupViews() {
        instantTripView.setupViews(Base: self.view)
    }
    
    func setupTarget() {
        instantTripView.mapview.delegate = self
        instantTripView.btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        instantTripView.dropView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dropTapped(_:))))
        instantTripView.btnSateliteMapType.addTarget(self, action: #selector(sateliteNormalBtnAction(_ :)), for: .touchUpInside)
        instantTripView.btnNormalMapType.addTarget(self, action: #selector(sateliteNormalBtnAction(_ :)), for: .touchUpInside)
        instantTripView.btnStartTrip.addTarget(self, action: #selector(btnStartTripPressed(_ :)), for: .touchUpInside)
        instantTripView.currentLocationBtn.addTarget(self, action: #selector(currentLocationPressed(_ :)), for: .touchUpInside)
    }
    
    func setupData() {
        if APIHelper.satelitemaptype == true {
            instantTripView.mapview.mapType = .satellite
            instantTripView.btnSateliteMapType.isHidden = true
            instantTripView.btnNormalMapType.isHidden = false
        } else {
            instantTripView.mapview.mapType = .normal
            instantTripView.btnSateliteMapType.isHidden = false
            instantTripView.btnNormalMapType.isHidden = true
        }
        
        instantTripView.dropView.backgroundColor = .hexToColor("F3F3F3")
        instantTripView.dropView.addShadow()
        instantTripView.markerImageView.image = UIImage(named: "droppin")
        
        
    }
    
    func currentLocation() {
        guard let location = AppLocationManager.shared.locationManager.location else {
            return
        }
        self.selectedPickUpLocation = SearchLocation(location.coordinate)
        
        let coord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.getaddress(coord) { address in				
            self.selectedPickUpLocation?.placeId = address
            self.instantTripView.txtPickup.text = self.selectedPickUpLocation?.placeId
        }
        instantTripView.mapview.camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 18)
    }
    
    
}


extension InstantTripVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.isMapDragged = gesture
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if self.isMapDragged && !self.isAddressSearched {
            
            self.selectedDropLocation = SearchLocation(position.target)
            
            self.getaddress(position.target) { address in
                self.selectedDropLocation?.placeId = address
                self.instantTripView.txtDrop.text = self.selectedDropLocation?.placeId
            }
        } else {
            self.isAddressSearched = false
        }
    }
}
 
extension InstantTripVC {
    
    @objc func currentLocationPressed(_ sender: UIButton) {
        guard let location = AppLocationManager.shared.locationManager.location else {
            return
        }
        let coord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.getaddress(coord) { address in
            self.selectedDropLocation?.placeId = address
            self.instantTripView.txtDrop.text = self.selectedPickUpLocation?.placeId
        }
        instantTripView.mapview.camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 18)
    }
    
    @objc func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func sateliteNormalBtnAction(_ sender: UIButton) {
        
        if sender == instantTripView.btnSateliteMapType {
            instantTripView.mapview.mapType = .satellite
            instantTripView.btnSateliteMapType.isHidden = true
            instantTripView.btnNormalMapType.isHidden = false
            APIHelper.satelitemaptype = true
        } else {
            instantTripView.mapview.mapType = .normal
            instantTripView.btnSateliteMapType.isHidden = false
            instantTripView.btnNormalMapType.isHidden = true
            APIHelper.satelitemaptype = false
        }
    }
    
    @objc func dropTapped(_ sender: UITapGestureRecognizer) {

        let vc = SearchLocationGetVC()
        vc.searchLocationView.txtPickup.placeholder = "txt_EnterDrop".localize()
        vc.selectedLocation = { [unowned self] selectedSearchLoc in
            self.instantTripView.txtDrop.text = selectedSearchLoc.placeId
            self.selectedDropLocation = selectedSearchLoc

            if let googlePlaceId = selectedSearchLoc.googlePlaceId {
                self.getCoordinates(selectedSearchLoc.placeId, placeId: googlePlaceId) { location in
                    self.selectedDropLocation?.latitude = location.latitude
                    self.selectedDropLocation?.longitude = location.longitude
                    self.isAddressSearched = true
                    self.instantTripView.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                }
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension InstantTripVC {
    // MARK: - Start Trip Validate and call the API Action
    @objc func btnStartTripPressed(_ sender: UIButton) {
        if self.selectedPickUpLocation?.placeId?.isEmpty == true {
            self.showAlert("txt_EnterPick".localize())
        } else {
            let vc = GetPassengerPhoneVC()
            vc.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
            vc.callBack = {[unowned self] phoneNumber in
                print(phoneNumber)
                self.createRequest(PhoneNum: phoneNumber)
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func createRequest(PhoneNum: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            var paramDict = Dictionary<String, Any>()
            
            paramDict["pick_lat"] = self.selectedPickUpLocation?.latitude
            paramDict["pick_lng"] = self.selectedPickUpLocation?.longitude
            paramDict["pick_address"] = self.selectedPickUpLocation?.placeId
            if self.selectedDropLocation != nil {
                paramDict["drop_lat"] = self.selectedDropLocation?.latitude
                paramDict["drop_lng"] = self.selectedDropLocation?.longitude
                paramDict["drop_address"] = self.selectedDropLocation?.placeId
            }
            paramDict["is_instant"] = true
            paramDict["phone_number"] = PhoneNum

            paramDict["vehicle_type"] = self.typeID
            paramDict["payment_opt"] = "CASH"
            paramDict["ride_type"] = "LOCAL"
            
            if self.polyLineString != nil {
                paramDict["poly_string"] = self.polyLineString
            }
            
            let url = APIHelper.shared.BASEURL + APIHelper.createRequest
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print("INSTANT TRIP RESPONSE",response.result.value as Any, response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if response.response?.statusCode == 200 {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let requestData = data["data"] as? [String: AnyObject] {
                                
                                if let isDriverStarted = requestData["is_driver_started"] as? Bool, isDriverStarted {
                                    LocalDB.shared.currentTripDetail = TripDetail(tripDetails: requestData)
                                    MySocketManager.shared.stopSingleTripEmitTimer()
                                    MySocketManager.shared.startSingleTripLocation()
                                    MySocketManager.shared.currentEmitType = .none
                                    let vc = TripVC()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                    } else {
                        if let error = result["data"] as? [String:[String]] {
                            let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                            self.showAlert("", message: errMsg)
                        } else if let errMsg = result["error_message"] as? String {
                            self.showAlert("", message: errMsg)
                        } else if let msg = result["message"] as? String {
                            self.showAlert("", message: msg)
                        }
                     }
                }
            }
        } else {
            self.showAlert("", message: "txt_NoInternet_title".localize())
        }
    }
    
}


