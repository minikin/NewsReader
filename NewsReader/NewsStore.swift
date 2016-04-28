//
//  NewsStore.swift
//  NewsReader
//
//  Created by Sasha Minikin on 4/27/16.
//  Copyright © 2016 Sasha Prokhorenko. All rights reserved.
//

import UIKit

private let apiKey = "n6aj642c2jb8nu8zbr48nqkf"

enum ImageResult {
  case Success(UIImage)
  case Failure(ErrorType)
}

enum PhotoError: ErrorType {
  case ImageCreationError
}

class NewsStore {
  
  let session: NSURLSession = {
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    return NSURLSession(configuration: config)
  }()
  
  
  // MARK: - Get Articles
  
  func processRecentArticlesRequest(data data: NSData?, error: NSError?) -> ArticleResult {
    guard let jsonData = data else {
      return .Failure(error!)
    }
    return NYTimesMostPopularAPI.articlesFromJSONData(jsonData)
  }
  
  func fetchRecentArticles(completion completion: (ArticleResult) -> Void) {
    
    let url = NYTimesMostPopularAPI.recentArticleURL()
    let request = NSURLRequest(URL: url)
    let task = session.dataTaskWithRequest(request, completionHandler: {
      (data, response, error) -> Void in
      
      let result = self.processRecentArticlesRequest(data: data, error: error)
      completion(result)
    })
    task.resume()
  }
  
  
  // MARK: - Get photo
  
  func processPhotoRequest(data data: NSData?, error: NSError?) -> PhotoResult {
    guard let jsonData = data else {
      return .Failure(error!)
    }
    return  GettyimagesAPI.getPhotoFromJSONData(jsonData)
  }
  
  
  func fetchPhoto(searchPhrase searchPhrase: String, completion: (PhotoResult) -> Void) {
    
    let url = GettyimagesAPI.getPhotoURL(searchPhrase: searchPhrase)
    
    let headers = [
      "Api-Key": apiKey,
      "cache-control": "no-cache"
    ]
    
    let request = NSMutableURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 10.0)
    request.HTTPMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    let task = session.dataTaskWithRequest(request, completionHandler: {
      (data, response, error) -> Void in
      
      let result = self.processPhotoRequest(data: data, error: error)
      
      completion(result)
      
    })
    
    task.resume()
  }
  
  func processImageRequest(data data: NSData?, error: NSError?) -> ImageResult {
    
    guard let
      imageData = data,
      image = UIImage(data: imageData) else {
        
        // Couldn't create an image
        if data == nil {
          return .Failure(error!)
        }
        else {
          return .Failure(PhotoError.ImageCreationError)
        }
    }
    return .Success(image)
  }
  
  func fetchImageForPhoto(photo: PhotoModel, completion: (ImageResult) -> Void) {
    
    if let image = photo.image {
      completion(.Success(image))
      return
    }
    
    let photoURL = photo.articleURL
    let request = NSURLRequest(URL: photoURL)
    
    let task = session.dataTaskWithRequest(request) {
      (data, response, error) -> Void in
      
      let result = self.processImageRequest(data: data, error: error)
      
      if case let .Success(image) = result {
        photo.image = image
      }
      
      completion(result)
    }
    task.resume()
  }
 
}