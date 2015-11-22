//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var filteredImage: UIImage?
    var originalImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var darkButton: UIButton!
    @IBOutlet var lightButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var coldButton: UIButton!
    @IBOutlet var warmButton: UIButton!
    @IBOutlet var filterButton: UIButton!
    
    @IBOutlet var blueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        originalLabel.hidden = true
        
        let imageTap = UILongPressGestureRecognizer()
        imageTap.numberOfTapsRequired = 0
        imageTap.numberOfTouchesRequired = 1
        imageTap.minimumPressDuration = 0
        imageTap.addTarget(self, action: "imageToggle:")
        imageView.addGestureRecognizer(imageTap)
        
//        //Add filtericon to filterbuttons
//        let filterIcon = RGBAImage(image: UIImage(named:"filtericon")!)
//        let darkIcon = filterPresets["darkBW"]!(filterIcon!).toUIImage()
//        let lightIcon = filterPresets["lightBW"]!(filterIcon!).toUIImage()
//        let blueIcon = filterPresets["onlyBlue"]!(filterIcon!).toUIImage()
//        let warmIcon = filterPresets["warmer"]!(filterIcon!).toUIImage()
//        let coldIcon = filterPresets["colder"]!(filterIcon!).toUIImage()
//        
//        darkButton.setImage(darkIcon, forState: .Normal)
//        darkButton.setImage(darkIcon, forState: .Selected)
//        lightButton.setImage(lightIcon, forState: .Normal)
//        lightButton.setImage(lightIcon, forState: .Selected)
//        blueButton.setImage(blueIcon, forState: .Normal)
//        blueButton.setImage(blueIcon, forState: .Selected)
//        warmButton.setImage(warmIcon, forState: .Normal)
//        warmButton.setImage(warmIcon, forState: .Selected)
//        coldButton.setImage(coldIcon, forState: .Normal)
//        coldButton.setImage(coldIcon, forState: .Selected)
//        
//        darkButton.contentHorizontalAlignment = .Fill
//        darkButton.contentVerticalAlignment = .Fill
//        lightButton.contentHorizontalAlignment = .Fill
//        lightButton.contentVerticalAlignment = .Fill
//        blueButton.contentHorizontalAlignment = .Fill
//        blueButton.contentVerticalAlignment = .Fill
//        warmButton.contentHorizontalAlignment = .Fill
//        warmButton.contentVerticalAlignment = .Fill
//        coldButton.contentHorizontalAlignment = .Fill
//        coldButton.contentVerticalAlignment = .Fill
//        
//        darkButton.imageView?.contentMode = .ScaleAspectFit
//        lightButton.imageView?.contentMode = .ScaleAspectFit
//        blueButton.imageView?.contentMode = .ScaleAspectFit
//        warmButton.imageView?.contentMode = .ScaleAspectFit
//        coldButton.imageView?.contentMode = .ScaleAspectFit
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
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
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            originalImage = nil
            filteredImage = nil
            hideSecondaryMenu()
            filterButton.selected = false
            toggleFilterButtons()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if sender.selected {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)

        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(88)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    @IBOutlet var originalLabel: UILabel!
    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    
    //Secondary menu filter actions
    @IBAction func LightFilter(sender: UIButton) {
        if sender.selected == true {
            filterOff()
            toggleFilterButtons()
            return
        }
        toggleFilterButtons()
        sender.selected = true
        
        filterOnCheck()
        filterHelper("lightBW")
    }

    @IBAction func DarkFilter(sender: UIButton) {
        if sender.selected == true {
            filterOff()
            toggleFilterButtons()
            return
        }
        toggleFilterButtons()
        sender.selected = true
        
        filterOnCheck()
        filterHelper("darkBW")
    }
    
    @IBAction func BlueFilter(sender: UIButton) {
        if sender.selected == true {
            filterOff()
            toggleFilterButtons()
            return
        }
        toggleFilterButtons()
        sender.selected = true
        
        filterOnCheck()
        filterHelper("onlyBlue")
    }
    
    @IBAction func WarmFilter(sender: UIButton) {
        if sender.selected == true {
            filterOff()
            toggleFilterButtons()
            return
        }
        toggleFilterButtons()
        sender.selected = true
        
        filterOnCheck()
        filterHelper("warmer")
    }
    
    @IBAction func ColdFilter(sender: UIButton) {
        if sender.selected == true {
            filterOff()
            toggleFilterButtons()
            return
        }
        toggleFilterButtons()
        sender.selected = true
        
        filterOnCheck()
        filterHelper("colder")
    }
    
    //Button state manager
    func toggleFilterButtons() {
        lightButton.selected = false
        darkButton.selected = false
        blueButton.selected = false
        warmButton.selected = false
        coldButton.selected = false
        compareButton.enabled = false
        compareButton.selected = false
    }
    
    //Filter helpers
    func filterOnCheck() {
        if originalImage != nil {
            imageView.image = originalImage
            originalImage = nil
        }
    }
    
    func filterOff() {
        if originalImage != nil {
            imageView.image = originalImage
            
            imageTransition(filteredImage!)
            originalImage = nil
            filteredImage = nil
        }
    }
    
    func filterHelper(filter: String) {
        originalImage = imageView.image
        let rgbaImage = RGBAImage(image: originalImage!)
        
        var imageToTransition = originalImage
        if filteredImage != nil {
            imageToTransition = filteredImage
        }
        
        //Process & swap original image for filtered image
        filteredImage = filterPresets[filter]!(rgbaImage!).toUIImage()
        imageView.image = filteredImage
        
        compareButton.enabled = true
        
        imageTransition(imageToTransition!)
    }
    
    func imageTransition(original: UIImage) {
        let originalImageView = UIImageView(image: original)
        self.view.addSubview(originalImageView)
        
        originalImageView.contentMode = .ScaleAspectFit
        originalImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let bottomConstraint = originalImageView.bottomAnchor.constraintEqualToAnchor(imageView.bottomAnchor)
        let leftConstraint = originalImageView.leftAnchor.constraintEqualToAnchor(imageView.leftAnchor)
        let rightConstraint = originalImageView.rightAnchor.constraintEqualToAnchor(imageView.rightAnchor)
        let topConstraint = originalImageView.topAnchor.constraintEqualToAnchor(imageView.topAnchor)

        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, topConstraint])
        
        view.layoutIfNeeded()
        
        originalImageView.alpha = 1
        UIView.animateWithDuration(1) {
            originalImageView.alpha = 0
        }
    }
    
    func restoreHelper() {
        imageView.image = originalImage
    }
    
    //Compare button
    @IBAction func compareToggle(sender: UIButton) {
        if originalImage == nil {
            return
        }
        
        if sender.selected {
            originalLabel.hidden = true
            sender.selected = false
            imageView.image = filteredImage
        }
        else {
            originalLabel.hidden = false
            sender.selected = true
            imageView.image = originalImage
        }
    }
    
    //Image view compare toggle
    func imageToggle(sender: UILongPressGestureRecognizer) {
        if originalImage == nil {
            return
        }
        
        if sender.state == .Began {
            restoreHelper()
            originalLabel.hidden = false
        }
        if sender.state == .Ended {
            imageView.image = filteredImage
            originalLabel.hidden = true
        }
    }
}

