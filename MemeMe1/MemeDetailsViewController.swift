//
//  MemeDetailsViewController.swift
//  MemeMe1
//
//  Created by BringMe on 11/2/15.
//  Copyright © 2015 moh. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailsViewController: UIViewController {
    
    @IBOutlet weak var DetailsImageView: UIImageView!
    @IBOutlet weak var EditButton: UIBarButtonItem!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Add Edit button with action to Edit selected memes
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "EditMeme:")
        //Hide bottom tabBars
        self.tabBarController?.tabBar.hidden = true
        //set image of selected memes
        self.DetailsImageView.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    @IBAction func EditMeme(sender: UIBarButtonItem) {
        //Move to Editor view to edit selected memes
        let memeEditorController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        memeEditorController.meme = meme
        presentViewController(memeEditorController, animated: true, completion: nil)
        
        //remove the current view to get back to Tableview
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
