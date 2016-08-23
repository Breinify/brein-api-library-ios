//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

protocol IRestEngine {

    func configure(breinConfig: BreinConfig)

    func doRequest(breinActivity: BreinActivity,
                   success successBlock :(result: BreinResult?) -> Void,
                   failure failureBlock :(error: NSDictionary?) -> Void) throws

    func doLookup(breinLookup: BreinLookup,
                  success successBlock :(result: BreinResult?) -> Void,
                  failure failureBlock :(error: NSDictionary?) -> Void) throws

    func terminate()

  }





