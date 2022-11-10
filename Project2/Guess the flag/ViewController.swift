//
//  ViewController.swift
//  Guess the flag
//
//  Created by Michele Galvagno on 19/02/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate{
    // MARK: - Outlets
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    // MARK: - Properties
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var askedQuestions = 0
    var highScore = 0
    var timeInterval = 86400

    // MARK: - Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            
            
            
            
        })
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                sender.transform = .identity
            }
            
        } else {
            title = "Wrong! That's the flag of \(self.countries[sender.tag].uppercased())"
            score -= 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                sender.transform = .identity
            }
        }
        
        if askedQuestions < 10 {
            let alertController = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(alertController, animated: true)
        } else {
            if score > highScore {
                highScore = score
                save()
                let highScoreAC = UIAlertController(title: "Game over! New High Score", message: "Your score is \(score).", preferredStyle: .alert)
                highScoreAC.addAction(UIAlertAction(title: "Start new game!", style: .default, handler: startNewGame))
                present(highScoreAC, animated: true)
            } else {
                let finalAlertController = UIAlertController(title: "Game over!", message: "Your score is \(score).", preferredStyle: .alert)
                finalAlertController.addAction(UIAlertAction(title: "Start new game!", style: .default, handler: startNewGame))
                finalAlertController.addAction(UIAlertAction(title: "Remind me tommrrow to play!", style: .default, handler: remindMe))
                present(finalAlertController, animated: true)
            }
        }
    }
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
      
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Allow notifications", style: .plain, target: self, action: #selector(registerLocal))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        let defaults = UserDefaults.standard
        
        if let highScore = defaults.value(forKey: "highScore") as? Int {
            self.highScore = highScore
            print("Successfully loaded high score! It is a \(highScore)!")
        } else {
            print("Failed to load high score or score not yet saved. High score is \(highScore)...")
            
        }
        
    }
    
    // MARK: - Methods
    // Show three random flag images on the screen
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        let uppercasedCountry = countries[correctAnswer].uppercased()
        // title = "Score: \(score) — Tap on: \(uppercasedCountry)'s flag." /* commented out to complete Project 3's challenge"
        title = uppercasedCountry
        askedQuestions += 1
    }
    
    // Start a new game
    func startNewGame(action: UIAlertAction) {
        
        score = 0
        askedQuestions = 0
        
        askQuestion()
        
    }
    func remindMe(action: UIAlertAction){
        scheduleLocal()
    }
    
    // Show the score on tapping the Bar Button Item
    @objc func showScore() {
        let scoreAlert = UIAlertController(title: "SCORE", message: nil, preferredStyle: .actionSheet)
        scoreAlert.addAction(UIAlertAction(title: "Your current score is \(score)!", style: .default, handler: nil))
        scoreAlert.addAction(UIAlertAction(title: "Your current highest score is \(highScore)!", style: .default))
        
        present(scoreAlert, animated: true)
    }
    
    func save() {
        let defaults = UserDefaults.standard
        
        do {
            defaults.set(highScore, forKey: "highScore")
            print("Successfully saved score!")
        } catch {
            print("Failed to save high score")
        }
    }
    @objc func registerLocal(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("Yay")
            } else {
                print("D'oh!")
                }
            }
        }
    
    func scheduleLocal(){
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Did you forget about us?"
        content.body = "Come back and guess some more flags!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
                //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data recieved: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                
                let ac = UIAlertController(title: "Great to have you back!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's play!", style: .default))
                present(ac, animated: true)
            case "show":
                let ac2 = UIAlertController(title: "Show more information", message: "If you'd like to give some more credit, please visit....", preferredStyle: .alert)
                ac2.addAction(UIAlertAction(title: "Sure!", style: .default))
                present(ac2, animated: true)
           
               
                
            default:
                break
            }
        }
        completionHandler()
        
    }
    func registerCategories(){
        let center =  UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let remindMe = UNNotificationAction(identifier: "remind", title: "Remind me tomorrow", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindMe], intentIdentifiers: [], options: [])

        
        
        center.setNotificationCategories([category])
        
    }
    
    }

