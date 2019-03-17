//
//  NSUserActivity+Conference.swift
//  SwiftByMidwest2019
//
//  Created by mrJacob on 3/19/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices
import IntentsUI
import UIKit

import SwiftByMidwest2019Framework

extension NSUserActivity {
    
    static let talkActivityIdentifier = "com.SushiGrass.SwiftByMidwest2019.TalkActivity"
    
    convenience public init(identifier: String,
                            talk: Talk,
                            by speaker: Speaker,
                            at conference: Conference) {
        self.init(activityType: identifier)
        self.persistentIdentifier = identifier
        self.title = talk.title //Very important!
        let keywords = [speaker.fullName,
                        speaker.lastName,
                        speaker.firstName,
                        conference.name,
                        talk.subject]
        self.keywords = Set(keywords)
        let userInfo = ["talkId": talk.id,
                        "speakerId": speaker.id]
        self.userInfo = userInfo //Very important!
        self.requiredUserInfoKeys = Set(userInfo.keys) //Very important!
        self.persistentIdentifier = NSUserActivityPersistentIdentifier(String(talk.id)) //Very important!
        
        self.isEligibleForSearch = true
        //https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/SearchUserExperience.html#//apple_ref/doc/uid/TP40016308-CH11
        let spotlightSearch = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        spotlightSearch.title = talk.title
        spotlightSearch.keywords = keywords
        let localizedSearchString = NSLocalizedString("%@ by %@ %@",
                                                      comment: "Spotlight search string for talk.")
        spotlightSearch.contentDescription = String(format:localizedSearchString,
                                                    talk.title, speaker.firstName, speaker.lastName)
        spotlightSearch.startDate = talk.startingTime
        spotlightSearch.endDate = talk.endingTime
        spotlightSearch.latitude = NSNumber(value: conference.locationCoordinates.lat)
        spotlightSearch.longitude = NSNumber(value: conference.locationCoordinates.long)
        spotlightSearch.namedLocation = conference.locationName
        spotlightSearch.thumbnailData = speaker.profileImage?.jpegData(compressionQuality: 0.5) //Must be a jpeg or won't work!
        
        self.contentAttributeSet = spotlightSearch
        self.needsSave = true
    }
}
