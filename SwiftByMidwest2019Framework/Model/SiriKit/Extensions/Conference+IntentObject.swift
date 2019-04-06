//
//  Conference+IntentObject.swift
//  SwiftByMidwest2019Framework
//
//  Created by mrJacob on 4/7/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import Foundation
import Intents

public extension Conference {
    func speaker(from intentObject: INObject?) -> Speaker? {
        guard
            let intentIdentifier = intentObject?.identifier,
            let intentId = Int(intentIdentifier) else { return .none }
        return self.speakers.filter({$0.id == intentId}).first
    }
    
    func talk(from intentObject: INObject?,
              for speaker: Speaker) -> Talk? {
        if
            let intentIdentifier = intentObject?.identifier,
            let intentId = Int(intentIdentifier),
            let intentTalk = talks.filter({$0.id == intentId}).first {
            return intentTalk
        } else if
            let firstTalk = talks.filter({speaker.talkIds.contains($0.id)}).first {
            return firstTalk
        }
        return .none
    }
}
