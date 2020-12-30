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
    case PAGE_VISIT = "pageVisit"
    case VIEWED_PRODUCT = "viewedProduct"
    case CANCEL_ORDER = "cancelOrder"
    case IDENTIFY = "identify"
    case SEND_LOC = "sendLoc"
    case OPEN_PUSH_NOTIFICATION = "openedPushNotification"
    case FAIL_PUSH_NOTIFICATION = "failPushNotification"
    case RECEIVED_PUSH_NOTIFICATION = "receivedPushNotification"
    case START_PUSH_NOTIFICATION = "startPushNotification"
    case STOP_PUSH_NOTIFICATION = "stopPushNotification"
    case CHECKOUT_EMAIL_ENTERED = "checkOutEmailEntered"
    case OPENED_EMAIL = "openedEmail"
    case START_EMAIL = "startEmail"
    case STOP_EMAIL = "stopEmail"
}
