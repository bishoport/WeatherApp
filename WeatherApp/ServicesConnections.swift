//
//  ServicesConnections.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 25/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyXMLParser
import SwiftEventBus

class ServicesConnections: NSObject {
    
 
    //BASES TEXTO
    static let baseURL : String = "http://api.tiempo.com/index.php?api_lang=es"
    static let affiliateNumber : String = "affiliate_id=4s2m2ot5ghql"
    //-----------
    
    
    
    static func getDataLocation(url : String , eventName : String) {
        
//        print("URL -> \(url)")
        
        Alamofire.request(url , method: .get)
            .responseData { response in
                if let data = response.data {
                    let xmlContinents  = XML.parse(data)
                    
                    let dataArray : NSMutableArray = NSMutableArray()
                    
                    if let error = xmlContinents["report", "error"].element {
                        AppDelegate.shared().creadorAlertView(texto: error.text!, titulo: "Ups")
                    }
                    else{
                        for element in xmlContinents["report", "location", "data"] {
                            
                            let locationDataConfig : LocationDataConfig = LocationDataConfig()
                                locationDataConfig.id = element["name"].attributes["id"]
                                locationDataConfig.type = ""
                                locationDataConfig.name = element["name"].text!
                            
                            dataArray.add(locationDataConfig)
                        }
                        
                        if dataArray.count > 0 {
                            SwiftEventBus.post(eventName, sender: TicketDataArray(dataArray: dataArray))
                        }
                        else{
                            AppDelegate.shared().creadorAlertView(texto: "La lista viene vacía.", titulo: "Ups")
                        }
                    }
                }
        }
    }
    
    
    
    
    
    
    static func getByDaysDataPrediction(url : String , eventName : String) {
        
        //        print("URL -> \(url)")
        
        Alamofire.request(url , method: .get)
            .responseData { response in
                if let data = response.data {
                    let xmlContinents  = XML.parse(data)
                    
                    let dataArray : NSMutableArray = NSMutableArray()
                    
                    let elementLocationInfo = xmlContinents["report","location"]
 
                    for element in xmlContinents["report", "location", "day"] {
 
                        let dayPrediction : DayPrediction = DayPrediction()
                            dayPrediction.city_name_value = elementLocationInfo.attributes["city"]
                            dayPrediction.day_name_value =  element.attributes["name"]
                        
                            dayPrediction.current_time_value =  element["local_info"].attributes["local_time"]
                            dayPrediction.symbol_value =  element["symbol"].attributes["value"]
                            dayPrediction.desc_value =  element["symbol"].attributes["desc"]
                            dayPrediction.temp_min_value =  element["tempmin"].attributes["value"]
                            dayPrediction.temp_max_value =  element["tempmax"].attributes["value"]
                        
                        
                            for elementHour in element["hour"] {
                                
                                let hourPrediction : HourPrediction = HourPrediction()
                                    hourPrediction.hour_value = elementHour.attributes["value"]
                                    hourPrediction.desc_value = elementHour["symbol"].attributes["desc"]
                                    hourPrediction.symbol_value = elementHour["symbol"].attributes["value"]
                                    hourPrediction.temp_value = elementHour["temp"].attributes["value"]
                                

                                dayPrediction.hourPredictionArray.append(hourPrediction)
                            }
  
                        dataArray.add(dayPrediction)
                    }
                    
                    SwiftEventBus.post(eventName, sender: TicketDataArray(dataArray: dataArray))
                }
        }
    }
    
    
    
}
