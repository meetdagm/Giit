//
//  Gist.swift
//  Giit
//
//  Created by Dagmawi Nadew-Assefa on 5/26/18.
//  Copyright © 2018 Sason. All rights reserved.
//

import Foundation
import SwiftyJSON


class Gists{
    var id: String?
    var description: String?
    var ownerLogin: String?
    var ownerAvatarURL: String?
    var url: String?
    
    required init?(json: [String:Any]) {
        print("in required init with option Line 21")
        guard let description = json["description"] as? String,
            let id = json["id"] as? String,
            let url = json["url"] as? String,
            let owner = json["owner"] as? [String: Any] else {return nil}
        guard let login = owner["login"] as? String, let avatarURL = owner["avatar_url"] as? String else {return nil}
        
        self.description = description
        self.id = id
        self.ownerLogin = login
        self.ownerAvatarURL = avatarURL
        self.url = url
    }
    
    required init() {}
}
