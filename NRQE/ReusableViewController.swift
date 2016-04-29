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
	
	var rootViewController: ViewController!
	let texts = ["Import Nike Running image", "Import background image", "Export image"]
	var index: Int!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		textLabel.text = texts[index - 1]
		
		importButton.layer.borderColor = UIColor.whiteColor().CGColor
		nextButton.layer.borderColor = UIColor.whiteColor().CGColor
		
		nextButton.hidden = true

		if let rootVC = (UIApplication.sharedApplication().delegate as! AppDelegate).window!.rootViewController as? ViewController {
			rootViewController = rootVC
		}
	}
	
	@IBAction func importButtonTapped(sender: AnyObject) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .PhotoLibrary
		imagePickerController.delegate = self
		
		rootViewController.presentViewController(imagePickerController, animated: true, completion: nil)
	}
	
	@IBAction func nextButtonTapped(sender: AnyObject) {
		rootViewController.nextPage(index)
	}
	
	func showImage() {
		importButton.hidden = true
		imageView.hidden = false
		nextButton.hidden = false
	}
}

extension ReusableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		
		switch index {
		case 1:
			imageView.image = ImageProcessor.sharedInstance.transform(image)
			showImage()
		case 2:
			imageView.image = ImageProcessor.sharedInstance.mergeImages(image)
			showImage()
		default:
			print("Wierd index")
		}
		rootViewController.resetPages(index)
		rootViewController.dismissViewControllerAnimated(true, completion: nil)
	}
}
