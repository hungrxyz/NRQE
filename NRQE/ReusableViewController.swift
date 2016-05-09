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
	@IBOutlet weak var shareButton: UIButton!
	
	var rootViewController: ViewController!
	let texts = ["Import Nike Running image", "Import background image", "Export image"]
	var index: Int!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		refreshMergedImage()
		
		textLabel.text = texts[index - 1]
		
		importButton.layer.borderColor = UIColor.whiteColor().CGColor
		nextButton.layer.borderColor = UIColor.whiteColor().CGColor
		shareButton.layer.borderColor = UIColor.whiteColor().CGColor
		
		nextButton.hidden = true

		if let rootVC = (UIApplication.sharedApplication().delegate as! AppDelegate).window!.rootViewController as? ViewController {
			rootViewController = rootVC
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		refreshMergedImage()
	}
	
	func refreshMergedImage() {
		if index == 3 {
			imageView.image = ImageProcessor.sharedInstance.mergeImages()
			showImage()
			importButton.hidden = true
			nextButton.hidden = true
			shareButton.hidden = false
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
	
	@IBAction func shareButtonTapped(sender: AnyObject) {
		let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
		rootViewController.presentViewController(activityController, animated: true, completion: nil)
	}
	
	func showImage() {
		importButton.layer.borderColor = UIColor.clearColor().CGColor
		importButton.setImage(nil, forState: .Normal)
		
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
			ImageProcessor.sharedInstance.backgroundImage = image
			imageView.image = image
			showImage()
		default:
			print("Wierd index")
		}
		rootViewController.resetPages(index)
		rootViewController.dismissViewControllerAnimated(true, completion: nil)
	}
}
