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
	@IBOutlet weak var importButton: UIButton!
	@IBOutlet weak var transformButton: UIButton!
	@IBOutlet weak var exportButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func importTapped(sender: AnyObject) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .PhotoLibrary
		imagePickerController.delegate = self
		
		presentViewController(imagePickerController, animated: true, completion: nil)
	}
	
	@IBAction func transformTapped(sender: AnyObject) {
		if let image = imageView.image {
			transform(image)
		}
	}
	
	@IBAction func exportTapped(sender: AnyObject) {
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
	}
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		
		imageView.image = image
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}