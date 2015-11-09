//
//  MemeTableViewController.swift
//  MemeMe1
//
//  Created by BringMe on 11/3/15.
//  Copyright © 2015 moh. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    var applicationDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateMemes()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        updateMemes()
        tableView.reloadData()
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // The editor should be presented if there are no sent memes
        if memes.count == 0  {
            // No memes. Lets present the editor
            memeEditor()
        }
    }
    
    func updateMemes() {
        //load memes from AppDelegate
        applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //get memes count for table view
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        // Set the text and image
        cell.memeTextLabel?.text = "\(meme.topText). \(meme.bottomText)"
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    //on row select display meme in details view
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
        detailController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
        
    }

    //Adding delete option @ swap from right to left
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //remove memes from memes list
        memes.removeAtIndex(indexPath.row)
        
        //update memes @ appDelegate
        applicationDelegate.memes = memes
        //delete row from table view
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    
    
    //move to Editor view to add new Memes
    @IBAction func AddEditorView(sender: UIBarButtonItem) {
        memeEditor()
    }
    func memeEditor() {
        let memeEditorController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(memeEditorController, animated: true, completion: nil)
    }
    
}

