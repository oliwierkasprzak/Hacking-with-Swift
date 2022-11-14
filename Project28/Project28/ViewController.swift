//
//  ViewController.swift
//  Project28
//
//  Created by Oliwier Kasprzak on 08/11/2022.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    var password: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }


    @IBAction func authenticateTapped(_ sender: Any) {
        let contex = LAContext()
        var error: NSError?
        
        if contex.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identity yourself!"
            contex.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                        self?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self?.relockApp))
                    } else {
                        let authFailedAC = UIAlertController(title: "Authentication failed", message: "Please enter your password to unlock the secret content", preferredStyle: .alert)
                        authFailedAC.addTextField { (textField) in
                            textField.isSecureTextEntry = true
                            textField.placeholder = "Enter password"
                        }

                        let enterPwdAction = UIAlertAction(title: "Unlock", style: .default) { [weak self, weak authFailedAC] (_) in
                            guard let password = authFailedAC?.textFields?[0].text else { return }
                            
                            if password == self?.password {
                                self?.unlockSecretMessage()
                            } else {
                                let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .default))
                                self?.present(ac, animated: true)
                            }
                        }

                        authFailedAC.addAction(enterPwdAction)
                        self?.present(authFailedAC, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
        
       
    }
    @objc func relockApp() {
        secret.isHidden = true
        navigationItem.leftBarButtonItem = nil
       
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    @objc func unlockSecretMessage () {
        secret.isHidden = false
        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        navigationItem.leftBarButtonItem = nil
    }
}

