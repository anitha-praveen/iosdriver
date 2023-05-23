//
//  ConfirmChangeLocationVC.swift
//  Taxiappz Driver
//
//  Created by Apple on 10/03/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import AVKit
import GoogleMaps
import CoreLocation
class ConfirmChangeLocationVC: UIViewController {

    let confirmationView = ConfirmChangedLocationView()
    
    var locationId: String?
    var locationAddress:String?
    var locationChangedTime: String?
    
    var locationCoord:CLLocationCoordinate2D?
    
    var polyPoints: String?
    
    var player:AVAudioPlayer?
    
    var callBack:((Bool) ->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        if locationCoord != nil {
            if let lat = LocalDB.shared.currentTripDetail?.pickLatitude, let lng = LocalDB.shared.currentTripDetail?.pickLongitude, let stopLat = LocalDB.shared.currentTripDetail?.reqestStopLat, let stopLong = LocalDB.shared.currentTripDetail?.reqestStopLong {
                
                self.getPolylineRouteWithWaypoint(from: CLLocationCoordinate2D(latitude: lat, longitude: lng), to: locationCoord ?? CLLocationCoordinate2D(), points: [CLLocationCoordinate2D(latitude: stopLat, longitude: stopLong)])
                
            } else {
                
                
                if let lat = LocalDB.shared.currentTripDetail?.pickLatitude, let lng = LocalDB.shared.currentTripDetail?.pickLongitude {
                    self.getPolylineRoute(from: CLLocationCoordinate2D(latitude: lat, longitude: lng), to: locationCoord!)
                }
            }
            
            
        }
        
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
    func setupViews() {
        confirmationView.setupViews(Base: self.view)
        confirmationView.lblAddress.text = self.locationAddress
        
        confirmationView.btnConfirm.addTarget(self, action: #selector(confirmPressed(_ :)), for: .touchUpInside)
        confirmationView.btnCancel.addTarget(self, action: #selector(cancelPressed(_ :)), for: .touchUpInside)
    }

    @objc func confirmPressed(_ sender: UIButton) {
        confirmLocationChange("1")
    }
    @objc func cancelPressed(_ sender: UIButton) {
        confirmLocationChange("0")
    }
    func playSound() {
        self.player?.stop()
        self.player = nil
        if let path = Bundle.main.path(forResource: "dropchanged", ofType: "mp3") {
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
}

//MARK:- API'S
extension ConfirmChangeLocationVC {
    
    func confirmLocationChange(_ status: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            guard let myLocation = AppLocationManager.shared.locationManager.location else {
                self.showAlert("text_Alert".localize(), message: "txt_location_not_found".localize())
                return
            }
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityPulseData,nil)
            let coord = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
            self.getaddress(coord, completion: { address in
                
                var paramdict = Dictionary<String, Any>()
                
                paramdict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
                paramdict["latitude"] = myLocation.coordinate.latitude
                paramdict["longitude"] = myLocation.coordinate.longitude
                paramdict["address"] = address
                paramdict["location_id"] = self.locationId
                paramdict["status"] = status
                if let polyString = self.polyPoints {
                    paramdict["poly_string"] = polyString
                }
               
                let url = APIHelper.shared.BASEURL + APIHelper.confirmLocationChange
                print("params",url,paramdict)
                
                Alamofire.request(url, method:.post, parameters: paramdict, encoding: JSONEncoding.default, headers:APIHelper.shared.authHeader)
                    .responseJSON { response in
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        print(response.result.value as Any)
                        switch response.result {
                        
                        case .success(_):
                            
                            if let result = response.result.value as? [String: AnyObject] {
                                if response.response?.statusCode == 200 {
                                    if let data = result["data"] as? [String: AnyObject] {
                                        if let result = data["result"] as? [String: AnyObject] {
                                            
                                            if let isAccepted = result["driver_accept"] as? Bool, isAccepted {
                                                if let lat = result["latitude"], let lng = result["longitude"], let address = result["address"] as? String {
                                                    LocalDB.shared.currentTripDetail?.dropLatitude = Double("\(lat)")
                                                    LocalDB.shared.currentTripDetail?.dropLongitude = Double("\(lng)")
                                                    LocalDB.shared.currentTripDetail?.dropLocation = address
                                                    print("DRP LAT LONG :",LocalDB.shared.currentTripDetail?.dropLatitude,LocalDB.shared.currentTripDetail?.dropLongitude )
                                                    self.dismiss(animated: true) {
                                                        self.callBack?(true)
                                                    }
                                                } else {
                                                    print("NO LAT LONG")
                                                    self.dismiss(animated: true) {
                                                        self.callBack?(true)
                                                    }
                                                }
                                                
                                            } else {
                                                self.dismiss(animated: true) {
                                                    self.callBack?(false)
                                                }
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
                        case .failure(let error):
                            self.view.showToast(error.localizedDescription)
                        }
                        
                    }
            })
        } else {
            
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        print("Am hitted")
        let queryItems = [URLQueryItem(name: "origin", value: "\(source.latitude),\(source.longitude)"),URLQueryItem(name: "destination", value: "\(destination.latitude),\(destination.longitude)"),URLQueryItem(name: "sensor", value: "false"),URLQueryItem(name: "mode", value: "driving"),URLQueryItem(name: "key", value: APIHelper.shared.gmsDirectionKey)]
        let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/directions/json", queryItem: queryItems)

        Alamofire.request(url).responseJSON { response in
            if case .failure(_) = response.result {
               print("")
            } else if case .success = response.result {
                if let JSON = response.result.value as? [String:AnyObject], let status = JSON["status"] as? String {
                    if status == "OK" {
                        if let routes = JSON["routes"] as? [[String:AnyObject]], let route = routes.first, let polyline = route["overview_polyline"] as? [String:AnyObject], let points = polyline["points"] as? String {
                           
                            self.polyPoints = points
                                LocalDB.shared.currentTripDetail?.pathToDestination = points
                            
                        }
                    }
                }
            }
        }
    }
    
    func getPolylineRouteWithWaypoint(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D,points:[CLLocationCoordinate2D]) {
        print("Am hitted")
        var wayPoints = ""
        
        for point in points {
            wayPoints = wayPoints == "" ? "\(point.latitude),\(point.longitude)" : "\(wayPoints)|\(point.latitude),\(point.longitude)"
        }
        
        let queryItems = [URLQueryItem(name: "origin", value: "\(source.latitude),\(source.longitude)"),URLQueryItem(name: "destination", value: "\(destination.latitude),\(destination.longitude)"),URLQueryItem(name: "sensor", value: "false"),URLQueryItem(name: "mode", value: "driving"),URLQueryItem(name: "waypoints", value: "\(wayPoints)"),URLQueryItem(name: "key", value: APIHelper.shared.gmsDirectionKey)]
        
        let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/directions/json", queryItem: queryItems)

        Alamofire.request(url).responseJSON { response in
            if case .failure(_) = response.result {
               print("")
            } else if case .success = response.result {
                if let JSON = response.result.value as? [String:AnyObject], let status = JSON["status"] as? String {
                    if status == "OK" {
                        if let routes = JSON["routes"] as? [[String:AnyObject]], let route = routes.first, let polyline = route["overview_polyline"] as? [String:AnyObject], let points = polyline["points"] as? String {
                           
                            self.polyPoints = points
                                LocalDB.shared.currentTripDetail?.pathToDestination = points
                            
                        }
                    }
                }
            }
        }
    }
}
