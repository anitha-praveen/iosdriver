//
//  DashboardModel.swift
//  Roda Driver
//
//  Created by NPlus Technologies on 08/06/22.
//

import Foundation

struct DashboardData {
    var earnedToday: String?
    var earnedyesterday: String?
    var earnedCurrentWeek: String?
    var earnedCurrentMonth: String?
    var totaltrips: String?
    var weeklytrips: String?
    var monthlytrips: String?
    var totalAmount: String?
    var fineAmount: String?
    var fineReason: String?
    var cancellationBalance: String?
    
    
    init(_ dict: [String: AnyObject]) {
        
        if let todayTrip = dict["today_trips"] as? [String:Any] {
            if let amount = todayTrip["amount"] as? [String:Any] {
                if let cash = amount["cash"] {
                    self.earnedToday = "\(cash)"
                }
            }
        }
        
        if let yesterdayTrip = dict["yesterday_trips"] as? [String:Any] {
            if let amount = yesterdayTrip["amount"] as? [String:Any] {
                if let cash = amount["cash"] {
                    self.earnedyesterday = "\(cash)"
                }
            }
        }
        
        
        if let totaltrip = dict["total_trips"] as? [String:Any] {
            if let tripsCompleted = totaltrip["is_completed"] {
                self.totaltrips = "\(tripsCompleted)"
            }
            if let amount = totaltrip["amount"] as? [String:Any] {
                if let cash = amount["cash"] {
                    self.totalAmount = "\(cash)"
                }
            }
        }
        if let weeklytrip = dict["weekly_trips"] as? [String:Any] {
            if let tripsCompleted = weeklytrip["is_completed"] {
                self.weeklytrips = "\(tripsCompleted)"
            }
            if let amount = weeklytrip["amount"] as? [String:Any] {
                if let cash = amount["cash"] {
                    self.earnedCurrentWeek = "\(cash)"
                }
            }
        }
        if let monthlytrip = dict["monthly_trips"] as? [String:Any] {
            if let tripsCompleted = monthlytrip["is_completed"] {
                self.monthlytrips = "\(tripsCompleted)"
            }
            if let amount = monthlytrip["amount"] as? [String:Any] {
                if let cash = amount["cash"] {
                    self.earnedCurrentMonth = "\(cash)"
                }
            }
        }
        if let fineAmount = dict["fine_amount"] {
            self.fineAmount = "\(fineAmount)"
        }
        if let fineReason = dict["description"] {
            self.fineReason = "\(fineReason)"
        }
        if let cancelBalance = dict["balance_cancellation_amount"] {
            self.cancellationBalance = "\(cancelBalance)"
        }
        
        
    }
    
    
    
}
