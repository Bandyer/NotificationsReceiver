//
// Copyright © 2020 Bandyer. All rights reserved.
//

import Foundation
import PushKit

extension PKPushCredentials {

    var tokenToString: String {
        token.tokenToString
    }
}

extension Data {

    var tokenToString: String {
        map {
            String(format: "%02.2hhx", $0)
        }.joined()
    }
}
