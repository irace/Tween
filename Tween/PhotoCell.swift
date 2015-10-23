//
//  PhotoCell.swift
//  Tween
//
//  Created by Bryan Irace on 10/22/15.
//  Copyright © 2015 Bryan Irace. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCell"
    
    var photo: UIImage? {
        didSet {
            imageView.image = photo
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.frame)
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(frame:)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        imageView.frame = bounds
    }
}
