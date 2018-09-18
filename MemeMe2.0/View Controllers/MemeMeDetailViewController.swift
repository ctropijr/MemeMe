//
//  MemeMeDetailViewController.swift
//  imagePickerPractice
//
//  Created by Christopher Tropiano on 9/13/18.
//  Copyright © 2018 Christopher Tropiano. All rights reserved.
//

import UIKit

class MemeMeDetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = meme.memedImage
        topLabel.text = meme.topText
        bottomLabel.text = meme.bottomText
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
