//
// Copyright © 2020 Bandyer. All rights reserved.
//

import Foundation

extension Data {

    var asTokenString: String {
        map {
            String(format: "%02.2hhx", $0)
        }.joined()
    }
}
