//
//  ImageSet.swift
//  Tween
//
//  Created by Bryan Irace on 10/22/15.
//  Copyright © 2015 Bryan Irace. All rights reserved.
//

import UIKit

struct ImageSet {
    let originalImage: UIImage
    let editedImage: UIImage
    let cropRect: CGRect
    
    var intermediateCount: Int = 0 {
        didSet {
            generateIntermediates()
        }
    }
    
    var intermediateImages: [UIImage] = []
    
    var images: [UIImage] {
        var images = [originalImage]
        images.appendContentsOf(intermediateImages)
        images.append(editedImage)
        
        return images
    }
    
    var count: Int {
        return images.count
    }
    
    // MARK: - Initialization
    
    init(originalImage: UIImage, editedImage: UIImage, cropRect: CGRect) {
        self.originalImage = originalImage
        self.editedImage = editedImage
        self.cropRect = cropRect
        
        generateIntermediates()
    }
    
    subscript(index: Int) -> UIImage {
        return images[index]
    }
    
    mutating func generateIntermediates() {
        self.intermediateImages = {
            if (intermediateCount == 0) {
                return []
            }
            else {
                let gapCount = (CGFloat(intermediateCount) + 1)
                
                let stepInsets = UIEdgeInsetsMake(
                    cropRect.origin.y/gapCount,
                    cropRect.origin.x/gapCount,
                    (originalImage.size.height - cropRect.origin.y - cropRect.size.height)/gapCount,
                    (originalImage.size.width - cropRect.origin.x - cropRect.size.width)/gapCount)
                
                return (1...intermediateCount)
                    .map { index in
                        let floatIndex = CGFloat(index)
                        
                        return CGRectMake(
                            cropRect.origin.x - (stepInsets.left * floatIndex),
                            cropRect.origin.y - (stepInsets.top * floatIndex),
                            cropRect.origin.x + cropRect.size.width + ((stepInsets.right + stepInsets.left) * floatIndex),
                            cropRect.origin.y + cropRect.size.height + ((stepInsets.top + stepInsets.bottom) * floatIndex))
                    }
                    .map(originalImage.crop)
                    .reverse()
            }
            }()
    }
}

