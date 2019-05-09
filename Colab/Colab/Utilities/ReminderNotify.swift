//
//  ReminderNotify.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 5/6/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import Foundation
import UIKit

class ReminderNotify: NSObject, NSCoding{
   
    
    //Properties
    var notification: UILocalNotification
    var title: String
    var time: Date
    
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchieveURL = DocumentDirectory.appendingPathComponent("reminders")
    
    struct PropertyKey{
        static let titleKey = "title"
        static let timeKey = "time"
        static let notificationKey = "notification"
    }
    
    init(title: String, time: Date, notification: UILocalNotification) {
        self.title = title
        self.time = time
        self.notification = notification
        
        super.init()
    }
    
    deinit {
        UIApplication.shared.cancelLocalNotification(self.notification)
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.titleKey)
        aCoder.encode(time, forKey: PropertyKey.timeKey)
        aCoder.encode(notification, forKey: PropertyKey.notificationKey)
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: PropertyKey.titleKey) as! String
        let time = aDecoder.decodeObject(forKey: PropertyKey.timeKey) as! Date
        let notification = aDecoder.decodeObject(forKey: PropertyKey.notificationKey) as! UILocalNotification
        
        self.init(title: title, time: time, notification: notification)
    }

    
}
