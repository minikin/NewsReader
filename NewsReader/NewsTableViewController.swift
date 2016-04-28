//
//  NewsTableViewController.swift
//  NewsReader
//
//  Created by Sasha Minikin on 4/27/16.
//  Copyright © 2016 Sasha Prokhorenko. All rights reserved.
//
//  Abstract:
//  NewsTableViewController is a root UITableViewController which is responsible for showing the overall data


import UIKit

class NewsTableViewController: UITableViewController {
  
  // MARK: - Properties
  let store = NewsStore()
  let articleDataSource = NewsDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = articleDataSource
    tableView.delegate = self
    
    store.fetchRecentArticles() {
      (articlesResult) -> Void in
      
      NSOperationQueue.mainQueue().addOperationWithBlock() {
        
        switch articlesResult {
        case let .Success(articles):
          self.articleDataSource.articles = articles
        case let .Failure(error):
          self.articleDataSource.articles.removeAll()
          print("Error fetching recent articles: \(error)")
        }
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
      }
    }
  }

  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
    let article = articleDataSource.articles[indexPath.row]
    
    let stringToProcess = article.title
    
    store.fetchPhoto(searchPhrase: findProperNoun(question: stringToProcess)) {
      (photoResult) -> Void in
      
      switch photoResult {
        
      case let .Success(photo):
 
        self.store.fetchImageForPhoto(photo, completion: { (result) -> Void in
        
          NSOperationQueue.mainQueue().addOperationWithBlock() {
            
            // The index path for the photo might have changed between the
            // time the request started and finished, so find the most
            // recent index path
            
            let photoIndex = self.articleDataSource.articles.indexOf(article)!
            let photoIndexPath = NSIndexPath(forRow: photoIndex, inSection: 0)
            
            // When the request finishes, only update the cell if it's still visible
            if let cell = self.tableView.cellForRowAtIndexPath(photoIndexPath) as? NewsTableViewCell {
              cell.updateWithImage(photo.image)
            } else {
              print("Cell out of screen")
            }
          }
        })
      case let .Failure(error):
        print("Error fetching photo: \(error)")
      }
    }
 
  }
  
  func findProperNoun(question question: String) -> String {

    var properNouns: [String] = []
    
    print("Title:", question)
    
    let options: NSLinguisticTaggerOptions = [.OmitWhitespace, .OmitPunctuation, .JoinNames, .OmitOther]
    let schemes = NSLinguisticTagger.availableTagSchemesForLanguage("en")
    let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
    
    tagger.string = question
    
    tagger.enumerateTagsInRange(NSMakeRange(0, question.characters.count), scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: options) { (tag, tokenRange, _, _) in
      
      let token = (question as NSString).substringWithRange(tokenRange)
      
      if [NSLinguisticTagNoun, NSLinguisticTagPersonalName, NSLinguisticTagPlaceName, NSLinguisticTagOrganizationName].contains(tag) {
        properNouns.append(token)
      } else {
        print("We don't need these word:", token)
      }
    }
    
    print("searchNoun:=>", properNouns.first!)
    
    return properNouns.first!
  }
  
  
}