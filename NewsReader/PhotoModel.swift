//
//  PhotoModel.swift
//  NewsReader
//
//  Created by Sasha Minikin on 4/28/16.
//  Copyright © 2016 Sasha Prokhorenko. All rights reserved.
//

import UIKit

class PhotoModel {
  
  // MARK: Properties
  
  let articleURL: NSURL
  var image: UIImage?
  
  // MARK: Initialization
  
  init?(articleURL:NSURL){
    
    self.articleURL = articleURL
    
    // Initialization should fail if there is no articleURL
    if articleURL.absoluteString.isEmpty {
      return nil
    }
  }
  

}



