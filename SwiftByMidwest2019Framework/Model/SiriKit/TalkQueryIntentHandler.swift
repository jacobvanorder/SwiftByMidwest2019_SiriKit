//
//  TalkQueryIntentHandler.swift
//  SwiftByMidwest2019Framework
//
//  Created by mrJacob on 4/5/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import Foundation
import Intents

public class TalkQueryIntentHandler: NSObject, TalkQueryIntentHandling {
    let sxmw = Conference.swiftByMidwest2019()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    //Should I handle this?
    public func confirm(intent: TalkQueryIntent, completion: @escaping (TalkQueryIntentResponse) -> Void) {
        if sxmw.isOver(at: Date()) {
            completion(TalkQueryIntentResponse(code: .over, userActivity: .none))
        } else {
            completion(TalkQueryIntentResponse(code: .ready, userActivity: .none))
        }
    }
    
    //Cool, what should I do?
    public func handle(intent: TalkQueryIntent, completion: @escaping (TalkQueryIntentResponse) -> Void) {
        let eventualResponse: TalkQueryIntentResponse //Soon
        defer {
            completion(eventualResponse)
        }
        
        guard
            let speaker = sxmw.speaker(from: intent.speaker),
            let talk = sxmw.talk(from: intent.talk, for: speaker)
            else {
                eventualResponse = .init(code: .failure, userActivity: .none)
                return
        }
        
        let timeString = dateFormatter.string(from: talk.startingTime)
        eventualResponse = .success(speaker: speaker.fullName,
                                    subject: talk.subject,
                                    time: timeString)
    }
}
