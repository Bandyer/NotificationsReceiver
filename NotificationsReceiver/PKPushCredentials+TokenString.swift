//
// Copyright © 2020 Bandyer. All rights reserved.
//

import Foundation
import PushKit

extension PKPushCredentials {

    var tokenToString: String {
        token.asTokenString
    }
}
