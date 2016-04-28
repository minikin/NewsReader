//
//  NewsDataSource.swift
//  NewsReader
//
//  Created by Sasha Minikin on 4/27/16.
//  Copyright © 2016 Sasha Prokhorenko. All rights reserved.
//

import UIKit

class NewsDataSource : NSObject, UITableViewDataSource {
  
  var articles : [ArticleModel] = []
  var photo : PhotoModel?
  
  // MARK: - Table view data source
  
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count ?? 0
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath) as! NewsTableViewCell
   
   // Configure the cell...
    
    let article = articles[indexPath.row]
    
    cell.title.text = article.title
    cell.updateWithImage(photo?.image)
   
    return cell
   }
}
