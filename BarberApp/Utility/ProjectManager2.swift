//
//  ProjectManager2.swift
//  BarberApp
//
//  Created by GD3 on 5/11/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit

class ProjectManager2: NSObject {
    static let sharedInstance =  ProjectManager2()
    
    private override init() {
        
    }
    
    func getBarbarDiscoverObjectData(array:NSArray) -> [BarbarDiscoverObject] {
        var resultArray = [BarbarDiscoverObject]()
        for item in array {
            
            let dict  = item as!  [String:Any]
            let obj = BarbarDiscoverObject()
            
            obj.saloon_location = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_location", dict: dict as NSDictionary) as String
            if let additional_info_array = dict["additional_info"] as? NSArray, additional_info_array.count > 0 {
                obj.additional_info = additional_info_array[0] as! String
            }
            obj.saloon_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_name", dict: dict as NSDictionary) as String
            
            obj.barber_start_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "barber_start_time", dict: dict as NSDictionary) as String
            
            obj.barber_clsoe_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "barber_clsoe_time", dict: dict as NSDictionary) as String
            
            obj.tomorrow_start_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "tomorrow_start_time", dict: dict as NSDictionary) as String
            
            obj.tomorrow_clsoe_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "tomorrow_clsoe_time", dict: dict as NSDictionary) as String
            
            obj.avg_rating = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "avg_rating", dict: dict as NSDictionary) as String
            
            obj.total_customer = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "total_customer", dict: dict as NSDictionary) as String
            
            obj.provide_home_service = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "provide_home_service", dict: dict as NSDictionary) as String
            
            obj.service_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "service_type", dict: dict as NSDictionary) as String
            
            obj.barber_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "barber_name", dict: dict as NSDictionary) as String
            
            obj.nationality = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "nationality", dict: dict as NSDictionary) as String
            
            obj.saloon_lat = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_lat", dict: dict as NSDictionary) as String
            
            obj.saloon_lon = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_lon", dict: dict as NSDictionary) as String
            obj.price_range = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "price_range", dict: dict as NSDictionary) as String
            
            if let fName = dict["first_name"] as? String, let lName = dict["family_name"] as? String,let about = dict["about"] as? String,let fully_occupied_status = dict["fully_occupied_status"] as? String{
                obj.first_name = fName
                obj.family_name = lName
                obj.about = about
                obj.fully_occupied_status = fully_occupied_status
            }
            
            obj.user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "user_id", dict: dict as NSDictionary) as String
            if let booking_time_array = dict["booking_time"] as? NSArray, booking_time_array.count > 0 {
                var bookingTimeArray = [BookingTimeObject]()
                for time in booking_time_array {
                    let timeObj = BookingTimeObject()
                    let timeDict = time as! [String:Any]
                    timeObj.booking_time_from = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "booking_time_from", dict: timeDict as NSDictionary) as String
                    timeObj.booking_time_to = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "booking_time_to", dict: timeDict as NSDictionary) as String
                    timeObj.date = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "date", dict: timeDict as NSDictionary) as String
                    bookingTimeArray.append(timeObj)
                }
                obj.booking_time = bookingTimeArray
            }
            
            resultArray.append(obj)
        }
        
        return resultArray
    }
    
    
    func getInstagramMediaData(array:NSArray) -> [String] {
        var idsArray = [String]()
        for item in array {
                   let dict  = item as!  [String:Any]
            idsArray.append(ProjectManager.sharedInstance.checkResponseForString(jsonKey: "media_url", dict: dict as NSDictionary) as String)
        }
        return idsArray
    }
    
     
    func getBarberDetailsData(dict:[String:Any]) -> BarberDetailsObject {
        let barberPersonalDetail = dict["barber_personal_detail"] as! [String:Any]
        let barberAdditionalDetail = dict["barber_additional_detail"] as! [String:Any]
        let barberServiceArray = (dict["barber_main_services"] as! NSArray).addingObjects(from: (dict["barber_extra_services"] as! NSArray) as! [Any])
        
        let obj = BarberDetailsObject()
        if let avgRating = dict["avg_rating"] as? Double
        {
            obj.avg_rating = avgRating
        }
        else
        {
            obj.avg_rating = 0.0
        }
        
        obj.like_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "like_status", dict: dict as NSDictionary) as String

        obj.total_customer = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "total_customer", dict: dict as NSDictionary) as String
        
        obj.first_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "first_name", dict: barberPersonalDetail as NSDictionary) as String
        obj.family_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "family_name", dict: barberPersonalDetail as NSDictionary) as String
        obj.nationality = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "nationality", dict: barberPersonalDetail["country_name"] as! NSDictionary) as String
         obj.ip_address = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "ip_address", dict: barberPersonalDetail  as NSDictionary) as String
        
        
        obj.saloon_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_name", dict: barberAdditionalDetail as NSDictionary) as String
        
        obj.home_service = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "home_service", dict: barberAdditionalDetail as NSDictionary) as String
        
        obj.barber_start_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "barber_start_time", dict: barberAdditionalDetail as NSDictionary) as String
        obj.barber_clsoe_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "barber_clsoe_time", dict: barberAdditionalDetail as NSDictionary) as String
        obj.tomorrow_start_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "tomorrow_start_time", dict: barberAdditionalDetail as NSDictionary) as String
        obj.tomorrow_clsoe_time = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "tomorrow_clsoe_time", dict: barberAdditionalDetail as NSDictionary) as String
        
        obj.saloon_lat = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_lat", dict: barberAdditionalDetail as NSDictionary) as String
        obj.about = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "about", dict: barberAdditionalDetail as NSDictionary) as String
        
        obj.saloon_lon = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_lon", dict: barberAdditionalDetail as NSDictionary) as String
        
        obj.instagram_token = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "instagram_token", dict: barberAdditionalDetail as NSDictionary) as String
        
        obj.service_type = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "service_type", dict: barberAdditionalDetail as NSDictionary) as String
        
        obj.saloon_location = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "saloon_location", dict: barberAdditionalDetail as NSDictionary) as String
        
        if let additional_info_array = barberAdditionalDetail["additional_info"] as? NSArray, additional_info_array.count > 0 {
            obj.additional_info = additional_info_array  as! [String]
        }
        var serviceListObject = [ServiceListObject]()
        
        for service in barberServiceArray
        {
            let serviceDict = service as! [String:Any]
            let obj = ServiceListObject()
            obj.service_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "service_id", dict: serviceDict as NSDictionary) as String
            obj.price = serviceDict["price"] as! Double
            obj.name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "service_name", dict: serviceDict["services_data"] as! NSDictionary) as String
            serviceListObject.append(obj)
        }
        obj.service_list_array = serviceListObject
        
        if let booking_time_array = dict["booking_time"] as? NSArray, booking_time_array.count > 0 {
            var bookingTimeArray = [BookingTimeObject]()
            for time in booking_time_array {
                let timeObj = BookingTimeObject()
                let timeDict = time as! [String:Any]
                timeObj.booking_time_from = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "booking_time_from", dict: timeDict as NSDictionary) as String
                timeObj.booking_time_to = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "booking_time_to", dict: timeDict as NSDictionary) as String
                timeObj.date = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "date", dict: timeDict as NSDictionary) as String
                bookingTimeArray.append(timeObj)
            }
            obj.booking_time = bookingTimeArray
        }
        
        
        if let barber_availTime_array = dict["barber_availTime"] as? NSArray, barber_availTime_array.count > 0 {
            var availTimeArray = [BarberAvailTimeObject]()
            for time in barber_availTime_array {
                let timeObj = BarberAvailTimeObject()
                let timeDict = time as! [String:Any]
                timeObj.day = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "day", dict: timeDict as NSDictionary) as String
                timeObj.day_off_status = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "day_off_status", dict: timeDict as NSDictionary) as String
                var scheduleOjectArray = [ScheduleObject]()
                if let slotsArray = timeDict["time_slots"] as? [[String:Any]], slotsArray.count > 0 {
                    for slots in slotsArray {
                        let slotsObj = ScheduleObject()
                        slotsObj.time_from = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "time_from", dict: slots as NSDictionary) as String
                        slotsObj.time_to = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "time_to", dict: slots as NSDictionary) as String
                        scheduleOjectArray.append(slotsObj)
                    }
                    timeObj.time_slots = scheduleOjectArray
                }
                availTimeArray.append(timeObj)
            }
            obj.barber_availTime = availTimeArray
        }
        
        if let barber_rating_array = dict["barber_rating"] as? NSArray, barber_rating_array.count > 0 {
            var barberRatingeArray = [BarberRatingObject]()
            for rating in barber_rating_array {
                let ratingObj = BarberRatingObject()
                let ratingDict = rating as! [String:Any]
                ratingObj.comment = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "comment", dict: ratingDict as NSDictionary) as String
                ratingObj.first_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "first_name", dict: ratingDict as NSDictionary) as String
                ratingObj.rating = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "rating", dict: ratingDict as NSDictionary) as String
                barberRatingeArray.append(ratingObj)
            }
            obj.barber_rating = barberRatingeArray
        }
        
        if let recommendArray = dict["recomended_barbers"] as? NSArray, recommendArray.count > 0 {
            obj.recommendedBarberList = ProjectManager2.sharedInstance.getBarbarDiscoverObjectData(array: recommendArray)
        }
        
        return obj
    }
    
    func getServiceListData(array:NSArray) ->[ServiceListObject] {
        var resultArray = [ServiceListObject]()
        
        for item in array {
            let obj = ServiceListObject()
            let dict  = item as!  [String:Any]
            obj.name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "name", dict: dict as NSDictionary) as String
            obj.service_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "id", dict: dict as NSDictionary) as String
            obj.isSelected = "0"
            resultArray.append(obj)
        }
        return resultArray
    }
    
    
    func getNationalityListData(array:NSArray) ->[NationalityObject] {
        var resultArray = [NationalityObject]()
        
        for item in array {
            let obj = NationalityObject()
            let dict  = item as!  [String:Any]
            obj.user_id = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "user_id", dict: dict as NSDictionary) as String
            obj.num_code = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "num_code", dict: dict as NSDictionary) as String
            obj.nationality = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "nationality", dict: dict as NSDictionary) as String
            obj.country_name = ProjectManager.sharedInstance.checkResponseForString(jsonKey: "country_name", dict: dict as NSDictionary) as String
            
            obj.isSelected = "0"
            resultArray.append(obj)
        }
        return resultArray
    }
}
