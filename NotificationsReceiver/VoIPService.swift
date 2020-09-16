//
// Copyright © 2020 Bandyer. All rights reserved.
//

import Foundation
import PushKit

class VoIPService: NSObject, PKPushRegistryDelegate {

    static let shared = VoIPService()

    private let registry: PKPushRegistry

    var token: Data? {
        registry.pushToken(for: .voIP)
    }

    private override init() {
        registry = PKPushRegistry(queue: .main)
        super.init()
    }

    func start() {
        registry.delegate = self
        registry.desiredPushTypes = [.voIP]
    }

    // MARK: PKPushRegistryDelegate

    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print("VoIP token updated: \(pushCredentials.tokenToString)")
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        print("VoIP notification received: \(payload.dictionaryPayload)")
    }
}
