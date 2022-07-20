//
//  LoginViewController.swift
//  Clima
//
//  Created by admin on 15/07/2022.
//  Copyright © 2022 AppSEHC. All rights reserved.
//

import UIKit
import FirebaseAuth
import Combine

class LoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorTextField: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    
    private var viewmodel = LoginViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        setUpBinding()
    }
    
    private func setUpBinding() {
        viewmodel.$err.sink { [weak self] error in
            if let e = error {
                self?.errorTextField.text = e
                print("Error in setUpbinding \(e)")
            }
        }.store(in: &cancellables)
        
        viewmodel.$status.sink { [weak self] state in
            switch state {
            case .Failed:
                print("Failed Status in Combine Login")
            case .Success:
                self?.performSegue(withIdentifier: K.loginSeque, sender: self)
            }
        }.store(in: &cancellables)
        
        emailTextField.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self]  value in
                self?.viewmodel.login = value
            }
            .store(in: &cancellables)
        
        passwordTextField.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self]  value in
                self?.viewmodel.password = value
            }
            .store(in: &cancellables)
        
        viewmodel.isInputValid.sink { [weak self] valid in
            if valid {
                self?.loginButton.isEnabled = true
            } else {
                self?.loginButton.isEnabled = false
            }
        }.store(in: &cancellables)
    }

    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            viewmodel.login(email: email, password: password)
        }
    }
}
