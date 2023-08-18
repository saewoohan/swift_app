//
//  Profile.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/25.
//

import Foundation


struct Profile {
    var email: String = ""
    var name: String = ""
    var message: String?
    var image: Data?
    var backgroundImage: Data?
    
    init(email: String, name: String, message: String?, image: Data?, backgroundImage: Data?) {
        self.email = email
        self.name = name
        self.message = message
        self.image = image
        self.backgroundImage = backgroundImage
    }
}
