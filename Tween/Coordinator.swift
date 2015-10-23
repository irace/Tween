//
//  Coordinator.swift
//  Tween
//
//  Created by Bryan Irace on 10/23/15.
//  Copyright © 2015 Bryan Irace. All rights reserved.
//

import Foundation

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ViewControllerDelegate {
    lazy var viewController: ViewController = {
        return ViewController(delegate: self)
    }()
    
    lazy var rootViewController: UIViewController = {
        let navigationController = UINavigationController(rootViewController: self.viewController)
        navigationController.toolbarHidden = false
        navigationController.navigationBarHidden = true
        navigationController.toolbar.tintColor = .whiteColor()
        navigationController.toolbar.barTintColor = .blackColor()
        return navigationController
    }()
    
    // MARK: - ViewControllerDelegate
    
    func viewControllerDidSelectCameraButton(viewController: ViewController) {
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        
        viewController.presentViewController(picker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let cropRect = (info[UIImagePickerControllerCropRect] as! NSValue).CGRectValue()

        picker.dismissViewControllerAnimated(true) {
            self.viewController.imageSetWasReset(ImageSet(originalImage: originalImage, editedImage: editedImage, cropRect: cropRect))
        }
    }
}
