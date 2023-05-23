//
//  WaitingTimeHandler.swift
//  Taxiappz Driver
//
//  Created by Apple on 16/02/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit

class WaitingTimeHandler: NSObject {
    
    static let shared = WaitingTimeHandler()
    
    var arrivedTime: Date? {
        get {
            return UserDefaults.standard.object(forKey: "arrivedTime") as? Date ?? Date()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "arrivedTime")
            UserDefaults.standard.synchronize()
        }
    }
    
    private var graceTimer: Timer?
    private var timer: Timer?
    private(set) var waitingTime: Int {
        get {
            return UserDefaults.standard.integer(forKey: "waitingTime")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "waitingTime")
            timerValueChanged?(newValue)
        }
    }

    var waitingTimeServerFormat: Int {
        return waitingTime / 60//String(format: "%02d", (waitingTime / 60))
    }
    var waitingTimeLabelFormat: String {
        return String(format: "%02d : %02d", (waitingTime / 60), waitingTime % 60)
    }
    var timerValueChanged: ((Int)->Void)?
    func startGraceTimer(after time: TimeInterval) {
        graceTimer?.invalidate()
        graceTimer = nil
        graceTimer = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { timer in
            self.startTimer()
        }
    }
    func startTimer() {
        timer?.invalidate()
        timer = nil
        graceTimer?.invalidate()
        graceTimer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
           
            
            if ((AppLocationManager.shared.locationManager.location?.speed ?? 0) * 3600/1000)
                <= (LocalDB.shared.currentTripDetail?.minimumSpeed ?? 3.0) {
                self.waitingTime += 1
            }

        })
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        waitingTime = 0
        graceTimer?.invalidate()
        graceTimer = nil
    }
    
    func clearArrivedTime() {
        self.arrivedTime = nil
    }
}


//MARK: - RENTAL TRIP TIME HANDLER


class RentalTripTimeHandler: NSObject {
    
    static let shared = RentalTripTimeHandler()
    
    var rentalTripStartTime: Date? {
        get {
            return UserDefaults.standard.object(forKey: "rentalTripStartTime") as? Date ?? Date()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "rentalTripStartTime")
            UserDefaults.standard.synchronize()
        }
    }
    var rentalTimerValueChanged: ((Int)->Void)?
    private var rentalTimer: Timer?
    var rentalTripTime: Int {
        get {
            return UserDefaults.standard.integer(forKey: "rentalTripTime")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "rentalTripTime")
            rentalTimerValueChanged?(newValue)
        }
    }

    var rentalTripTimeLabelFormat: String {
        return String(format: "%02d:%02d:%02d", (rentalTripTime / 3600),(rentalTripTime % 3600)/60, (rentalTripTime % 3600)%60)
    }
 
    func startRentalTimer() {
        rentalTimer?.invalidate()
        rentalTimer = nil
        
        rentalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in

            self.rentalTripTime += 1
           
        })
    }
    func stopRentalTimer() {
        rentalTimer?.invalidate()
        rentalTimer = nil
        rentalTripTime = 0
        
    }
    
    func clearRentalStartTime() {
        self.rentalTripStartTime = nil
        UserDefaults.standard.removeObject(forKey: "rentalTripStartTime")
    }
}
