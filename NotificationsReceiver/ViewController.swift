//
//  Copyright © 2020 Bandyer. All rights reserved.
//

import UIKit
import PushKit

class ViewController: UIViewController, PKPushRegistryDelegate {

    private let registry: PKPushRegistry = PKPushRegistry(queue: .main)

    @IBOutlet private var voipLabel: UILabel!
    @IBOutlet private var pushLabel: UILabel!
    @IBOutlet private var voipTextView: UITextView!
    @IBOutlet private var pushTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        registerToVoIPNotifications()
    }

    private func registerToVoIPNotifications() {
        registry.delegate = self
        registry.desiredPushTypes = [.voIP]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateVoipTokenField(token: registry.pushToken(for: .voIP))
    }

    private func updateVoipTokenField(token: Data?) {
        voipTextView.text = token?.tokenToString ?? ""
    }

    // MARK: PKPushRegistryDelegate

    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print("VoIP token updated: \(pushCredentials.tokenToString)")
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        print("VoIP notification received: \(payload.dictionaryPayload)")
    }

}

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
