//
//  SpeakerTests.swift
//  SwiftByMidwest2019FrameworkTests
//
//  Created by Jacob Van Order on 3/16/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import XCTest
@testable import SwiftByMidwest2019Framework

class SpeakerTests: XCTestCase {
    func testInitialization() {
        let json = """
{
"firstName": "Jon-Tait",
"lastName": "Beason",
"talkIds": [
4
],
"profileImageURL": "https://static1.squarespace.com/static/5c17e8af9f8770c948b55d3f/t/5c5322276d2a73238d481597/1548952163831/Jon-Tait-Beason.png?format=300w",
"id": 4
}
""".data(using: .utf8)!
        let speaker = try! JSONDecoder().decode(Speaker.self, from: json)
        XCTAssertEqual(speaker.firstName, "Jon-Tait")
        XCTAssertEqual(speaker.lastName, "Beason")
        XCTAssertEqual(speaker.talkIds, [4])
        XCTAssertEqual(speaker.profileImageURL, URL(string: "https://static1.squarespace.com/static/5c17e8af9f8770c948b55d3f/t/5c5322276d2a73238d481597/1548952163831/Jon-Tait-Beason.png?format=300w")!)
        XCTAssertEqual(speaker.id, 4)
        XCTAssertEqual(speaker.fullName, "Jon-Tait Beason")
    }
}
