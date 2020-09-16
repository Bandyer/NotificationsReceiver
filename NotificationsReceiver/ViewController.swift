//
//  Copyright © 2020 Bandyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var voipLabel: UILabel!
    @IBOutlet private var pushLabel: UILabel!
    @IBOutlet private var voipTextView: UITextView!
    @IBOutlet private var pushTextView: UITextView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateVoipTokenField(token: VoIPService.shared.token)
        updatePushTokenField(token: PushService.shared.token)
    }

    private func updateVoipTokenField(token: Data?) {
        voipTextView.text = token?.tokenToString ?? "N/A"
    }

    private func updatePushTokenField(token: Data?) {
        pushTextView.text = token?.tokenToString ?? "N/A"
    }

}
