//
//  UITextField+Publisher.swift
//  Clima
//
//  Created by admin on 18/07/2022.
//  Copyright © 2022 AppSEHC. All rights reserved.
//

import Foundation
import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .compactMap(\.text)
            .eraseToAnyPublisher()
    }
}
