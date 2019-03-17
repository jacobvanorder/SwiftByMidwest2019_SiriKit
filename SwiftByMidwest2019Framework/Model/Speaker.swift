//
//  Speaker.swift
//  SwiftByMidwest2019Framework
//
//  Created by Jacob Van Order on 3/15/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import Foundation

public class Speaker: Codable {
    public let id: Int
    public let firstName: String
    public let lastName: String
    public let profileImageURL: URL
    public let talkIds: [Int]
}

public extension Speaker {
    private static let formatter = PersonNameComponentsFormatter()
    
    var fullName: String {
        var nameComponents = PersonNameComponents()
        nameComponents.givenName = self.firstName
        nameComponents.familyName = self.lastName
        return Speaker.formatter.string(from: nameComponents)
    }
}
