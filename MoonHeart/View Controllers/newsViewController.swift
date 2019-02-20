//
//  newsViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 1/1/19.
//  Copyright © 2019 Iwan Siauw. All rights reserved.
//

import UIKit
import Alamofire
//import AlamoFireImage

class newsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var news = [News]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        as! newsTableViewCell
        
        let value = news[indexPath.row]
        let imageRef = value.urlToImage
        
        loadImage(imageRef) { (image) -> Void in
            if let image = image{
                                
                DispatchQueue.main.async {
                    cell.images.image = image
                }
                self.news[indexPath.row].newsImage = image
            }
        }
        
        cell.date.text = value.publishedAt
        cell.title.text = value.title
        cell.sourceName.text = value.details.name
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNewsApi()
    
    }
    
    func getNewsApi(){
        
        let newsUrl = "https://newsapi.org/v2/top-headlines?country=id&apiKey=bb8f275491f44ee38e3cfef33a5ca4fb"
        
        guard let url = URL(string: newsUrl) else { return }
        
        AF.request(url)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                guard let json = response.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    print("Error: \(response.result.error!)")
                    return
                }
                
                guard let articles = json["articles"] as? [Any] else {
                    print("Could not get todo title from JSON")
                    return
                }
                
                for jsonArray in articles {
                    
                    print(jsonArray)
                    self.news.append(News(dictionary: jsonArray as! [String : Any]))
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }
        
    }
    
    func loadImage(_ urlString: String, handler:@escaping (_ image:UIImage?)-> Void)
    {
        guard let imageURL = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { (data, _, _) in
            if let data = data{
                handler(UIImage(data: data))
            }
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "newsDetails"{
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let value = news[indexPath.row]
                
                let destination = segue.destination as! newsDetailsViewController
                
                destination.titles = value.description
                destination.details = value.content
                
                if let image = value.newsImage {
                    destination.image = image
                }
                
            }
        }
    }
}






