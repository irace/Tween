//
//  ViewController.swift
//  Tween
//
//  Created by Bryan Irace on 10/22/15.
//  Copyright © 2015 Bryan Irace. All rights reserved.
//

import UIKit

func generateIntermediatesFromOriginalImage(original: UIImage, cropRect: CGRect, intermediateCount: Int = 0) -> [UIImage] {
    return []
}

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
    
    init(originalImage: UIImage, editedImage: UIImage, cropRect: CGRect) {
        self.originalImage = originalImage
        self.editedImage = editedImage
        self.cropRect = cropRect
        
        generateIntermediates()
    }
    
    mutating func generateIntermediates() {
        intermediateImages = generateIntermediatesFromOriginalImage(originalImage, cropRect: cropRect, intermediateCount: intermediateCount)
    }
    
    subscript(index: Int) -> UIImage {
        return images[index]
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
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
    
    lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 2
        stepper.addTarget(self, action: "stepperChanged", forControlEvents: .ValueChanged)
        return stepper
    }()
    
    var imageSet: ImageSet?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "cameraButtonTapped"),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: stepper),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "actionButtonTapped")
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
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageSet = ImageSet(originalImage: info[UIImagePickerControllerOriginalImage] as! UIImage,
            editedImage: info[UIImagePickerControllerEditedImage] as! UIImage,
            cropRect: (info[UIImagePickerControllerCropRect] as! NSValue).CGRectValue())
        
        picker.dismissViewControllerAnimated(true) {
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
}
