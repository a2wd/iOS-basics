//
//  ViewController.swift
//  Week1
//
//  Created by chayim on 07/11/2015.
//  Copyright © 2015 a2wd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var filteredImage: UIImage!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageToggle: UIButton!
    
    @IBAction func onImageToggle(sender: UIButton) {
        if(imageToggle.selected) {
            let image = UIImage(named: "pipboy")!
            imageView.image = image
            imageToggle.selected = false
        }
        else {
            imageView.image = filteredImage
            imageToggle.selected = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up toggle
        imageToggle.setTitle("Show unfiltered image", forState: .Selected)
        
        // Do any additional setup after loading the view, typically from a nib.
        let image = UIImage(named: "pipboy")!
        
        //Manipulate pixels
        //
        let rgbaImage = RGBAImage(image: image)!

        
        var totalRed = 0
        var totalBlue = 0
        var totalGreen = 0
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                let pixel = rgbaImage.pixels[index]
        
                totalRed += Int(pixel.red)
                totalBlue += Int(pixel.blue)
                totalGreen += Int(pixel.green)
            }
        }
        
        let pixelCount = rgbaImage.width * rgbaImage.height
        
        let avgRed = totalRed/pixelCount
        let avgGreen = totalGreen/pixelCount
        let avgBlue = totalBlue/pixelCount
        let colSum = avgRed + avgGreen + avgBlue
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let redDelta = Int(pixel.red) - avgRed
                let greenDelta = Int(pixel.green) - avgGreen
                let blueDelta = Int(pixel.blue) - avgBlue
                
                var offset = 10
                
                if(Int(pixel.red) + Int(pixel.blue) + Int(pixel.green) < colSum) {
                    offset = 1
                }
                
                pixel.red = UInt8(max(min(255,avgRed + offset * redDelta),0))
                pixel.green = UInt8(max(min(255,avgGreen + offset * greenDelta),0))
                pixel.blue = UInt8(max(min(255,avgBlue + offset * blueDelta),0))
                
                rgbaImage.pixels[index] = pixel
            }
        }
        
        filteredImage = rgbaImage.toUIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

