//
//  ViewController.swift
//  Project4
//
//  Created by Oliwier Kasprzak on 27/09/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [String]()
    var contries_names = ["Spain", "Nigeria", "Ireland", "Germany", "Italy", "Poland", "Russia",
                          "Estonia", "Monaco", "France", "US", "UK"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items{
            if item.hasSuffix("2x.png"){
                countries.append(item)
                
            }
        }
        print(countries)
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        cell.textLabel?.text = contries_names[indexPath.row]
        cell.imageView?.image = UIImage(named: countries[indexPath.row])
        
        cell.backgroundColor = UIColor.white
               cell.layer.borderColor = UIColor.black.cgColor
               cell.layer.borderWidth = 1
               cell.layer.cornerRadius = 8
               cell.clipsToBounds = true
      
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = contries_names[indexPath.row]
            vc.selectedImage = countries[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
            
    }
 
}

