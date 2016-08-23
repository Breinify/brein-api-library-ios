//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

protocol ISecretStrategy {

    func createSignature() throws -> String!
}
