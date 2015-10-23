//
//  ViewController.swift
//  Tween
//
//  Created by Bryan Irace on 10/22/15.
//  Copyright © 2015 Bryan Irace. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol ViewControllerDelegate {
    func viewControllerDidSelectCameraButton(viewController: ViewController)
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    struct Constants {
        static let defaultIntermediateImageCount: Double = 0
        static let maxIntermediateImageCount: Double = 2
    }
    
    let delegate: ViewControllerDelegate
    
    lazy var collectionView: UICollectionView = {
        let frame = self.view.frame
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(frame.width, frame.width)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundView = {
            let label = UILabel(frame: frame)
            label.text = "Choose a photo from your library to get started"
            label.font = UIFont.systemFontOfSize(26)
            label.numberOfLines = 0
            label.lineBreakMode = .ByWordWrapping
            label.textAlignment = .Center
            label.textColor = .whiteColor()
            
            let shimmerView = FBShimmeringView(frame: frame)
            shimmerView.contentView = label
            shimmerView.shimmering = true
            
            return shimmerView
            }()
        collectionView.registerClass(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        
        return collectionView
    }()
    
    lazy var actionButton: UIBarButtonItem = {
        let actionButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "actionButtonTapped")
        actionButton.enabled = false
        return actionButton
    }()
    
    lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.enabled = false
        stepper.maximumValue = Constants.maxIntermediateImageCount
        stepper.addTarget(self, action: "stepperChanged", forControlEvents: .ValueChanged)
        return stepper
    }()
    
    var imageSet: ImageSet? {
        didSet {
            stepper.enabled = imageSet != nil
            actionButton.enabled = imageSet != nil
            
            collectionView.reloadData()
        }
    }
    
    // MARK: - Initialization
    
    init(delegate: ViewControllerDelegate) {
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(delegate:")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("Use init(delegate:")
    }
    
    // MARK: - Public methods
    
    func imageSetWasReset(imageSet: ImageSet) {
        self.imageSet = imageSet
        
        self.stepper.value = Constants.defaultIntermediateImageCount
        
        self.collectionView.reloadData()
    }

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "cameraButtonTapped"),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: stepper),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            actionButton
        ]
    }
    
    // MARK: - Actions
    
    func cameraButtonTapped() {
        delegate.viewControllerDidSelectCameraButton(self)
    }
    
    func stepperChanged() {
        imageSet?.intermediateCount = Int(stepper.value)
    }
    
    func actionButtonTapped() {
        guard let imageSet = imageSet else { return }
        
        presentViewController(UIActivityViewController(activityItems: imageSet.images, applicationActivities: []),
            animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let imageSet = imageSet else { return 0 }
        
        return imageSet.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCell.reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        
        if let imageSet = imageSet {
            cell.photo = imageSet[indexPath.row]
        }

        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let imageSet = imageSet else { return CGSizeZero }
        
        let image = imageSet[indexPath.row]
        
        return CGSizeMake(view.frame.width, (view.frame.width * image.size.height)/image.size.width)
    }
}
