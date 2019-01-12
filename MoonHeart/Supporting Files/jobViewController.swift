//
//  jobViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 12/20/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class jobViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var db: Firestore!
    
    var Selected = false
    var citySelected = "jobFeeds"
    var selectedRowIndex = -1

    var feeds = [jobFeed]()
    var filteredFeeds = [jobFeed]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        loadData()
        checkForUpdates()
        searchViewProperties()
    }
    
    
    func loadData(){
        
        db.collection(citySelected).order(by: "time", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
               
                self.feeds = querySnapshot!.documents.compactMap({jobFeed(Dictionary: $0.data())})
                }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            }

    }
    
    func checkForUpdates(){
        
        db.collection(citySelected).whereField("time", isGreaterThan: Date()).addSnapshotListener { (querysnapshot, error) in
            
            guard let snapshot = querysnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach{ diff in
                
                if (diff.type == .added) {
                    self.feeds.insert(jobFeed(Dictionary: diff.document.data())!, at: 0)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                if (diff.type == .modified) {
                    print("Modified city: \(diff.document.data())")
                }
                
                if (diff.type == .removed) {
                    print("Removed city: \(diff.document.data())")
                }
                
                
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredFeeds.count
        }
        
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! jobFeedTableViewCell
        
        let value: jobFeed
        
        if isFiltering() {
            value = filteredFeeds[indexPath.row]
        } else {
            value = feeds[indexPath.row]
        }
        
        cell.title.text = value.title
        cell.subtitle.text = "\(value.location) - \(value.subtitle)"
        cell.value.text = "$\(value.value)"
        cell.desc.text = value.desc
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex {
            return 200
        }
        return 79
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! jobFeedTableViewCell
        
        if selectedRowIndex == indexPath.row {
            selectedRowIndex = -1
            cell.title.textAlignment = .left
        } else {
            selectedRowIndex = indexPath.row
            cell.title.textAlignment = .center
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    
    func searchViewProperties(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["All", "Location", "Job Type"]
        searchController.searchBar.delegate = self
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredFeeds = feeds.filter({( feed : jobFeed) -> Bool in
            
            if scope == "Job Type"{
                return feed.subtitle.lowercased().contains(searchText.lowercased())
            } else if scope == "Location" {
                return feed.location.lowercased().contains(searchText.lowercased())
            } else {
                return feed.title.lowercased().contains(searchText.lowercased())

            }
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
}

extension jobViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)    }
}

extension jobViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
    
    /*guard let title = sender.currentTitle, let selectedButton = city(rawValue: title) else {
     return
     }
     
     switch selectedButton {
     case .ny:
     selectCity.setTitle(selectedButton.rawValue, for: .normal)
     
     
     case .bos:
     selectCity.setTitle(selectedButton.rawValue, for: .normal)
     
     case .pa:
     selectCity.setTitle(selectedButton.rawValue, for: .normal)
     
     case .la:
     selectCity.setTitle(selectedButton.rawValue, for: .normal)
     
     case .sf:
     selectCity.setTitle(selectedButton.rawValue, for: .normal)
     }
     enum city: String {
     case ny = "New York"
     case bos = "Boston"
     case pa = "Philadelphia"
     case la = "Los Angeles"
     case sf = "San Francisco"
     
     }
     */
   
    //    @IBAction func selectCity(_ sender: UIButton) {
    //      showOrHideMenu()
    //    }
    //
    //    @IBAction func selectionPressed(_ sender: UIButton) {
    //
    //        if let title = sender.currentTitle {
    //            selectCity.setTitle(title, for: .normal)
    //            citySelected = title
    //            showOrHideMenu()
    //        }
    //    }
    //
    //    func showOrHideMenu(){
    //
    //        cityOptions.forEach { (button) in
    //
    //            if(Selected == false){
    //                button.isHidden = false;
    //            } else {
    //                button.isHidden = true;
    //            }
    //        }
    //
    //        Selected = !Selected
    //    }
