//
//  UIImage+Crop.swift
//  Tween
//
//  Created by Bryan Irace on 10/22/15.
//  Copyright © 2015 Bryan Irace. All rights reserved.
//

import UIKit

extension UIImage {
    func crop(rect: CGRect) -> UIImage {
        return UIImage(CGImage: CGImageCreateWithImageInRect(self.CGImage, rect)!, scale: 0, orientation: self.imageOrientation)
    }
}
