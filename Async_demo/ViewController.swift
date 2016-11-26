//
//  ViewController.swift
//  Async_demo
//
//  Created by Duncan Champney on 11/25/16.
//  Copyright © 2016 Duncan Champney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  //MARK: - IBOulets
  @IBOutlet weak var downloadButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  //MARK: - properties

  ///This property is set to true when a download is in progress. It uses a `didSet` method to start an activity indicator view during downloading and disable the download button.
  
  var downloadingInProgress: Bool = false {
    didSet {
      if downloadingInProgress {
        activityIndicator.startAnimating()
      } else {
        activityIndicator.stopAnimating()
      }
      downloadButton.isEnabled = !downloadingInProgress
    }
  }
 
  //MARK: - overridden instance methods

  //MARK: - custom instance methods

  func rotateAndRemoveImage() {
    activityIndicator.stopAnimating()

    UIView.animate(withDuration: 1.0,
                   delay: 1.0,
                   options: [],
                   animations: {
                    
      //Rotate the image a half-turn
      self.imageView.transform = self.imageView.transform.rotated(by: CGFloat(Float.pi))
    },
                   completion: {
                    completed in
                    //Once the rotation is comlete, fade the image away 
                    //And reset everthing in case the user taps download again.
                    UIView.animate(withDuration: 0.3,
                                   animations: {
                                    self.imageView.alpha = 0.0
                    },
                                   completion: {
                                    completed in
                                    //Once the fade is complete:
                                    
                                    self.downloadingInProgress = false
                                    
                                    //Get rid of the image
                                    self.imageView.image = nil
                                    
                                    //Set the alpha back to 1.0
                                    self.imageView.alpha = 1.0
                                    
                                    //Cancel the rotation
                                    self.imageView.transform = CGAffineTransform.identity
                    })
    })
  }
  
  //MARK: - IBActions

  @IBAction func handledDownloadButton(_ sender: UIButton) {
    
    downloadingInProgress = true
    guard let url = URL(string: "https://s3.amazonaws.com/snork/WareTo+logo.png") else {
      print("Unable to create URL")
      return
    }
    //Ask the download manager to download an image and return it as Data
    DownloadManager.downloadManager.downloadFileAtURL(
      url,
      
      //This is the code to execute when the data is available
      //(or the network request fails)
      completion: {
        [weak self] //Create a capture group for self to avoid a retain cycle.
        data, error in
        
        //If self is not nil, unwrap it as "strongSelf". If self IS nil, bail out.
        guard let strongSelf = self else {
          return
        }
        
        if let error = error {
          print("download failed. message = \(error.localizedDescription)")
          strongSelf.downloadingInProgress = false
          return
        }
        
        guard let data = data else {
          print("Data is nil!")
          strongSelf.downloadingInProgress = false
          return
        }
        
        guard let image = UIImage(data: data) else {
          print("Unable to load image from data")
          strongSelf.downloadingInProgress = false
          return
        }
        
        //Install the newly downloaded image into the image view.
        strongSelf.imageView.image = image
        
        //Afer a pause, rotate the image, fade it out, and remove it.
        strongSelf.rotateAndRemoveImage();
      }
    )
  }

}

