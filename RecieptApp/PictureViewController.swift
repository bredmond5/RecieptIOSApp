//
//  PictureViewController.swift
//  
//
//  Created by Brice Redmond on 9/24/18.
//

import UIKit
import Anchors

class PictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    var pictureTaken: Bool = false
    
    var translation: CGPoint?
    var start: CGPoint?
    
    var textFound: String?
    
    @IBOutlet weak var topImageViewConstraint: NSLayoutConstraint!
    
    private lazy var layer: CALayer = {
        let layer = CALayer()
        layer.borderWidth = 2
        layer.borderColor = UIColor.green.cgColor
        layer.removeAllAnimations()
        imageView.layer.addSublayer(layer)
        return layer
    }()
    
    private let ocrService = OCRService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(!pictureTaken) {
            setUpPicker()
        }
    }
    
    @IBAction func retakePressed(_ sender: Any) {
        setUpPicker()
    }
    
    func setUpPicker() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("No image found")
            return
        }
        
//        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        imageView.image = image
        
        ocrService.delegate = self
        
        let gestRec = UIPanGestureRecognizer(target: self, action:#selector(panGesture(_:)))
        view.addGestureRecognizer(gestRec)
        
        pictureTaken = true
    }
    
    @IBAction func panGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        if(start != nil) {
            translation = gestureRecognizer.translation(in: imageView)
            let size = CGSize(width: translation!.x, height: translation!.y)
            
            
            let bounds = CGRect(x: start!.x, y: start!.y, width: size.width, height: size.height)
            layer.frame = bounds
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            start = touches.first?.location(in: imageView)
            let layerRect = CGRect(x: start!.x, y: start!.y, width: 0, height: 0)
            layer.frame = layerRect
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.childViewControllers[0] is GroupAmtViewController
        {
            let grpVC = segue.destination.childViewControllers[0] as! GroupAmtViewController
            grpVC.payments = textFound
            
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        print("Layer frame \(layer.frame)")
        
        print("Image view frame \(imageView.frame)")
        
        if let croppedImage = crop() {
            imageView.image = croppedImage
            ocrService.handle(image: croppedImage)

//            self.performSegue(withIdentifier: "PictureToGroups", sender: nil)
        }
    }
    
    private func crop() -> UIImage? {

        let imageFixed = imageView.image!

        let cropRect = CGRect(x: layer.frame.origin.y, y: layer.frame.origin.x, width: layer.frame.height, height: layer.frame.width)

        let viewWidth = imageView.frame.width
        let viewHeight = imageView.frame.height

        let imageViewScaleX = imageFixed.size.width / viewWidth
        let imageViewScaleY = imageFixed.size.height / viewHeight
        
        let cropZone = CGRect(x:cropRect.origin.x * imageViewScaleY,
                              y:cropRect.origin.y * imageViewScaleY,
                              width:cropRect.size.width * imageViewScaleY,
                              height:cropRect.size.height * imageViewScaleY)

        print("crop x: \(cropZone.origin.x), crop y: \(cropZone.origin.y)")
        print("crop width: \(cropZone.width), crop height \(cropZone.height)")
        
        guard let cutImageRef: CGImage = imageFixed.cgImage?.cropping(to:cropZone)
            else {
                return nil
        }


        let newImage = UIImage(cgImage: cutImageRef, scale: imageFixed.scale, orientation: UIImageOrientation.right)

        print("image width: \(newImage.size.width), image height \(newImage.size.height)")

        return newImage
    }
    
    func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
        
        let imageWidth = bounds.width
        let imageHeight = bounds.height
        
        // Begin with input rect.
        var rect = forRegionOfInterest
        
        // Reposition origin.
        rect.origin.x *= imageWidth
        rect.origin.x += bounds.origin.x
        rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y
        
        // Rescale normalized coordinates.
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight
        
        return rect
    }
}

extension PictureViewController: OCRServiceDelegate {
    func ocrService(_ service: OCRService, didDetect text: String) {
        textFound = text
    }
}

