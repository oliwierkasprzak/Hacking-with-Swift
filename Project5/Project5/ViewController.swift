//
//  ViewController.swift
//  Project5
//
//  Created by Oliwier Kasprzak on 03/10/2022.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    var currentWord: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
      
        
        let defaults = UserDefaults.standard
                if let presentWord = defaults.object(forKey: "presentWord") as? String,
                    let savedWords = defaults.object(forKey: "savedWords") as? [String] {
                    title = presentWord
                    currentWord = presentWord
                    usedWords = savedWords
                    print("Loaded old game!")
                } else {
                    startGame()
                }
    }
    
  @objc func startGame(){
        
      title = allWords.randomElement()
              currentWord = title
              usedWords.removeAll(keepingCapacity: true)
              save()
              tableView.reloadData()
              print("Started new game!")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
    present(ac, animated: true)
    }
    
    func submit(_ answer: String){
        let lowerAnswer = answer.lowercased()
       // var errorType: String
    //    var errorMessage: String
        
        if isPossible(word: lowerAnswer){
            if isOriginal(word: lowerAnswer){
                if isReal(word: lowerAnswer){
                    usedWords.insert(lowerAnswer, at: 0)
                    save()
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    showErrorMessage(errorType: "Word isnt recognized", errorMessage: "Word isnt real or has less than 3 letters")
                }
            } else{
                showErrorMessage(errorType: "Word already used", errorMessage: "The word has already been used")
                
            }
        }else{
            showErrorMessage(errorType: "Word not possible", errorMessage: "You cant make words without the letters inside \(title?.lowercased())")
           
            
        }
        
       
        
    }
    func isPossible(word: String) -> Bool {
        guard var temporaryWord = title?.lowercased() else {return false}
        
        for letter in word {
            if let position = temporaryWord.firstIndex(of: letter){
                temporaryWord.remove(at: position)} else {
                    return false
            }
        }
        
        return true
    }
    func isOriginal(word: String) -> Bool{
        if word != title {
            return !usedWords.contains(word)
        } else {
            return false
        }
        
    }
    func isReal(word: String) -> Bool{
        if word.count < 3 { return false }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(errorType: String, errorMessage: String) {
      
        let ac = UIAlertController(title: errorType, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
    }
    
    func save() {
            let defaults = UserDefaults.standard
            defaults.set(currentWord, forKey: "presentWord")
            defaults.set(usedWords, forKey: "savedWords")
        }
    
}
