//
//  Meme.swift
//  MemeMe1
//
//  Created by BringMe on 9/20/15.
//  Copyright © 2015 moh. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String!
    var bottomText: String!
    var image: UIImage!
    var memedImage: UIImage!
    
    init(topText:String, bottomText:String, image:UIImage, memedImage:UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
    
}