//
// Copyright © 2020 Bandyer. All rights reserved.
//

import Foundation
import UserNotifications

extension UNAuthorizationStatus: CustomStringConvertible {

    public var description: String {
        switch self {
            case .notDetermined:
                return "not determined"
            case .denied:
                return "denied"
            case .authorized:
                return "authorized"
            case .provisional:
                return "provisional"
        }
    }
}
