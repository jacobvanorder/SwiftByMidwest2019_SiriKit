//
//  DetailViewController.swift
//  SwiftByMidwest2019
//
//  Created by Jacob Van Order on 3/15/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import UIKit
import SwiftByMidwest2019Framework

class TalkDetailViewController: UIViewController {
    
    //MARK: User Interface
    @IBOutlet weak var speakerTalkContentStackView: UIStackView!
    @IBOutlet weak var speakerProfileImageView: UIImageView!
    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var talkTitleLabel: UILabel!
    @IBOutlet weak var talkTimeStartEndLabel: UILabel!
    @IBOutlet weak var talkDescriptionLabel: UILabel!
    @IBOutlet weak var noContentView: UIView!
    
    //MARK: Model
    
    private var talk: Talk?
    private var speaker: Speaker?
    
    func read(talk: Talk, by speaker: Speaker) {
        self.talk = talk
        self.speaker = speaker
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

