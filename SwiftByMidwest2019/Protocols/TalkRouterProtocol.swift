//
//  TalkRouterProtocol.swift
//  SwiftByMidwest2019
//
//  Created by mrJacob on 3/19/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import Foundation
import SwiftByMidwest2019Framework

protocol TalkRouterProtocol {
    func route(to talk: Talk, by speaker: Speaker?)
}
