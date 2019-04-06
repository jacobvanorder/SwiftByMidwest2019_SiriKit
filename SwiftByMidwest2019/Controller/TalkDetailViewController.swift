//
//  DetailViewController.swift
//  SwiftByMidwest2019
//
//  Created by Jacob Van Order on 3/15/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import UIKit
import SwiftByMidwest2019Framework
import IntentsUI

class TalkDetailViewController: UIViewController {
    
    //MARK: User Interface
    @IBOutlet weak var speakerTalkContentStackView: UIStackView!
    @IBOutlet weak var speakerProfileImageView: UIImageView!
    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var talkTitleLabel: UILabel!
    @IBOutlet weak var talkTimeStartEndLabel: UILabel!
    @IBOutlet weak var talkDescriptionLabel: UILabel!
    lazy var shortcutsButton: INUIAddVoiceShortcutButton = {
        let shortcutsButton = INUIAddVoiceShortcutButton(style: .black)
        shortcutsButton.translatesAutoresizingMaskIntoConstraints = false
        shortcutsButton.addTarget(self,
                                  action: #selector(addShortcutButtonTapped(sender:)),
                                  for: .touchUpInside)
        return shortcutsButton
    }()
    @IBOutlet weak var noContentView: UIView!
    
    //MARK: Model
    
    private var talk: Talk?
    private var speaker: Speaker?
    
    func read(talk: Talk, by speaker: Speaker) {
        self.talk = talk
        self.speaker = speaker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if INPreferences.siriAuthorizationStatus() == .authorized ||
            INPreferences.siriAuthorizationStatus() == .notDetermined {
            speakerTalkContentStackView.addArrangedSubview(shortcutsButton)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard
            let speaker = speaker,
            let talk = talk else {
                noContentView.isHidden = false
                speakerTalkContentStackView.isHidden = true
                return
        }
        
        noContentView.isHidden = true
        speakerTalkContentStackView.isHidden = false
        
        speakerProfileImageView.image = speaker.profileImage
        speakerNameLabel.text = speaker.fullName
        talkTitleLabel.text = talk.title
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "CDT")
        dateFormatter.dateFormat = "MM/dd"
        let dayString = dateFormatter.string(from: talk.startingTime)
        dateFormatter.dateFormat = "hh:mm a"
        let startTimeString = dateFormatter.string(from: talk.startingTime)
        let endTimeString = dateFormatter.string(from: talk.endingTime)
        talkTimeStartEndLabel.text = "\(dayString) \(startTimeString)-\(endTimeString)"
        talkDescriptionLabel.text = talk.talkDescription.replacingOccurrences(of: "\n", with: "\n")
    }
}

extension TalkDetailViewController: INUIAddVoiceShortcutViewControllerDelegate {
    @objc func addShortcutButtonTapped(sender: INUIAddVoiceShortcutButton) {
        guard let speaker = speaker else { return }
        let siriAuthorizationStatus = INPreferences.siriAuthorizationStatus()
        if siriAuthorizationStatus == .notDetermined {
            INPreferences.requestSiriAuthorization {
                [weak self]
                (status) in
                self?.addShortcutButtonTapped(sender: sender)
            }
        } else if siriAuthorizationStatus == .authorized {
            let talkQueryIntent = TalkQueryIntent()
            talkQueryIntent.speaker = speaker.intentObject()
            if speaker.talkIds.count > 1 {
                talkQueryIntent.talk = talk?.intentObject()
            }
            guard
                let shortcut = INShortcut(intent: talkQueryIntent) else { return }
                let addVoiceShortcutViewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
                addVoiceShortcutViewController.delegate = self
                present(addVoiceShortcutViewController,
                        animated: true,
                        completion: .none)
        } else if siriAuthorizationStatus == .denied ||
            siriAuthorizationStatus == .restricted {
            sender.isEnabled = false
        }
    }
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                        didFinishWith voiceShortcut: INVoiceShortcut?,
                                        error: Error?) {
        dismiss(animated: true, completion: .none)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        dismiss(animated: true, completion: .none)
    }
}

