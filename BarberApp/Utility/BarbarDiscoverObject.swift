//
//  BarbarDiscoverObject.swift
//  BarberApp
//
//  Created by GD3 on 5/11/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import Foundation

class BarbarDiscoverObject: NSObject {
    
    var saloon_location = String()
    var additional_info = String()
    var saloon_name = String()
    var barber_start_time = String()
    var barber_clsoe_time = String()
    var tomorrow_start_time = String()
    var tomorrow_clsoe_time = String()
    var avg_rating = String()
    var total_customer = String()
    var provide_home_service = String()
    var service_type = String()
    var barber_name = String()
    var nationality = String()
    var user_id = String()
    var saloon_lat = String()
    var saloon_lon = String()
    var price_range = String()
    var first_name = String()
    var family_name = String()
     var about = String()
    var fully_occupied_status = String()
    var booking_time = [BookingTimeObject]()
    var timeSlots = [TimeObj]()
}

class BookingTimeObject : NSObject
{
    var booking_time_from = String()
    var booking_time_to = String()
    var date = String()
    
}
