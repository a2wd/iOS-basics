//A selection of filters
class filters {
    
    //Red Channel
    static func redChannel(image: RGBAImage, adjustment: Double) -> RGBAImage {
        return filters.adjustChannels(image, redChannel: adjustment, blueChannel: 0, greenChannel: 0)
    }
    //Blue Channel
    static func blueChannel(image: RGBAImage, adjustment: Double) -> RGBAImage {
        return filters.adjustChannels(image, redChannel: 0, blueChannel: adjustment, greenChannel: 0)
    }
    //Green Channel
    static func greenChannel(image: RGBAImage, adjustment: Double) -> RGBAImage {
        return filters.adjustChannels(image, redChannel: 0, blueChannel: 0, greenChannel: adjustment)
    }
    
    //Brightness
    static func brightness(image: RGBAImage, diff: Double) -> RGBAImage {
        return filters.adjustChannels(image, redChannel: diff, blueChannel: diff, greenChannel: diff)
    }
    
    //Channel adjustment main function
    static func adjustChannels(image: RGBAImage, redChannel: Double, blueChannel: Double, greenChannel: Double) -> RGBAImage {
        
        for z in 0..<image.pixels.count {
            var pixel = image.pixels[z]
            
            pixel.red = UInt8(max(0,min(255,(Double(pixel.red) + Double(pixel.red) * redChannel))))
            pixel.blue = UInt8(max(0,min(255,(Double(pixel.blue) + Double(pixel.blue) * blueChannel))))
            pixel.green = UInt8(max(0,min(255,(Double(pixel.green) + Double(pixel.green) * greenChannel))))
            
            image.pixels[z] = pixel
        }
        
        //Adjust pixels relative to average
        return image
    }
    
    //Greyscale conversion
    static func greyscale(image: RGBAImage) -> RGBAImage {
        
        for z in 0..<image.pixels.count {
            var pixel = image.pixels[z]
            
            let avgCol = UInt8((Int(pixel.red) + Int(pixel.blue) + Int(pixel.green)) / 3)
            
            pixel.red = avgCol
            pixel.green = avgCol
            pixel.blue = avgCol
            
            image.pixels[z] = pixel
        }
        
        return image
    }
}

//A dictionary of filter presets
let filterPresets = [
    
    "lightBW": { (image: RGBAImage, ratio: Double) -> RGBAImage in
        return filters.brightness(filters.greyscale(image), diff: (0.5 * ratio))
    },
    
    "darkBW": { (image: RGBAImage, ratio: Double) -> RGBAImage in
        return filters.brightness(filters.greyscale(image), diff: (-0.5 * ratio))
    },
    
    "onlyBlue": { (image: RGBAImage, ratio: Double) -> RGBAImage in
        return filters.redChannel(filters.greenChannel(image, adjustment: (ratio * -1)), adjustment: (-1 * ratio))
    },
    
    "warmer": { (image: RGBAImage, ratio: Double) -> RGBAImage in
        var manipulatedImage = filters.greenChannel(image, adjustment: (ratio * -0.2))
        manipulatedImage = filters.blueChannel(manipulatedImage, adjustment: (ratio * -0.5))
        manipulatedImage = filters.redChannel(manipulatedImage, adjustment: (ratio * 0.5))
        
        return manipulatedImage
    },
    
    "colder": { (image: RGBAImage, ratio: Double) -> RGBAImage in
        var manipulatedImage = filters.greenChannel(image, adjustment: (ratio * 0.1))
        manipulatedImage = filters.blueChannel(manipulatedImage, adjustment: (ratio * 0.5))
        manipulatedImage = filters.redChannel(manipulatedImage, adjustment: (ratio * -0.5))
        
        return manipulatedImage
    }
]

//An image processing class which can take an array of filter presets by name to apply to an image
class ImageProcess {
    var image: RGBAImage
    
    init(image: RGBAImage) {
        self.image = image
    }
    
    func applyFilters(filterList: [String], ratio: Double) -> RGBAImage {
        for f in filterList {
            image = filterPresets[f]!(image, ratio)
        }
        return image
    }
}



