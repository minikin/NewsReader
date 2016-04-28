//
//  ArticleModel.swift
//  NewsReader
//
//  Created by Sasha Minikin on 4/27/16.
//  Copyright © 2016 Sasha Prokhorenko. All rights reserved.
//

import UIKit

class ArticleModel {
  
  // MARK: Properties
  
  let articleID: Double
  let title: String
  let abstract: String
  let articleURL: NSURL
  let publishedDate :String
  
  // MARK: Initialization
  
  init?(articleID:Double, title:String, abstract: String, articleURL:NSURL, publishedDate:String) {
    self.articleID = articleID
    self.title = title
    self.abstract = abstract
    self.articleURL = articleURL
    self.publishedDate = publishedDate
    
    // Initialization should fail if there is no title
    if title.isEmpty {
      return nil
    }
  }
}

extension ArticleModel: Equatable {}

func == (lhs: ArticleModel, rhs: ArticleModel) -> Bool {
  // Two Articles are the same if they have the same articleID
  return lhs.articleID == rhs.articleID
}