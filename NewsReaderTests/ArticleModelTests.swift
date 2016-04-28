//
//  ArticleModelTests.swift
//  NewsReader
//
//  Created by Sasha Minikin on 4/28/16.
//  Copyright © 2016 Sasha Prokhorenko. All rights reserved.
//

import XCTest
@testable import NewsReader

class ArticleModelTests: XCTestCase {
  
  // MARK: - Constants & parameters
  
  static let articleID = 201666
  static let title = "Sunset on the Moon"
  static let abstract = "Read more books"
  static let articleURL = NSURL(string: "https://twitter.com")
  static let publishedDate = "28.04.2016"
  
  // MARK: - Properties
  
  var article : ArticleModel!
    
    override func setUp() {
        super.setUp()
      
      article = ArticleModel(articleID: ArticleModelTests.articleID,
                             title: ArticleModelTests.title,
                             abstract: ArticleModelTests.abstract,
                             articleURL: ArticleModelTests.articleURL!,
                             publishedDate: ArticleModelTests.publishedDate)
      

    }
    
    override func tearDown() {
      article = nil
        super.tearDown()
    }
  
  
  // MARK: - Tests

  func testArticleIsInitialicedFromProperData() {
    XCTAssertNotNil(article, "An Article must be returned from a  proper data.")
  }
  
  func testArticleIsntInitialicedFromEmptyData(){
    
    let emptyData = ArticleModel(articleID: -1,
                                 title: "",
                                 abstract: "",
                                 articleURL: ArticleModelTests.articleURL!,
                                 publishedDate: "")
    
    XCTAssertNil(emptyData, "Empty object is invalid")
  }
  
  func testArticleArticleIDAssignement() {
    XCTAssertEqual(article.articleID, ArticleModelTests.articleID, "articleID should be assigned to the value.")
  }
  
  func testArticleTitleAssignement() {
    XCTAssertEqual(article.title, ArticleModelTests.title, "title should be assigned to the value.")
  }
  
  func testArticleAbstractAssignement() {
    XCTAssertEqual(article.abstract, ArticleModelTests.abstract, "abstract should be assigned to the value.")
  }
  
  func testArticleArticleURLAssignement() {
    XCTAssertEqual(article.articleURL, ArticleModelTests.articleURL, "articleURL should be assigned to the value.")
  }
  
  func testArticlePublishedDateAssignement() {
    XCTAssertEqual(article.publishedDate, ArticleModelTests.publishedDate, "articleID should be assigned to the value.")
  }
  
  
}
