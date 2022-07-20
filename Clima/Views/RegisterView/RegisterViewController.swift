//
//  RegisterViewController.swift
//  Clima
//
//  Created by admin on 15/07/2022.
//  Copyright © 2022 AppSEHC. All rights reserved.
//

import UIKit
import FirebaseAuth
import Combine

class RegisterViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorTextField: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    private var viewmodel = RegisterViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
        registerButton.isEnabled = false
    }
    
    private func setUpBinding() {
        viewmodel.$error.sink{ [weak self] error in
            if let e = error{
                self?.errorTextField.text = e
                print(e)
            }
        }.store(in: &cancellables)
        
        viewmodel.$status.sink { [weak self] status in
            switch status {
            case .Successed:
                self?.performSegue(withIdentifier: K.registerSeque, sender: self)
                print("Register Success")
            case .Failed:
                print("Register Failed ")
            }
        }.store(in: &cancellables)
        
        emailTextField.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
            self?.viewmodel.email = value
            }.store(in: &cancellables)
        
        passwordTextField.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.viewmodel.password = value
            }.store(in: &cancellables)
        
        viewmodel.isInputValid
            .receive(on: RunLoop.main)
            .sink { [weak self] isvalid in
            self?.registerButton.isEnabled = isvalid ? true : false
        }.store(in: &cancellables)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            viewmodel.register(email: email, password: password)
        }
    }
}
