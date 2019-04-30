//
//  ChangeLocationVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 4/16/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase

class ChangeLocationVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredData = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.titleView = searchField
        searchField.showsScopeBar = false // you can show/hide this dependant on your layout
        searchField.placeholder = "Search by Location"
        searchField.delegate = self
        
//        searchController.searchBar.delegate = self
//

        definesPresentationContext = true
        

        self.view.isUserInteractionEnabled = true
        let swipe = UIPanGestureRecognizer.init(target: self, action: #selector(backPressed))
        self.view.addGestureRecognizer(swipe)
    }
    
    
    @objc @IBAction func backPressed(_sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selection = filteredData[indexPath.row]
        
        let defaults = UserDefaults.standard
        
        if let indexOf = Locations.cityNames.index(where: { $0 == "\(selection)" }) {
            //defaults.set(Locations.counties[indexOf], forKey: "location")
            defaults.set(true, forKey: "customLocation")
            let temp = Locations.counties[indexOf].replacingOccurrences(of: "\"", with: "")
            defaults.set(temp, forKey: "location")
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filteredData = Locations.cityNames.filter({( str : String) -> Bool in
            return str.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if 20 < filteredData.count {
                return 20
            }
            return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let str: String
        
        str = filteredData[indexPath.row].replacingOccurrences(of: "\"", with: "")
//        } else {
//            str = Locations.cityNames[indexPath.row]
//        }
        cell.textLabel?.text = str
        
        return cell
    }
}
//
//extension ChangeLocationVC: UISearchResultsUpdating {
//    // MARK: - UISearchResultsUpdating Delegate
////    func updateSearchResults(for searchController: UISearchController) {
////        // TODO
////    }
//}

