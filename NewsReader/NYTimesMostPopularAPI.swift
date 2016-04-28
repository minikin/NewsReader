//
//  NYTimesMostPopularAPI.swift
//  NewsReader
//
//  Created by Sasha Minikin on 4/27/16.
//  Copyright © 2016 Sasha Prokhorenko. All rights reserved.
//
//  Abstract:
//  NYTimesMostPopularAPI class responsible for parsing JSON data

import Foundation

enum Method: String {
  case Offset = "20"
}

enum ArticleResult {
  case Success([ArticleModel])
  case Failure(ErrorType)
}

enum ApiError: ErrorType {
  case InvalidJSONData
  case UnexpectedError
  case NoDataToProceed
}

private let baseURLString = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1.json"
private let APIKey = "4afab778b3e7c77b97102126a85d6d5d:7:75112953"

class NYTimesMostPopularAPI {
  
  private class  func mostPopularURL(method method: Method, parameters: [String:String]?) -> NSURL {
    
    let components = NSURLComponents(string: baseURLString)!
    
    var queryItems = [NSURLQueryItem]()
    
    let baseParams = [
      "offset": method.rawValue,
      "api-key": APIKey ]
    
    for (key, value) in baseParams {
      let item = NSURLQueryItem(name: key, value: value)
      queryItems.append(item)
    }
    
    if let additionalParams = parameters {
      for (key, value) in additionalParams {
        let item = NSURLQueryItem(name: key, value: value)
        queryItems.append(item)
      }
    }
      
    components.queryItems = queryItems
    
    return components.URL!
  }
  
  
   class func recentArticleURL() -> NSURL {
    return mostPopularURL(method: .Offset, parameters:nil)
  }
  
  private class func articleFromJSONObject(json: [String : AnyObject]) -> ArticleModel? {
    
    guard let 
      articleID = json["id"] as? Double,
      title = json["title"] as? String,
      abstract = json["abstract"] as? String,
      publishedDate = json["published_date"] as? String,
      articleURLString = json["url"] as? String,
      articleURL = NSURL(string: articleURLString) else {
        // Don't have enough information to construct a Photo
        return nil
    }
    
    return ArticleModel(articleID: articleID, title: title, abstract: abstract, articleURL: articleURL, publishedDate: publishedDate)
    
  }
  
  class func articlesFromJSONData(data: NSData) -> ArticleResult {
    
    do {
      
      let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
      
      guard let
        jsonDictionary = jsonObject as? [NSObject:AnyObject],
        articlesArray = jsonDictionary["results"] as? [[String:AnyObject]] else {
          
          // The JSON structure doesn't match our expectations
          return .Failure(ApiError.InvalidJSONData)
      }
      
      var finalArticles = [ArticleModel]()
      
      for articleJSON in articlesArray {
        if let article = articleFromJSONObject(articleJSON){
          finalArticles.append(article)
        } else {
          print("Can't append data")
        }
      }
    
      if finalArticles.count == 0 && articlesArray.count > 0 {
        // We weren't able to parse any of the articlesA.
        // Maybe the JSON format for photos has changed.
        return .Failure(ApiError.InvalidJSONData)
      }
      return .Success(finalArticles)
    }
    catch let error {
      return .Failure(error)
    }
  }
  
}


