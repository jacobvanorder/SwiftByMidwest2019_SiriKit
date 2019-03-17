//
//  Speaker+ProfileImage.swift
//  SwiftByMidwest2019
//
//  Created by mrJacob on 3/17/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import UIKit
import SwiftByMidwest2019Framework

extension Speaker {
    var profileImage: UIImage? {
        return UIImage(named: profileImageURL.lastPathComponent)
    }
}
