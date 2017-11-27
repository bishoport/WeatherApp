//
//  ContentSideMenuViewController.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 26/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit
import SwiftEventBus

class MenuItem:NSObject{
    var title : String = ""
    var dayNumber : Int = 0
    var type : String = ""
    var icon : String = ""
}



class ContentSideMenuViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{

    var mainViewController : MainViewController?
    @IBOutlet weak var tableView: UITableView!
    
    var weeksDaysArray : [MenuItem] = [MenuItem]()
    var favouritesArray : [FavoriteCity] = [FavoriteCity]()
    var optionsItemsMenu : [MenuItem] = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // retrieving Favourites from Preferences
        if let data = UserDefaults.standard.data(forKey: "favorites"),
            let gettingArrayFavourites = NSKeyedUnarchiver.unarchiveObject(with: data) as? [FavoriteCity] {
            self.favouritesArray = gettingArrayFavourites
        }

        
        self.weeksDaysArray = AppDelegate.shared().arraySideMenuItems
        
        
        let menuItemVerWebView : MenuItem = MenuItem()
            menuItemVerWebView.title = "Más información"
            menuItemVerWebView.dayNumber = 99
            menuItemVerWebView.type = "option_open_webview"
            menuItemVerWebView.icon = "info_icon"
        
        let menuItemNewSearch : MenuItem = MenuItem()
            menuItemNewSearch.title = "Nueva localización"
            menuItemNewSearch.dayNumber = 99
            menuItemNewSearch.type = "option_new_search"
            menuItemNewSearch.icon = "location_icon"
        
        
        self.optionsItemsMenu.append(menuItemNewSearch)
        self.optionsItemsMenu.append(menuItemVerWebView)
        
        
        tableView.register(UINib(nibName: "WeekDayTableViewCell", bundle: nil), forCellReuseIdentifier: "WeekDayTableViewCell")
        tableView.register(UINib(nibName: "LabelWithImageViewTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelWithImageViewTableViewCell")
        
        
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return weeksDaysArray.count
        }
        if section == 1 {
            return optionsItemsMenu.count
        }
        else{
           return favouritesArray.count
        }
    }
    
   
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 25))
            view.backgroundColor = UIColor(red: 105.0/255.0, green: 181.0/255.0, blue: 213.0/255.0, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: 25))
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textColor = UIColor.black
        
        if section == 0 {
            label.text = "Próximas predicciones"
        }
        else if section == 1 {
            label.text = "Otras opciones"
        }
        else{
            label.text = "Ciudades favoritas"
        }
        
    
        view.addSubview(label)
        return view
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell : WeekDayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeekDayTableViewCell") as! WeekDayTableViewCell
                cell.bigLabelCell.text = weeksDaysArray[indexPath.row].title
            return cell
        }
        else if indexPath.section == 1 {
            let cell : LabelWithImageViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LabelWithImageViewTableViewCell") as! LabelWithImageViewTableViewCell
                cell.labelTitleCell.text = optionsItemsMenu[indexPath.row].title
                cell.imageViewCell.image = UIImage(named: optionsItemsMenu[indexPath.row].icon)
            return cell
        }
        else{
            let cell : LabelWithImageViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LabelWithImageViewTableViewCell") as! LabelWithImageViewTableViewCell
                cell.labelTitleCell.text = favouritesArray[indexPath.row].name
                cell.imageViewCell.image = UIImage(named: "favourite_button_on")
            return cell
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            SwiftEventBus.post("selectItemFromMenu", sender: TicketSideMenuItem(itemMenu: weeksDaysArray[indexPath.row]))
        }
        else if indexPath.section == 1 {

            if optionsItemsMenu[indexPath.row].type == "option_new_search" {
                SwiftEventBus.post("newSearchEvent")
            }
            else if optionsItemsMenu[indexPath.row].type == "option_open_webview" {
                SwiftEventBus.post("showWebViewEvent")
            }
        }
        else if indexPath.section == 2 {
            AppDelegate.shared().citySelected = favouritesArray[indexPath.row].id
            SwiftEventBus.post("reloadCity")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

}
