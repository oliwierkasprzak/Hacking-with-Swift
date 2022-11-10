//
//  DetailViewController.swift
//  Project4
//
//  Created by Oliwier Kasprzak on 28/09/2022.
//

import UIKit

class DetailViewController: UIViewController {
   
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
  

    override func viewDidLoad() {
       
        
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage{
         
            imageView.image = UIImage(named: imageToLoad)
            
        }
        }
    
    @objc func shareTapped(){
        guard let image = imageView.image?.jpegData(compressionQuality: 0.9) else {
        print("Image not found")
            return
        }
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
        
    }

   

}
