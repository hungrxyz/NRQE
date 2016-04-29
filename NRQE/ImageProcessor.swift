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

	func mergeImages(image: UIImage) -> UIImage {
		
		UIGraphicsBeginImageContext(image.size)
		
		let areaSize = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
		image.drawInRect(areaSize)
		overlay.drawInRect(areaSize)
		
		backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return backgroundImage
	}
	
	func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
		if let error = error {
			print(error)
		} else {
			print("Saved")
		}
	}
}
