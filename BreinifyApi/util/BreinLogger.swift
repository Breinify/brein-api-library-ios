//
// Created by Marco Recchioni  
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinLogger {

    static let shared = BreinLogger()

    private var isDebug: Bool = false
    
    public init() {
    }

    func setDebug(_ isDebug: Bool) {
        self.isDebug = isDebug
    }

    func log(_ message: String?) {
        if self.isDebug {
            debugPrint(message ?? "empty");
        }
    }

}
