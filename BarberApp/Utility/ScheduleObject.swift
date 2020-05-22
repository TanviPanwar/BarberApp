//
//  ScheduleObject.swift
//  BarberApp
//
//  Created by iOS6 on 30/04/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import Foundation

class ScheduleObject: NSObject {

    var time_from = String()
    var time_to = String()
    var day = String()
    var day_off_status = String()
    var day_time_id = String()
    var id = String()
    var identify = Int()
    var mainIdentify = Int()
    var switchBool = Bool()
    var time_slots = [ScheduleObject]()

    
}

