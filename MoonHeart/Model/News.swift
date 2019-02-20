//
//  News.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 1/21/19.
//  Copyright © 2019 Iwan Siauw. All rights reserved.
//

import UIKit

struct News {
    
    var author: String
    var content: String
    var description: String
    var publishedAt: String
    var details = Source(id: "", name: "")
    var title: String
    var url: String
    var urlToImage: String
    var newsImage: UIImage?
    
    init(dictionary: [String:Any]){
        
        author = dictionary["author"] as? String ?? ""
        content = dictionary["content"] as? String ?? ""
        description = dictionary["description"] as? String ?? ""
        publishedAt = dictionary["publishedAt"] as? String ?? ""
        title = dictionary["title"] as? String ?? ""
        url = dictionary["url"] as? String ?? ""
        urlToImage  = dictionary["urlToImage"] as? String ?? ""
        
        var source = dictionary["source"] as? [String:Any]
        details.id = source!["id"] as? String ?? ""
        details.name = source!["name"] as? String ?? "Unknown"
        
    }
}

struct Source {
    
    var id: String
    var name: String

    
}

