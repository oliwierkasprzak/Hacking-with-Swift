//
//  ViewController.swift
//  Project2
//
//  Created by Oliwier Kasprzak on 25/09/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionAsked = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy",
                      "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3 .layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion(action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show score" , style: .plain, target: self, action: #selector(showScore))
    }

   @objc func askQuestion(action: UIAlertAction!){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        questionAsked += 1
        title = countries[correctAnswer].uppercased()
        
        
       
        
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            
        }else{
            title = "Wrong"
            
            
        }
        if questionAsked < 5 {
            let ac = UIAlertController(title: title, message: "This is the flag of \(countries[sender.tag]) Your score is: \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            
            
        }else {
            let final = UIAlertController(title: nil, message: "Its over! Your final score is \(score) out of \(questionAsked)", preferredStyle: .alert)
            final.addAction(UIAlertAction(title: "Game over", style: .default))
            present(final, animated: true)
                    }
    }
    @objc func showScore(){
        let ac = UIAlertController(title: "SCORE", message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default))
        present(ac, animated: true)
    }
}

