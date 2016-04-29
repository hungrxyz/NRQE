//
//  ReusableViewController.swift
//  NRQE
//
//  Created by Zel Marko on 4/29/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class ReusableViewController: UIViewController {
	
	@IBOutlet weak var textLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var importButton: UIButton!
	@IBOutlet weak var nextButton: UIButton!
	
	let texts = ["Import Nike Running image", "Import background image", "Export image"]
	var index: Int!
	var pages: [ReusableViewController]!
	var image: UIImage!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		textLabel.text = texts[index - 1]
		
		importButton.layer.borderColor = UIColor.whiteColor().CGColor
		nextButton.layer.borderColor = UIColor.whiteColor().CGColor
		
		nextButton.hidden = true
	}
	
	@IBAction func importButtonTapped(sender: AnyObject) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .PhotoLibrary
		imagePickerController.delegate = self
		
		presentViewController(imagePickerController, animated: true, completion: nil)
	}
	
	@IBAction func nextButtonTapped(sender: AnyObject) {
		print("Next")
	}
	
	func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
		if let error = error {
			print(error)
		} else {
			print("Saved")
		}
	}
	
	func transform(image: UIImage) {
		
		let context = CIContext(options: nil)
		let ciImage = CIImage(CGImage: image.CGImage!)
		
		let filter = CIFilter(name: "CIMaskToAlpha")!
		filter.setDefaults()
		filter.setValue(ciImage, forKey: kCIInputImageKey)
		
		let result = filter.outputImage!
		
		let cgImage = context.createCGImage(result, fromRect: result.extent)
		let transformedImage = UIImage(CGImage: cgImage)
		
		imageView.image = transformedImage
		importButton.hidden = true
		imageView.hidden = false
	}
	
	func mergeImages() {
		//		if let backgroundImage = backgroundImage, overlayImage = overlayImage {
		//			UIGraphicsBeginImageContext(backgroundImage.size)
		//
		//			let areaSize = CGRect(x: 0, y: 0, width: backgroundImage.size.width, height: backgroundImage.size.height)
		//			backgroundImage.drawInRect(areaSize)
		//			overlayImage.drawInRect(areaSize)
		//
		////			imageView.image = UIGraphicsGetImageFromCurrentImageContext()
		//			UIGraphicsEndImageContext()
		////			exportImageButton.hidden = false
		//		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		print(segue)
	}
}

extension ReusableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		
		switch index {
		case 0:
			print("Yes")
			transform(image)
		case 1:
			imageView.image = image
		default:
			print("Wierd index")
		}
		dismissViewControllerAnimated(true, completion: nil)
	}
}
