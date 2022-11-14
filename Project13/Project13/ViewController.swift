//
//  ViewController.swift
//  Project13
//
//  Created by Oliwier Kasprzak on 22/10/2022.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var intensity: UISlider!
    @IBOutlet var imageView: UIImageView!
    var currentImage: UIImage!
    
    var context: CIContext!
    var currentFilter: CIFilter!
      
    @IBOutlet var filterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Instafilter"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        imageView.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, animations: {
            self.imageView.alpha = 1
            
        })
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
                
        applyProcessing()
    }
    
    @IBAction func changeFilter(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Change filters", message: nil, preferredStyle: .actionSheet)
           ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
           present(ac, animated: true)
        
    }
    func setFilter(action: UIAlertAction) {
            guard currentImage != nil else { return }
            
            currentFilter = CIFilter(name: action.title!)
        filterButton.setTitle(action.title, for: .normal)
            
            let beginImage = CIImage(image: currentImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            
            applyProcessing()
        }
    
    @IBAction func save(_ sender: Any) {
            
            guard let image = imageView.image else {
                let ac = UIAlertController(title: "No image", message: "There is no image to save", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default))
                present(ac, animated: true)
                
                return
                
            }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @IBAction func intesityChange(_ sender: Any) {
        applyProcessing()
    }
    
    func applyProcessing() {
            let inputKeys = currentFilter.inputKeys
            
            if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
            if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
            if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
            if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
            
            if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
                let processedImage = UIImage(cgImage: cgimg)
                self.imageView.image = processedImage
            }
        }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
               // we got back an error!
               let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
               ac.addAction(UIAlertAction(title: "OK", style: .default))
               present(ac, animated: true)
           } else {
               let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
               ac.addAction(UIAlertAction(title: "OK", style: .default))
               present(ac, animated: true)
           }
    }
}

