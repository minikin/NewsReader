//
//  NewsTableViewCell.swift
//  NewsReader
//
//  Created by Sasha Minikin on 4/27/16.
//  Copyright © 2016 Sasha Prokhorenko. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var newsImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    updateWithImage(nil)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    updateWithImage(nil)
  }
  
  func updateWithImage(image: UIImage?) {
    if let imageToDisplay = image {
      newsImage.image = imageToDisplay
    }
    else {
      newsImage.image = nil
    }
  }

}
