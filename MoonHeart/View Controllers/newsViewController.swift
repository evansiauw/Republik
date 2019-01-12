//
//  newsViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 1/1/19.
//  Copyright © 2019 Iwan Siauw. All rights reserved.
//

import UIKit
import Alamofire

class newsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var news = [News]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        as! newsTableViewCell
        
        let value = news[indexPath.row]
        let imageRef = value.urlToImage
        
        //cell.images.image =
        cell.date.text = value.publishedAt
        cell.title.text = value.title
        
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newsUrl: String = "https://newsapi.org/v2/top-headlines?country=id&apiKey=bb8f275491f44ee38e3cfef33a5ca4fb"
        
        AF.request(newsUrl)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                print(response.value!)
      
                
//                // make sure we got some JSON since that's what we expect
//                guard let json = response.value as? [String: Any] else {
//                    print("didn't get todo object as JSON from API")
//                    print("Error: \(response.result.error!)")
//                    return
//                }
//
//                // get and print the title
//                guard let articles = json["articles"] as? [Any] else {
//                    print("Could not get todo title from JSON")
//                    return
//                }
//
//                print(articles)

//                self.news = articles.compactMap({News(Dictionary: $0 as! [String : Any])})
//
//                print("number of arrays in news are: \(self.news.count)")

        }

    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueFeedDetails"{
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let value = feeds[indexPath.row]
                
                let destination = segue.destination as! feedCellDetailsViewController
                
                destination.image = value.realImage
                destination.feedTitleDetails = value.title
                destination.feedDetail = value.details
                
            }
            
        }
        
    } */
    

  

}
