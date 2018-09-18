//
//  TableViewController.swift
//  imagePickerPractice
//
//  Created by Christopher Tropiano on 8/30/18.
//  Copyright © 2018 Christopher Tropiano. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//RIGHT HERE SETTING UP THE APP DELEGATE AS A VARIABLE CHECK UDACITY EXPLANATION FOR HELP
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CellTableView = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellTableView

        let memeImage = self.memes[(indexPath as NSIndexPath).row]
        
        cell.tableImageView.image = memeImage.memedImage
        cell.tableLabel.text = "\(memeImage.topText) \(memeImage.bottomText)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = self.storyboard!.instantiateViewController(withIdentifier: "detail") as! MemeMeDetailViewController
       
        storyboard.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(storyboard, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func memeEditorPressed(_ sender: Any) {
        performSegue(withIdentifier: "tableMemeCreate", sender: self)
    }
    

    
}
