//
//  BarberDetailsObject.swift
//  BarberApp
//
//  Created by GD3 on 5/14/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class BarberDetailsObject: NSObject {
    var first_name = String()
    var last_name = String()
    var family_name = String()
    var saloon_lat = String()
    var saloon_lon = String()
    var nationality = String()
    var about = String()
    var home_service = String()
    var service_type = String()
    var saloon_name = String()
    var saloon_location = String()
    var instagram_token = String()
    var avg_rating = Double()
    var total_customer = String()
    var additional_info = [String]()
    var barber_start_time = String()
       var barber_clsoe_time = String()
       var tomorrow_start_time = String()
       var tomorrow_clsoe_time = String()
    var ip_address = String()
    var barber_rating = [BarberRatingObject]()
    var booking_time = [BookingTimeObject]()
    var barber_availTime = [BarberAvailTimeObject]()
    var like_status = String()
    var service_list_array = [ServiceListObject]()
    var timeSlots = [TimeObj]()
    var recommendedBarberList = [BarbarDiscoverObject]()
    
    
    
}

class BarberRatingObject: NSObject {
     var comment = String()
        var rating = String()
        var first_name = String()
      var last_name = String()
}

class BarberAvailTimeObject: NSObject {
     var day = String()
    var day_off_status = String()
    var time_slots = [ScheduleObject]()
    
}

 
