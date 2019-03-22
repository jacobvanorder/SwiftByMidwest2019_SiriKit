//
//  MasterViewController.swift
//  SwiftByMidwest2019
//
//  Created by Jacob Van Order on 3/15/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import UIKit
import CoreSpotlight
import SwiftByMidwest2019Framework
import IntentsUI
import Intents

class TalkListTableViewController: UITableViewController {
    
    static let CellIdentifier: String = "TalkTableViewCell"
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "CDT")
        formatter.dateFormat = "MM/dd hh:mm a"
        return formatter
    }() 
    
    //MARK: Model
    let sxmw = Conference.swiftByMidwest2019()
    
    //MARK: Delegate
    var talkRouterDelegate: TalkRouterProtocol?
    
    //MARK: User Interface
    @IBOutlet var siriBarButtonItem: UIBarButtonItem!
    
    //MARK: Custom Methods
    func transitionToDetail(for talk: Talk, by speaker: Speaker) {
        talkRouterDelegate?.route(to: talk, by: speaker)
    }
    
    func addUserActivity(for talk: Talk, by speaker: Speaker) {
        if CSSearchableIndex.isIndexingAvailable() {
            self.userActivity?.resignCurrent()
            let userActivity = NSUserActivity(identifier: NSUserActivity.talkActivityIdentifier,
                                              talk: talk,
                                              by: speaker,
                                              at: sxmw)
            userActivity.isEligibleForPrediction = true
            let localizedString = NSLocalizedString("When is %@ speaking?",
                                                    comment: "The suggested invocation phrase for a talk.")
            userActivity.suggestedInvocationPhrase = String(format: localizedString, speaker.fullName)

            self.userActivity = userActivity
        }
    }
    
    //MARK: Stock Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Speakers", comment: "Title for speakers list.")
        siriBarButtonItem.accessibilityHint = NSLocalizedString("Button to enable Siri Shortcut for next speaker",
                                                                comment: "The Siri Shortcut accessibility hint")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (INPreferences.siriAuthorizationStatus() == .authorized) {
            INVoiceShortcutCenter.shared.getAllVoiceShortcuts {
                [weak self]
                (optionalShortcuts: [INVoiceShortcut]?, optionalError) in
                DispatchQueue.main.async {
                    let weGotAShortcut = (optionalShortcuts?.filter({$0.shortcut.userActivity?.activityType == NSUserActivity.nextTalkShortcutActivityIndentifer}).first != .none)
                    self?.siriBarButtonItem.isEnabled = weGotAShortcut
                }
            }
        } else if INPreferences.siriAuthorizationStatus() == .denied {
            siriBarButtonItem.isEnabled = false
        }
    }
    
    //MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        let talk = sxmw.talks.sorted()[indexPath.row]
        guard let speaker = sxmw.speaker(for: talk) else { return }
        transitionToDetail(for: talk, by: speaker)
        addUserActivity(for: talk, by: speaker)
    }
    
    //MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sxmw.talks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let talkCell = tableView.dequeueReusableCell(withIdentifier: TalkListTableViewController.CellIdentifier,
                                                     for: indexPath)
        
        let talk = sxmw.talks.sorted()[indexPath.item]
        guard
            let speaker = sxmw.speaker(for: talk) else {
                fatalError("Hmmmm… no speaker for \(talk.title)")
        }
        
        talkCell.textLabel?.text = talk.title
        talkCell.detailTextLabel?.text = TalkListTableViewController.dateFormatter.string(from: talk.startingTime)
        talkCell.imageView?.image = speaker.profileImage
        
        return talkCell
    }
}

extension TalkListTableViewController: INUIAddVoiceShortcutViewControllerDelegate {
    
    @IBAction func siriBarButtonItemTapped(_ sender: UIBarButtonItem) {
        let siriAuthorizationStatus = INPreferences.siriAuthorizationStatus()
        if siriAuthorizationStatus == .notDetermined {
            INPreferences.requestSiriAuthorization {
                [weak self]
                (newStatus) in
                DispatchQueue.main.async {
                    self?.siriBarButtonItemTapped(sender)
                }
            }
        } else if siriAuthorizationStatus == .denied ||
            siriAuthorizationStatus == .restricted {
            sender.isEnabled = false
        } else if siriAuthorizationStatus == .authorized {
            let identifier = NSUserActivity.nextTalkShortcutActivityIndentifer
            let userActivity = NSUserActivity(identifier: identifier)
            let shortcut = INShortcut(userActivity: userActivity)
            let voiceShortcutViewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            voiceShortcutViewController.delegate = self
            present(voiceShortcutViewController, animated: true, completion: .none)
        }
    }
    
    public func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        self.siriBarButtonItem.isEnabled = (error != nil)
        dismiss(animated: true, completion: .none)
    }

    public func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        dismiss(animated: true, completion: .none)
    }
}
