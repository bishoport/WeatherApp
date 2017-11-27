//
//  DayPrediction.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 26/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit

class DayPrediction: NSObject {

    var city_name_value : String?
    var current_time_value : String?
    var day_name_value : String?
    var symbol_value : String?
    var desc_value : String?
    var temp_min_value : String?
    var temp_max_value : String?
    
    var hourPredictionArray : [HourPrediction] =  [HourPrediction]()
}


//<day value="20171126" name="Domingo">
//<symbol value="1" desc="Despejado" value2="1" desc2="Despejado"/>
//<tempmin value="2" unit="°C"/>
//<tempmax value="12" unit="°C"/>
//<wind value="18" unit="km/h" symbol="10" symbolB="42"/>
//<wind-gusts value="36" unit="km/h"/>
//<rain value="0" unit="mm"/>
//<humidity value="55"/>
//<pressure value="1031" unit="mb"/>
//<snowline value="2200" unit="m"/>
//<sun in="08:12" mid="13:01" out="17:50"/>
//<moon in="13:52" out="--:--" lumi="47.61%" desc="Luna Creciente, 47.61% Iluminada" symbol="7"/>
//<local_info local_time="14:25" offset="1"/>

