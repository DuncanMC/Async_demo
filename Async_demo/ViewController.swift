//
//  ViewController.swift
//  Async_demo
//
//  Created by Duncan Champney on 11/25/16.
//  Copyright © 2016 Duncan Champney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var downloadButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  func rotateAndRemoveImage() {
    UIView.animate(withDuration: 1.0, delay: 0.5, options: [], animations: {
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
                                    
                                    //Re-enable the download button
                                    self.downloadButton.isEnabled = true
                                    
                                    //Get rid of the image
                                    self.imageView.image = nil
                                    
                                    //Set the alpha back to 1.0
                                    self.imageView.alpha = 1.0
                                    
                                    //Cancel the rotation
                                    self.imageView.transform = CGAffineTransform.identity
                    })
    })
  }
  
  @IBAction func handledDownloadButton(_ sender: UIButton) {
    
    
    guard let url = URL(string: "https://s3.amazonaws.com/snork/WareTo+logo.png") else {
      print("Unable to create URL")
      return
    }
    //Disable the download button while the download is running
    downloadButton.isEnabled = false

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
          strongSelf.downloadButton.isEnabled = true
          return
        }
        guard let data = data else {
          print("Data is nil!")
          strongSelf.downloadButton.isEnabled = true
          return
        }
        guard let image = UIImage(data: data) else {
          print("Unable to load image from data")
          strongSelf.downloadButton.isEnabled = true
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

