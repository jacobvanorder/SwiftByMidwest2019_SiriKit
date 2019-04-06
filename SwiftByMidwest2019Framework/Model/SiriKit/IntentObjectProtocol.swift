//
//  IntentObjectProtocol.swift
//  SwiftByMidwest2019Framework
//
//  Created by mrJacob on 4/5/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import Foundation
import Intents

public protocol IntentObjectProtocol {
    var identifier: String { get }
    var display: String { get }
    var pronunciationHint: String? { get }
    func intentObject() -> INObject
}

public extension IntentObjectProtocol {
    func intentObject() -> INObject {
        return INObject(identifier: identifier,
                        display: display,
                        pronunciationHint: pronunciationHint)
    }
}
