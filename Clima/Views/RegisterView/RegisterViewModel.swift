//
//  RegisterViewModel.swift
//  Clima
//
//  Created by admin on 15/07/2022.
//  Copyright © 2022 AppSEHC. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine

enum SignInStatus {
    case Successed
    case Failed
}

class RegisterViewModel {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String?
    @Published var status: SignInStatus = SignInStatus.Failed
    
    private(set) lazy var isInputValid = Publishers.CombineLatest($email,$password)
        .map{ $0.count > 2 && $1.count > 2 }
        .eraseToAnyPublisher()
    
    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.error = e.localizedDescription
                self.status = .Failed
            } else {
                self.status = .Successed
            }
        }
    }
}
