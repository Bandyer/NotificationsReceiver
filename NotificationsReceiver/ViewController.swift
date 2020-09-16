//
//  Copyright © 2020 Bandyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var voipTextView: UITextView!
    @IBOutlet private var pushTextView: UITextView!
    @IBOutlet private var pushAuthLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        VoIPService.shared.onTokenUpdate = { [weak self] token in
            guard let self = self else { return }
            self.updateVoipToken()
        }

        PushService.shared.onTokenUpdate = { [weak self] token in
            guard let self = self else { return }
            self.updatePushToken()
        }

        PushService.shared.onAuthorizationStatusUpdate = { [weak self] in
            guard let self = self else { return }
            self.updatePushAuthStatus()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updatePushAuthStatus()
        updatePushToken()
        updateVoipToken()
    }

    private func updatePushAuthStatus() {
        PushService.shared.getAuthorizationStatus { (status) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updatePushAuthLabel(status: status)
            }
        }
    }

    private func updateVoipToken() {
        updateVoipTokenField(token: VoIPService.shared.token)
    }

    private func updatePushToken() {
        updatePushTokenField(token: PushService.shared.token)
    }

    private func updateVoipTokenField(token: Data?) {
        voipTextView.text = token?.tokenToString ?? "N/A"
    }

    private func updatePushTokenField(token: Data?) {
        pushTextView.text = token?.tokenToString ?? "N/A"
    }

    private func updatePushAuthLabel(status: UNAuthorizationStatus) {
        pushAuthLabel.text = String(describing: status)
    }

}

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
