//
//  LoginViewModel.swift
//  Clima
//
//  Created by admin on 15/07/2022.
//  Copyright © 2022 AppSEHC. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine

enum StatusLogin {
    case Success
    case Failed
}

final class LoginViewModel {
    
    @Published var err : String?
    @Published var status: StatusLogin = StatusLogin.Failed
    @Published var login: String = ""
    @Published var password: String = ""
    
    private(set) lazy var isInputValid = Publishers.CombineLatest($login, $password)
        .map {$0.count > 2 && $1.count > 2 }
        .eraseToAnyPublisher()
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let e = error {
                self?.err = e.localizedDescription
                self?.status = .Failed
            } else {
                self?.status = .Success
            }
        }
    }
}

