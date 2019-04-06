//
//  Talk+IntentObject.swift
//  SwiftByMidwest2019Framework
//
//  Created by mrJacob on 4/5/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import Foundation

extension Talk: IntentObjectProtocol {
    
    public var identifier: String {
        return String(self.id)
    }
    
    public var display: String {
        return self.subject
    }
    
    public var pronunciationHint: String? {
        return self.subject
    }
}

