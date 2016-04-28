//
//  GettyimagesAPI.swift
//  NewsReader
//
//  Created by Sasha Minikin on 4/28/16.
//  Copyright © 2016 Sasha Prokhorenko. All rights reserved.
//

import Foundation

enum PhotoResult {
  case Success(PhotoModel)
  case Failure(ErrorType)
}

private let baseURLString = "https://api.gettyimages.com/v3/search/images?fields=title%2Cthumb&sort_order=best&page_size=1&phrase="

class GettyimagesAPI {
  
  class func getPhotoURL(searchPhrase searchPhrase: String) -> NSURL {
    
   let optimizedString =  searchPhrase.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    let url = NSURL(string: baseURLString + optimizedString!)
    return url!
  }
  
  private class func photoFromJSONObject (json: [String : AnyObject]) -> PhotoModel? {
    
    guard let
      photoURLString = json["uri"] as? String,
      // We need to convert photoURLString from Gettyimages to conform Apple API
      photoURLStringEncoded = photoURLString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()),
      articleURL = NSURL(string: photoURLStringEncoded) else {
        
        // Don't have enough information to construct a Photo
        return nil
    }
  
    return PhotoModel(articleURL: articleURL)
  }
  
  class func getPhotoFromJSONData(data: NSData) -> PhotoResult {
    
    do {
      
      let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
      
      guard let jsonDictionary = jsonObject as? [NSObject:AnyObject],
        resultCount = jsonDictionary["result_count"] as? Int where resultCount != 0 else {
          // The JSON structure doesn't match our expectations
          return .Failure(ApiError.NoDataToProceed)
      }
      
       guard let  photos = jsonDictionary["images"] as? [[String:AnyObject]],
        photoArray = photos[0]["display_sizes"]?[0] as? [String:AnyObject] else {
          return .Failure(ApiError.InvalidJSONData)
      }
          
      guard let finalPhoto = photoFromJSONObject(photoArray) else {
        return .Failure(ApiError.InvalidJSONData)
      }
      
      if finalPhoto.articleURL.absoluteString == "" && photoArray.count > 0 {
        // We weren't able to parse any of the articlesA.
        // Maybe the JSON format for photos has changed.
        return .Failure(ApiError.InvalidJSONData)
      }
      
      return .Success(finalPhoto)
    }
    catch let error {
      return .Failure(error)
    }
  }
  
}
