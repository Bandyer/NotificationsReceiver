//
//  Copyright © 2020 Bandyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var voipTextView: UITextView!
    @IBOutlet private var pushTextView: UITextView!
    @IBOutlet private var pushAuthLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        PushService.shared.authorizationStatus { (status) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.updatePushAuthLabel(status: status)
            }
        }
        updateVoipTokenField(token: VoIPService.shared.token)
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
