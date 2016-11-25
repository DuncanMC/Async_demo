//
//  DownloadManager.swift
//  Async_demo
//
//  Created by Duncan Champney on 11/25/16.
//  Copyright © 2016 Duncan Champney. All rights reserved.
//

import Foundation


typealias DataClosure = (Data?, Error?) -> Void
/**
 This class is a trivial example of a class that handles async processing. It offers a single function, `downloadFileAtURL()`
 */
class DownloadManager: NSObject {
  
  static var downloadManager = DownloadManager()
  
  /**
   This function demonstrates handling an async task.
   - Parameter url The url to download
   - Parameter completion: A completion handler to execute once the download is finished
 */
  
  func downloadFileAtURL(_ url: URL, completion: @escaping DataClosure) {
    
    let dataTask = URLSession.shared.dataTask(with: url) {
      data, response, error in
      //Perform the completion handler on the main thread
      DispatchQueue.main.async {
        //Call the copmletion handler that was passed to us
        completion(data, error)
      }
    }
    dataTask.resume()
    //When we get here the data task will NOT have completed yet!
  }
}
