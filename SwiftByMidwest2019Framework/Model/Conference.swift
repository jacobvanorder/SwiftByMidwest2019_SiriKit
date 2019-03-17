//
//  Conference.swift
//  SwiftByMidwest2019Framework
//
//  Created by Jacob Van Order on 3/15/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import Foundation

public class Conference: Codable {
    public let name: String
    public let locationName: String
    public let locationCoordinates: Coordinates
    public let speakers: [Speaker]
    public let talks: [Talk]
    
    public func nextTalk(date: Date = Date()) -> Talk? {
        return talks.sorted().first(where: {date.compare($0.startingTime) == .orderedAscending})
    }
    
    public func nextSpeaker(date: Date = Date()) -> Speaker? {
        return speaker(for: nextTalk(date: date))
    }
    
    public func speaker(for talk: Talk?) -> Speaker? {
        return speakers.first(where: {$0.id == talk?.speakerId})
    }
    
    public func isOver(at date: Date) -> Bool {
        guard
            let lastTalkTime = talks.sorted().last?.endingTime
            else { return true }
        return date > lastTalkTime
    }
    
    public static func swiftByMidwest2019() -> Conference {
        let decoder = JSONDecoder()
        do {
            let sxmw = try decoder.decode(Conference.self, from: json)
            return sxmw
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static private let json: Data = {
        guard
            let languageCode = Locale.current.languageCode,
            let path: String = Bundle(for: Conference.self).path(forResource: "conference_" + languageCode, ofType: "json") else {
                fatalError("Couldn't find json data for language \(String(describing: Locale.current.languageCode)).")
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            return data
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }()
}

public struct Coordinates: Codable {
    public let lat: Float
    public let long: Float
}
