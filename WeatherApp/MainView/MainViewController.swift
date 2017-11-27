//
//  ViewController.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 25/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit
import BWWalkthrough
import SwiftEventBus

import SideMenu

class MainViewController: UIViewController , BWWalkthroughViewControllerDelegate , UITableViewDelegate,UITableViewDataSource{

    var btnButtonMenu: UIBarButtonItem!
    var btnButtonFavourite: UIBarButtonItem!
    
    @IBOutlet weak var headerCurrentDayView: UIView!
    
    
    var walkthrough : MyBWWalkthroughViewController? = nil
    var page_0 : Page1_FetchesLocationDataConfigViewController?
    var page_1 : Page1_FetchesLocationDataConfigViewController?
    var page_2 : Page1_FetchesLocationDataConfigViewController?
    var page_3 : Page1_FetchesLocationDataConfigViewController?
    
    
    
    var dayPredictionsArray : [DayPrediction] = [DayPrediction]()
    
    
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelDateDay: UILabel!
    @IBOutlet weak var labelTempDay: UILabel!
    @IBOutlet weak var imageViewIconDay: UIImageView!
    @IBOutlet weak var labelDescDay: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var currentDay : Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Weather App"
        headerCurrentDayView.isHidden = true

        //SideMenu Button
        btnButtonMenu = UIBarButtonItem(image: UIImage(named: "ico_menu"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(MainViewController.openSideMenu))
        
        self.navigationItem.leftBarButtonItem  = btnButtonMenu
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        //Favourite Menu Button
        btnButtonFavourite = UIBarButtonItem(image: UIImage(named: "favourite_button_off"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(MainViewController.setCityFavourite))
        
        self.navigationItem.rightBarButtonItem  = btnButtonFavourite
        
        
        
        
        
        //Swift Event Listeners
        SwiftEventBus.onMainThread(self, name: "getByDaysDataPredictionDownloaded") { notification in
            let ticket : TicketDataArray = notification.object as! TicketDataArray
            self.dayPredictionsArray = ((ticket.dataArray as! NSArray) as? [DayPrediction])!
            
            var i : Int = 0
            
            AppDelegate.shared().arraySideMenuItems.removeAll()
            
            for day in self.dayPredictionsArray {
                let menuItem : MenuItem = MenuItem()
                    menuItem.title = day.day_name_value!
                    menuItem.dayNumber = i
                    menuItem.type = "day"
                i = i + 1
                AppDelegate.shared().arraySideMenuItems.append(menuItem)
            }
            
            self.reloadDay()
        }
        
        SwiftEventBus.onMainThread(self, name: "selectItemFromMenu") { notification in
            let ticket : TicketSideMenuItem = notification.object as! TicketSideMenuItem
            self.currentDay = (ticket.itemMenu?.dayNumber)!
            self.reloadDay()
        }
        
        SwiftEventBus.onMainThread(self, name: "newSearchEvent") { notification in
            SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: {
                
                if self.walkthrough == nil{
                    self.showWalkthrough()
                }
                else{
                    self.present((self.walkthrough)!, animated: true, completion: nil)
                }
                
            })
        }
        
        SwiftEventBus.onMainThread(self, name: "showWebViewEvent") { notification in
            SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: {
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "InfoWebViewController") as! InfoWebViewController
                self.navigationController?.pushViewController(vc, animated: true);
            })
        }
        
        SwiftEventBus.onMainThread(self, name: "reloadCity") { notification in
            SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: {
                ServicesConnections.getByDaysDataPrediction(url: "\(ServicesConnections.baseURL)&localidad=\(AppDelegate.shared().citySelected)&\(ServicesConnections.affiliateNumber)&v=2.0&h=1", eventName: "getByDaysDataPredictionDownloaded")
            })
        }
        //---------------------
        
    }
    
    
    
    @objc func openSideMenu(){
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
 
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Shadow HEADER
        headerCurrentDayView.clipsToBounds = false
        headerCurrentDayView.layer.shadowColor = UIColor.black.cgColor
        headerCurrentDayView.layer.shadowOpacity = 1
        headerCurrentDayView.layer.shadowOffset = CGSize.zero
        headerCurrentDayView.layer.shadowRadius = 5
        headerCurrentDayView.layer.shadowPath = UIBezierPath(roundedRect: headerCurrentDayView.bounds, cornerRadius: 0).cgPath
        
        
        //Check First Time
        if AppDelegate.shared().citySelected.isEmpty == true {
            if (UserDefaults.standard.object(forKey: "lastCityId") != nil) {
                ServicesConnections.getByDaysDataPrediction(url: "\(ServicesConnections.baseURL)&localidad=\(AppDelegate.shared().citySelected)&\(ServicesConnections.affiliateNumber)&v=2.0&h=1", eventName: "getByDaysDataPredictionDownloaded")
            }
            else{
                showWalkthrough()
            }
        }
        else{
            ServicesConnections.getByDaysDataPrediction(url: "\(ServicesConnections.baseURL)&localidad=\(AppDelegate.shared().citySelected)&\(ServicesConnections.affiliateNumber)&v=2.0&h=1", eventName: "getByDaysDataPredictionDownloaded")
        }
    }
    
    
    @objc func setCityFavourite(){
        self.saveFavourite()
        btnButtonFavourite.image = UIImage(named: "favourite_button_on")
        btnButtonFavourite.isEnabled = false
    }
    
    
    func saveFavourite(){
        
        if let data = UserDefaults.standard.data(forKey: "favorites"),
            var myFavouriteList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [FavoriteCity] {
            let favoriteCity = FavoriteCity(name: self.dayPredictionsArray[self.currentDay].city_name_value!, id: AppDelegate.shared().citySelected)
            myFavouriteList.append(favoriteCity)
            
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: myFavouriteList)
            UserDefaults.standard.set(encodedData, forKey: "favorites")

        }
        else {
            let favoriteCity = FavoriteCity(name: self.dayPredictionsArray[self.currentDay].city_name_value!, id: AppDelegate.shared().citySelected)
            var favorites = [FavoriteCity]()
                favorites.append(favoriteCity)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: favorites)
            UserDefaults.standard.set(encodedData, forKey: "favorites")
        }
    }

    
    func reloadDay(){

        //Show Data day
        self.labelCityName.text = self.dayPredictionsArray[self.currentDay].city_name_value
        let dateStringInfo : String = "\(String(describing: self.dayPredictionsArray[self.currentDay].day_name_value!)) \(self.dayPredictionsArray[self.currentDay].current_time_value!)"
        self.labelDateDay.text = dateStringInfo
        
        let tempStringInfo : String = "Max \(String(describing:self.dayPredictionsArray[self.currentDay].temp_max_value!))ºC / Min \(String(describing:self.dayPredictionsArray[self.currentDay].temp_min_value!))ºC"
        
        self.labelTempDay.text = tempStringInfo
        self.imageViewIconDay.image = UIImage(named: self.dayPredictionsArray[self.currentDay].symbol_value!)
        self.labelDescDay.text = self.dayPredictionsArray[self.currentDay].desc_value
        
        
        //Config TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        
        //Active SideMenu Button
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        
        
        //Show Header Current Day
        headerCurrentDayView.isHidden = false
        
        
        
        //Check if is favourite
        if let data = UserDefaults.standard.data(forKey: "favorites"),
            let gettingArrayFavourites = NSKeyedUnarchiver.unarchiveObject(with: data) as? [FavoriteCity] {
            
            var isFavourite : Bool = false
            
            for favourite in gettingArrayFavourites {
                if self.labelCityName.text == favourite.name {
                    isFavourite = true
                }
            }
            
            if isFavourite == true {
                btnButtonFavourite.image = UIImage(named: "favourite_button_on")
                btnButtonFavourite.isEnabled = false
            }
            else{
                btnButtonFavourite.image = UIImage(named: "favourite_button_off")
                btnButtonFavourite.isEnabled = true
            }
        }
    }
    
    

    
    
    //TABLEVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dayPredictionsArray[currentDay].hourPredictionArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HourDayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HourDayTableViewCell") as! HourDayTableViewCell
            cell.labelHourDay.text = self.dayPredictionsArray[currentDay].hourPredictionArray[indexPath.row].hour_value
            cell.labelTempDay.text = "\(String(describing: self.dayPredictionsArray[currentDay].hourPredictionArray[indexPath.row].temp_value!))ºC"
            cell.labelDescDay.text = self.dayPredictionsArray[currentDay].hourPredictionArray[indexPath.row].desc_value
            cell.imageViewIconDay.image = UIImage(named: self.dayPredictionsArray[currentDay].hourPredictionArray[indexPath.row].symbol_value!)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //WALKTHROUGH
    func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Onboarding", bundle: nil)
        
        walkthrough = stb.instantiateViewController(withIdentifier: "walk") as? MyBWWalkthroughViewController
        
        //Page 0 -> Continenentes
        page_0 = stb.instantiateViewController(withIdentifier: "Page1_FetchesLocationDataConfigViewController") as? Page1_FetchesLocationDataConfigViewController
        page_0?.currentTitle = "Selecciona un continente"
        page_0?.returnEventName = "serviceContinentsDownloaded"
        page_0?.typeData = 0
        page_0?.delegate = walkthrough
        
        //Page 1 -> Paises
        page_1 = stb.instantiateViewController(withIdentifier: "Page1_FetchesLocationDataConfigViewController") as? Page1_FetchesLocationDataConfigViewController
        page_1?.currentTitle = "Selecciona un pais"
        page_1?.returnEventName = "serviceCountriesDownloaded"
        page_1?.typeData = 1
        page_1?.delegate = walkthrough
        
        //Page 2 -> Provincias
        page_2 = stb.instantiateViewController(withIdentifier: "Page1_FetchesLocationDataConfigViewController") as? Page1_FetchesLocationDataConfigViewController
        page_2?.currentTitle = "Ahora selecciona una provincia"
        page_2?.returnEventName = "serviceProvincesDownloaded"
        page_2?.typeData = 2
        page_2?.delegate = walkthrough
        
        //Page 3 -> Ciudades
        page_3 = stb.instantiateViewController(withIdentifier: "Page1_FetchesLocationDataConfigViewController") as? Page1_FetchesLocationDataConfigViewController
        page_3?.currentTitle = "Por último la ciudad"
        page_3?.returnEventName = "serviceCitiesDownloaded"
        page_3?.typeData = 3
        page_3?.delegate = walkthrough

        
        // Attach the pages to the master
        walkthrough?.delegate = self
        walkthrough?.add(viewController:page_0!)
        walkthrough?.add(viewController:page_1!)
        walkthrough?.add(viewController:page_2!)
        walkthrough?.add(viewController:page_3!)
        
        self.present((walkthrough)!, animated: false, completion: nil)
    }
    
    
    // MARK: - Walkthrough delegate -
    func walkthroughPageDidChange(_ pageNumber: Int) {
        
        if pageNumber == 0 {
            page_0?.getData()
        }
        else if pageNumber == 1 {
            page_1?.getData()
        }
        else if pageNumber == 2 {
            page_2?.getData()
        }
        else if pageNumber == 3 {
            page_3?.getData()
        }
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}


