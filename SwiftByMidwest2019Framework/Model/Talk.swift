//
//  Talk.swift
//  SwiftByMidwest2019Framework
//
//  Created by Jacob Van Order on 3/15/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import Foundation

public class Talk: Codable, Comparable {
    
    public let id: Int
    public let title: String
    public let startingTime: Date
    public let endingTime: Date
    public let speakerId: Int
    public let talkDescription: String
    public let subject: String
    
    public static func < (lhs: Talk, rhs: Talk) -> Bool {
        return lhs.startingTime.compare(rhs.startingTime) == .orderedAscending
    }
    
    public static func == (lhs: Talk, rhs: Talk) -> Bool {
        return lhs.id == rhs.id
    }
}
