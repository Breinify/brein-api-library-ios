//
// Created by Marco Recchioni on 28/06/2017.
// Copyright (c) 2017 Breinify. All rights reserved.
//

import Foundation

open class BreinLogger {

    public init() {
    }

    public static func debug(_ message: String?) {
         print(message ?? "empty");
    }

}
