//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

public class BreinDimension {

    var dimensionFields = [String]()

    public init(dimensionFields: [String]) {
        self.dimensionFields = dimensionFields
    }

    public func getDimensionFields() -> Array<String> {
        return dimensionFields
    }

    public func setDimensionFields(dimensionFields: String...) {
        self.dimensionFields = dimensionFields
    }
}
