//
//  ViewController.swift
//  Week1
//
//  Created by chayim on 07/11/2015.
//  Copyright © 2015 a2wd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var filteredImage: UIImage!
    @IBOutlet var imageView: UIImageView!
    
    //Filter button & menu
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var filterMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        //One-time filterMenu setup
        filterMenu.translatesAutoresizingMaskIntoConstraints = false
        filterMenu.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onShare(sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    @IBAction func onNewClick(sender: UIButton) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: {
            action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: {
            action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onFilter(sender: UIButton) {
        if(sender.selected) {
            sender.selected = false
            hideFilterMenu()
        }
        else {
            sender.selected = true
            showFilterMenu()
        }
    }
    
    func hideFilterMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.filterMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.filterMenu.removeFromSuperview()
                }
        }
        
    }
    
    func showFilterMenu() {
        view.addSubview(filterMenu)
        
        //Add menu constraints
        let bottomConstraint = filterMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = filterMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = filterMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = filterMenu.heightAnchor.constraintEqualToConstant(44)
        
        //Activate menu constraints
        NSLayoutConstraint.activateConstraints([
            bottomConstraint,
            leftConstraint,
            rightConstraint,
            heightConstraint
            ])
        view.layoutIfNeeded()
        
        filterMenu.alpha = 0
        UIView.animateWithDuration(0.4, animations: {
            self.filterMenu.alpha = 1
        })
    }

}

