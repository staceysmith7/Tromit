//
//  Notification.swift
//  Tromit
//
//  Created by Casse on 30/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import Foundation
import FirebaseAuth

class Notification {
    
    var from: String?
    var objectId: String?
    var type: String?
    var timestamp: String?
    var id: String?
}

extension Notification {
    
    static func transform(dict: [String: Any], key: String) -> Notification {
        
        let notification = Notification()
        notification.id = key
        notification.objectId = dict["objectId"] as? String
        notification.type = dict["type"] as? String
        notification.timestamp = dict["timestamp"] as? String
        notification.from = dict["from"] as? String
        return notification
        
    }
}
