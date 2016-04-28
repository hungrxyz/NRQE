//
//  ViewController.swift
//  NRQE
//
//  Created by Zel Marko on 4/27/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var importNRImageButton: UIButton!
	@IBOutlet weak var importBackgroundImageButton: UIButton!
	@IBOutlet weak var mergeImagesButton: UIButton!
	@IBOutlet weak var exportImageButton: UIButton!
	
	var imagePickerController: UIImagePickerController!
	var backgroundImage: UIImage?
	var overlayImage: UIImage?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .PhotoLibrary
		imagePickerController.delegate = self
		
		importBackgroundImageButton.hidden = true
		mergeImagesButton.hidden = true
		exportImageButton.hidden = true
	}

	@IBAction func importNRImageButtonTapped(sender: AnyObject) {
		presentViewController(imagePickerController, animated: true, completion: nil)
	}
	
	@IBAction func importBackgroundImageButtonTapped(sender: AnyObject) {
		presentViewController(imagePickerController, animated: true, completion: nil)
	}
	
	@IBAction func mergeImagesButtonTapped(sender: AnyObject) {
		mergeImages()
	}
	
	@IBAction func exportImage(sender: AnyObject) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
			UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
		}
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
		
		overlayImage = transformedImage
		imageView.image = overlayImage
	}
	
	func mergeImages() {
		if let backgroundImage = backgroundImage, overlayImage = overlayImage {
			UIGraphicsBeginImageContext(backgroundImage.size)
			
			let areaSize = CGRect(x: 0, y: 0, width: backgroundImage.size.width, height: backgroundImage.size.height)
			backgroundImage.drawInRect(areaSize)
			overlayImage.drawInRect(areaSize)
			
			imageView.image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			exportImageButton.hidden = false
		}
	}
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		
		self.dismissViewControllerAnimated(true, completion: nil)
		
		if let _ = overlayImage {
			backgroundImage = image
			imageView.image = image
			mergeImagesButton.hidden = false
		} else {
			transform(image)
			importBackgroundImageButton.hidden = false
		}
	}
}