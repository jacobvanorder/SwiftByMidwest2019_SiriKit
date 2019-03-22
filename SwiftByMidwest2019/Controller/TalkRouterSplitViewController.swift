//
//  TalkRouterSplitViewController.swift
//  SwiftByMidwest2019
//
//  Created by Jacob Van Order on 3/16/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import UIKit
import SwiftByMidwest2019Framework

class TalkRouterSplitViewController: UISplitViewController {
    
    let sxmw = Conference.swiftByMidwest2019()
    
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        if activity.activityType == NSUserActivity.talkActivityIdentifier,
            let userInfo = activity.userInfo,
            let talkId = userInfo["talkId"] as? Int,
            let speakerId = userInfo["speakerId"] as? Int,
            let talk = sxmw.talks.filter({$0.id == talkId}).first,
            let speaker = sxmw.speakers.filter({$0.id == speakerId}).first {
            route(to: talk, by: speaker)
        } else if activity.activityType == NSUserActivity.nextTalkShortcutActivityIndentifer,
            let talk = sxmw.nextTalk(date: Date()),
            let speaker = sxmw.speaker(for: talk) {
            route(to: talk, by: speaker)
        }
    }
}

extension TalkRouterSplitViewController: TalkRouterProtocol {
    func route(to talk: Talk, by speaker: Speaker? = .none) {
        guard
            let talkDetailController = storyboard?.instantiateViewController(withIdentifier: "TalkDetailViewController") as? TalkDetailViewController,
            let speaker = speaker ?? sxmw.speaker(for: talk) else {
                return
        }
        
        talkDetailController.read(talk: talk, by: speaker)
        if let navigationController = viewControllers.first as? UINavigationController,
            navigationController.visibleViewController is TalkDetailViewController {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(talkDetailController, animated: true)
        } else {
            showDetailViewController(talkDetailController, sender: .none)
        }
    }
}
