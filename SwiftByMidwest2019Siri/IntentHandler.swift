//
//  IntentHandler.swift
//  SwiftByMidwest2019Siri
//
//  Created by mrJacob on 4/4/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import Intents
import SwiftByMidwest2019Framework

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        if intent is TalkQueryIntent {
            return TalkQueryIntentHandler()
        }
        return self
    }
}
