//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

public enum BreinActivityType: String {

    case SEARCH = "search"
    case LOGIN = "login"
    case LOGOUT = "logout"
    case ADD_TO_CART = "addToCart"
    case REMOVE_FROM_CART = "removeFromCart"
    case SELECT_PRODUCT = "selectProduct"
    case CHECKOUT = "checkOut"
    case OTHER = "other"
}
