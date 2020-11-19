//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinDimension {

    var dimensionFields = [String]()

    public init(dimensionFields: [String]) {
        self.dimensionFields = dimensionFields
    }

    public func getDimensionFields() -> Array<String> {
        dimensionFields
    }

    @discardableResult
    public func setDimensionFields(_ dimensionFields: String...) -> BreinDimension! {
        self.dimensionFields = dimensionFields
        return self
    }

}
