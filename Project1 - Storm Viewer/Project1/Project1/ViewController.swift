//
//  ViewController.swift
//  Project1
//
//  Created by Oliwier Kasprzak on 22/09/2022.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var dictionary = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(suggest))
        
        performSelector(inBackground: #selector(loadPictures), with: nil)
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "dictionary") as? Data,
           let savedScore = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                dictionary = try jsonDecoder.decode([String: Int].self, from: savedData)
                pictures = try jsonDecoder.decode([String].self, from: savedScore)
                
                
            } catch {
                print("failed to load")
            }
            
        }
        
        
    }
    
    // How many rows should appear in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    // What each row should look like
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Viewed \(dictionary[pictures[indexPath.row]]!) times"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. try loading the vc
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            // 2. set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            vc.title = "Picture \(indexPath.row + 1) of \(pictures.count)"
            
            // 3. push it on the navigation controller
            navigationController?.pushViewController(vc, animated: true)
            
            dictionary[pictures[indexPath.row]]! += 1
            save()
            tableView.reloadData()
            
        }
    }
    
    @objc func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load!
                pictures.append(item)
                dictionary[item] = 0
            }
        }
        pictures.sort()
    }
    
    @objc func suggest() {
        let shareLink = "Try it: https://github.com/Cellomaster87/Storm-Viewer-"
        
        let vc = UIActivityViewController(activityItems: [shareLink], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(dictionary),
           let savedScore = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "dictionary")
            defaults.set(savedScore, forKey: "pictures")
        } else {
            print("Failed to save.")
        }
    }
}

