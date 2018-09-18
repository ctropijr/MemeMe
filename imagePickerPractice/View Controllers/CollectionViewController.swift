//
//  CollectionViewController.swift
//  imagePickerPractice
//
//  Created by Christopher Tropiano on 8/30/18.
//  Copyright © 2018 Christopher Tropiano. All rights reserved.
//
import UIKit

class CollectionViewController: UICollectionViewController {
    
  
    var memes: [ViewController.Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //sets the layout of the collection view:
        
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        
        flowLayout.headerReferenceSize = CGSize(width: 0, height: 40)
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        //governs space between items within rows
        flowLayout.minimumInteritemSpacing = 8
        
        //space between rows/columns
        flowLayout.minimumLineSpacing = 8

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCell", for: indexPath) as! CollectionViewCell
        
        let memeImage = self.memes[(indexPath as NSIndexPath).row]
       
        cell.imageView?.image = memeImage.memedImage

        return cell

    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView!.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! MemeMeDetailViewController
        
        storyboard.meme = self.memes[indexPath.row]
        
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    @IBAction func editorPressed(_ sender: Any) {
        performSegue(withIdentifier: "collectionCreateMeme", sender: self)
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
