//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

class BreinDimension {

    var dimensionFields = [String]()

    init(dimensionFields: [String]) {
        self.dimensionFields = dimensionFields
    }

    func getDimensionFields() -> Array<String> {
        return dimensionFields
    }

    func setDimensionFields(dimensionFields: String...) {
        self.dimensionFields = dimensionFields
    }

}
