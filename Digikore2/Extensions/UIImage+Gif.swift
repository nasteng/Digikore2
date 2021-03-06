//
//  Gif.swift
//  SwiftGif
//
//  Created by Arne Bahlo on 07.06.14.
//  Copyright (c) 2014 Arne Bahlo. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

extension UIImageView {

    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

}

extension UIImage {

    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
          .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        delay = delayObject as? Double ?? 0

        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }

        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!

            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }

    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
            }()

        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)

        return animation
    }

    func createImagesForGif(with rect: (width: Int, height: Int), range: CountableRange<Int>, row: Int = 0) -> [UIImage]? {
        let cropX = rect.width
        let cropY = rect.height
        var images:[ UIImage] = []
        
        for i in range {
            guard let croppedImage = self.cropping(to: CGRect(x: cropX * i, y: row * cropY, width: cropX, height: cropY)) else {
                return nil
            }
            
            images.append(croppedImage)
        }
        
        return  images
    }
    
    class func createGifURL(from croppedImages: [UIImage], loop: Bool = true, delay: CGFloat = 0.25, completion: ((_ isFinish: Bool, _ url: URL?) -> Void)){
        
        let charaImages: [CGImage] = croppedImages.map{$0.cgImage!}
        
        guard let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(NSUUID().uuidString).gif") else {
            print("url化失敗")
            return completion(false, nil)
        }
        
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypeGIF, charaImages.count, nil) else {
            print("CGImageDestinationの作成に失敗")
            return completion(false, nil)
        }
        
        let property: [String: AnyObject] = [
            kCGImagePropertyGIFLoopCount as String: 0 as NSNumber,
            kCGImagePropertyGIFHasGlobalColorMap as String: false as NSNumber
        ]
        
        CGImageDestinationSetProperties(destination, property as CFDictionary)
        
        let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: delay]]
        for image in charaImages {
            CGImageDestinationAddImage(destination, image, frameProperties as CFDictionary)
        }
        
        if CGImageDestinationFinalize(destination) {
            print("GIF生成が成功")
            completion(true, url)
        } else {
            print("GIF生成に失敗")
            return completion(false, nil)
        }
    }
    
    class func createGIfImage(from images: [UIImage]) -> UIImage? {
        var image: UIImage?
        createGifURL(from: images) { (canCreate, url) in
            if let url = url, canCreate {
                image = UIImage.gif(url: url.absoluteString)
            }
        }
        return image
    }
}
