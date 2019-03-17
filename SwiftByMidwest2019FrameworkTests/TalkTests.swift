//
//  TalkTests.swift
//  SwiftByMidwest2019FrameworkTests
//
//  Created by Jacob Van Order on 3/16/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import XCTest
@testable import SwiftByMidwest2019Framework

class TalkTests: XCTestCase {
    
    let talkEarlier: Talk = {
        let json = """
    {
      "title": "I’m a Coder: Codable & NSCoding",
      "startingTime": 577206900,
      "endingTime": 577210500,
      "id": 1,
      "speakerId": 1,
      "talkDescription": "Is Codable just a new name for NSCoding? Why do we have both? Can we use them together? You may also want to attend this talk if you’ve been meaning to support State Restoration.",
      "subject": "State restoration"
    }
""".data(using: .utf8)!
        return try! JSONDecoder().decode(Talk.self, from: json)
    }()
    
    let talkLater: Talk = {
        let json = """
    {
      "title": "Crows can understand symbols, can Apple's Vision framework?",
      "startingTime": 577231200,
      "endingTime": 577234800,
      "id": 5,
      "speakerId": 5,
      "talkDescription": "Details coming soon!",
      "subject": "Vision framework"
    }
""".data(using: .utf8)!
        return try! JSONDecoder().decode(Talk.self, from: json)
    }()
    
    func testComparison() {
        XCTAssertTrue(talkEarlier < talkLater)
        XCTAssertFalse(talkEarlier == talkLater)
        XCTAssertTrue(talkEarlier == talkEarlier)
    }
}
