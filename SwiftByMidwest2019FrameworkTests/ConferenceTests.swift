//
//  ConferenceTests.swift
//  SwiftByMidwest2019FrameworkTests
//
//  Created by Jacob Van Order on 3/16/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import XCTest
@testable import SwiftByMidwest2019Framework

class ConferenceTests: XCTestCase {
    let sxmw = Conference.swiftByMidwest2019()
    
    func testTalks() {
        XCTAssertEqual(sxmw.talks.count, 12)
    }
    
    func testSpeakers() {
        XCTAssertEqual(sxmw.speakers.count, 10)
    }
    
    func testName() {
        XCTAssertEqual(sxmw.name, "Swift by Midwest")
    }
    
    func testLocationName() {
        XCTAssertEqual(sxmw.locationName, "Elk Grove Holiday Inn")
    }
    
    func testNextTalk() {
        let date = Date(timeIntervalSinceReferenceDate: 577202401) //Right after first talk
        XCTAssertEqual(sxmw.nextTalk(date: date)?.id, 1)
    }
    
    func testNextTalkAfterConference() {
        let date = Date(timeIntervalSinceReferenceDate: 577313101)
        XCTAssertNil(sxmw.nextTalk(date: date))
    }
    
    func testNextSpeaker() {
        let date = Date(timeIntervalSinceReferenceDate: 577202401) //Right after first talk
        XCTAssertEqual(sxmw.nextSpeaker(date: date)?.id, 1)
    }
    
    func testNextSpeakerAfterConference() {
        let date = Date(timeIntervalSinceReferenceDate: 577313101)
        XCTAssertNil(sxmw.nextSpeaker(date: date))
    }
    
    func testIsOverBackInJanOneTwoThousand() {
        XCTAssertFalse(sxmw.isOver(at: Date(timeIntervalSinceReferenceDate: 0)))
    }
    
    func testIsOverWayInTheFuture() {
        XCTAssertTrue(sxmw.isOver(at: Date(timeIntervalSinceReferenceDate: 577313101)))
    }
    
    func testSpeakerForTalk() {
        guard let talkJSONData = """
{
      "title": "I’m a Coder: Codable & NSCoding",
      "startingTime": 577206900,
      "endingTime": 577210500,
      "id": 1,
      "speakerId": 1,
      "talkDescription": "Is Codable just a new name for NSCoding? Why do we have both? Can we use them together? You may also want to attend this talk if you’ve been meaning to support State Restoration.",
      "subject": "State restoration"
    }
""".data(using: .utf8) else { XCTAssert(false); return }
        do {
            let jsonDecoder = JSONDecoder()
            let talk = try jsonDecoder.decode(Talk.self, from: talkJSONData)
            XCTAssertEqual(sxmw.speaker(for: talk)?.firstName, "Liz")
        }
        catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
}
