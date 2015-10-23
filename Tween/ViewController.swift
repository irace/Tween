//
//  ViewController.swift
//  Tween
//
//  Created by Bryan Irace on 10/22/15.
//  Copyright © 2015 Bryan Irace. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    struct Constants {
        static let defaultIntermediateImageCount: Double = 0
        static let maxIntermediateImageCount: Double = 2
    }
    
    lazy var collectionView: UICollectionView = {
        let frame = self.view.frame
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(frame.width, frame.width)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
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
        stepper.maximumValue = Constants.maxIntermediateImageCount
        stepper.addTarget(self, action: "stepperChanged", forControlEvents: .ValueChanged)
        return stepper
    }()
    
    var imageSet: ImageSet? {
        didSet {
            actionButton.enabled = imageSet != nil
            
            collectionView.reloadData()
        }
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
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func stepperChanged() {
        imageSet?.intermediateCount = Int(stepper.value)
    }
    
    func actionButtonTapped() {
        guard let imageSet = imageSet else { return }
        
        presentViewController(UIActivityViewController(activityItems: imageSet.images, applicationActivities: []),
            animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let cropRect = (info[UIImagePickerControllerCropRect] as! NSValue).CGRectValue()
        
        imageSet = ImageSet(originalImage: originalImage, editedImage: editedImage, cropRect: cropRect)
        
        picker.dismissViewControllerAnimated(true) {
            self.stepper.value = Constants.defaultIntermediateImageCount
            
            self.collectionView.reloadData()
        }
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
