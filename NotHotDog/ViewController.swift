//
//  ViewController.swift
//  NotHotDog
//
//  Created by Amandeep Singh on 19/03/18.
//  Copyright © 2018 Amandeep Singh. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagedisplay: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedimage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            imagedisplay.image = userPickedimage
            
            imagePicker.dismiss(animated: true, completion: nil)
            
            guard let ciimage = CIImage(image : userPickedimage) else {
                fatalError("Could'nt convert to CIImage")
            }
            detect(image: ciimage)
        }
        
    }
    
    func detect(image : CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Loading CoreML model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("VNCoreMLRequest Failed")
            }
            
            if let firstResult = results.first{
                print("\(firstResult.identifier)!")
                DispatchQueue.main.async {
                    self.navigationItem.title = String(firstResult.identifier)
                }
                
            }
        }
        
        let handler = VNImageRequestHandler(ciImage : image)
        
        do{
            try handler.perform([request])
            
        }catch{
            print(error)
        }
        
        
    }
    
    
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    
}


