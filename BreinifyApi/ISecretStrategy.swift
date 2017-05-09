//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

public protocol ISecretStrategy {

    /// creates the signature for each endpoint 
    func createSignature() throws -> String!
}
