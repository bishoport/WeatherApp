//
//  HourPrediction.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 26/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit

class HourPrediction: NSObject {
    
    var hour_value : String?
    var temp_value : String?
    var symbol_value : String?
    var desc_value : String?
}


//
//<hour value="01:00">
//<temp value="6" unit="°C"/>
//<symbol value="1" desc="Despejado" value2="1" desc2="Despejado"/>
//<wind value="18" unit="km/h" dir="NE" symbol="10" symbolB="42"/>
//<wind-gusts value="35" unit="km/h"/>
//<rain value="0" unit="mm"/>
//<humidity value="69"/>
//<pressure value="1028" unit="mb"/>
//<clouds value="2%"/>
//<snowline value="2200" unit="m"/>
//<windchill value="3" unit="°C"/>
//</hour>

