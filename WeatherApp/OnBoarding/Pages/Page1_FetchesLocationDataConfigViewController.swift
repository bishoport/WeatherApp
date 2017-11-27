//
//  Page1_FetchesContinetsViewController.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 25/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit
import BWWalkthrough
import SwiftEventBus

class Page1_FetchesLocationDataConfigViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource , CompoStateDelegate {
    
    var delegate : MyBWWalkthroughViewController?
    @IBOutlet weak var fetchingIndicatorActivity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var currentTitle : String = ""
    var dataArray : [LocationDataConfig]?
    
    var returnEventName : String = ""

    var typeData : Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = currentTitle

        delegate?.compoStateListener = self
        
        SwiftEventBus.onMainThread(self, name: returnEventName) { notification in
            let ticket : TicketDataArray = notification.object as! TicketDataArray
            self.dataArray = (ticket.dataArray as! NSArray) as? [LocationDataConfig]

            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            self.delegate?.openCompo()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {

    }
    

    
    func getData(){

        var url: String = ""
        
        if typeData == 0 {
             url = "\(ServicesConnections.baseURL)&continente=0&\(ServicesConnections.affiliateNumber)"
        }
        else if typeData == 1 {
             url = "\(ServicesConnections.baseURL)&continente=\(AppDelegate.shared().continentSelected)&\(ServicesConnections.affiliateNumber)"
        }
        else if typeData == 2 {
             url = "\(ServicesConnections.baseURL)&pais=\(AppDelegate.shared().countrySelected)&\(ServicesConnections.affiliateNumber)"
        }
        else if typeData == 3 {
            url = "\(ServicesConnections.baseURL)&provincia=\(AppDelegate.shared().provinceSelected)&\(ServicesConnections.affiliateNumber)"
        }
        
        ServicesConnections.getDataLocation(url: url, eventName: returnEventName)
    }
    
    func clearData(){
        self.dataArray?.removeAll()
        self.tableView.reloadData()
    }

    

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataArray?.count)!
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : GenericWTTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GenericWTTableViewCell") as! GenericWTTableViewCell
            cell.imageViewCell.isHidden = true
            cell.labelTitle.text = dataArray?[indexPath.row].name
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        
        let currentCell : GenericWTTableViewCell = tableView.cellForRow(at: indexPath) as! GenericWTTableViewCell
            currentCell.imageViewCell.isHidden = false
        
        if typeData == 0 {
            AppDelegate.shared().continentSelected = (dataArray?[indexPath.row].id)!
            delegate?.nextPage()
        }
        else if typeData == 1 {
           AppDelegate.shared().countrySelected = (dataArray?[indexPath.row].id)!
            delegate?.nextPage()
        }
        else if typeData == 2 {
            AppDelegate.shared().provinceSelected = (dataArray?[indexPath.row].id)!
            delegate?.nextPage()
        }
        else if typeData == 3 {
            AppDelegate.shared().citySelected = (dataArray?[indexPath.row].id)!
            UserDefaults.standard.setValue(AppDelegate.shared().citySelected, forKey: "lastCityId")
//            self.delegate?.closeCompo()
            delegate?.close(NSObject())
        }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func compoStateOpened() {
    }
    
    func compoStateClosed() {
//        delegate?.close(NSObject())
    }

}
