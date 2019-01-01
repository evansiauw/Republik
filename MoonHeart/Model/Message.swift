//
//  Message.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 11/10/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import MessageKit

struct Member {
    let name: String
    let color: UIColor
}

struct Message {
    let member: Member
    let text: String
    let messageId: String
}

extension Message: MessageType {
    var sender: Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}
