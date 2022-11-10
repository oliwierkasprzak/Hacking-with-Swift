//
//  DetailViewController.swift
//  Project1
//
//  Created by Oliwier Kasprzak on 23/09/2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    
    var usedImage = 0
    
    var allImages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "This is picture \(usedImage) out of \(allImages)"
     
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(popUp))
        
       
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
            assert(selectedImage == nil, "No selected images.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    @objc func popUp(){
        let ac = UIAlertController(title: "Read Me", message: "If you enjoyed my app, go tell your friends about it, as The Weeknd would say", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(ac, animated: true)
    }
}
