//
// Copyright © 2020 Bandyer. All rights reserved.
//

import Foundation
import PushKit
import CallKit
import UIKit

class VoIPService: NSObject, PKPushRegistryDelegate, CXProviderDelegate {

    static let shared = VoIPService()

    private let registry: PKPushRegistry
    private let provider: CXProvider

    var onTokenUpdate: ((Data?) -> Void)?

    var token: Data? {
        registry.pushToken(for: .voIP)
    }

    private override init() {
        registry = PKPushRegistry(queue: .main)
        let config = CXProviderConfiguration(localizedName: "Notifications Receiver")
        config.maximumCallGroups = 1
        config.maximumCallsPerCallGroup = 1
        config.iconTemplateImageData = UIImage(named: "callkit-icon")?.pngData()
        provider = CXProvider(configuration: config)
        super.init()
    }

    func start() {
        registry.delegate = self
        registry.desiredPushTypes = [.voIP]
        provider.setDelegate(self, queue: .main)
    }

    // MARK: PKPushRegistryDelegate

    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print("VoIP token: \(pushCredentials.tokenToString)")
        onTokenUpdate?(token)
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        print("VoIP notification received: \(payload.dictionaryPayload)")
        let callUpdate = CXCallUpdate()
        callUpdate.remoteHandle = CXHandle(type: .generic, value: "VoIP notification received")
        let callId = UUID()
        provider.reportNewIncomingCall(with: callId, update: CXCallUpdate()) { (error) in
            if error == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    guard let self = self else { return }

                    self.provider.reportCall(with: callId, endedAt: nil, reason: .failed)
                }
            }
        }
    }

    // MARK: CXProviderDelegate

    func providerDidReset(_ provider: CXProvider) {
        print("Provider reset!")
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        action.fail()
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fail()
    }

    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        action.fail()
    }
}
