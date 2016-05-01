//
//  ImageProcessor.swift
//  NRQE
//
//  Created by Zel Marko on 4/29/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation
import UIKit

class ImageProcessor {
	
	static let sharedInstance = ImageProcessor()

	var overlay: UIImage!
	var backgroundImage: UIImage!
	
	func transform(image: UIImage) -> UIImage {
		
		let context = CIContext(options: nil)
		let ciImage = CIImage(CGImage: image.CGImage!)
		
		let filter = CIFilter(name: "CIMaskToAlpha")!
		filter.setDefaults()
		filter.setValue(ciImage, forKey: kCIInputImageKey)
		
		let result = filter.outputImage!
		
		let cgImage = context.createCGImage(result, fromRect: result.extent)
		let transformedImage = UIImage(CGImage: cgImage)
		overlay = transformedImage
		
		return transformedImage
	}

	func mergeImages() -> UIImage {
		
		UIGraphicsBeginImageContext(backgroundImage.size)
		
		let areaSize = CGRect(x: 0, y: 0, width: backgroundImage.size.width, height: backgroundImage.size.height)
		backgroundImage.drawInRect(areaSize)
		overlay.drawInRect(areaSize)
		
		let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return mergedImage
	}
	
	func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
		if let error = error {
			print(error)
		} else {
			print("Saved")
		}
	}
}
