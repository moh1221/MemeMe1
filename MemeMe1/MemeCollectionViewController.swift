//
//  MemeCollectionViewController.swift
//  MemeMe1
//
//  Created by BringMe on 11/2/15.
//  Copyright © 2015 moh. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    var memes: [Meme]!
    var applicationDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFlowLayout()
        updateMemes()
    }
    
    override func viewWillAppear(animated: Bool) {
        updateMemes()
        collectionView?.reloadData()
        super.viewWillAppear(true)
    }
    
    //set flow layout
    func setFlowLayout() {
        let space: CGFloat = 3.0
        let dimi: CGFloat = (self.view.frame.size.width - ( space * 2 )) / 3.0
        flowLayout.itemSize = CGSizeMake(dimi, dimi)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
    }
    
    func updateMemes() {
        //load memes from AppDelegate
        applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }

    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //get memes count for colleciton view
        return memes.count
    }
    
    //on collection view -> select display meme in details view
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        // Set the image
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    //move to Editor view to add new Memes
    @IBAction func AddEditorView(sender: UIBarButtonItem) {
        let memeEditorController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        self.presentViewController(memeEditorController, animated: true, completion: nil)
    }
}
