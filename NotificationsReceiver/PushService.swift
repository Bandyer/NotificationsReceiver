//
// Copyright © 2020 Bandyer. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class PushService {

    static let shared = PushService()
    private(set) var token: Data?
    private let center: UNUserNotificationCenter = UNUserNotificationCenter.current()

    private init() {
        
    }

    func authorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }

    func registerForNotifications() {
        authorizationStatus { [weak self] (status) in
            guard let self = self else { return }
            
            if status == .notDetermined {
                self.center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            }
        }
    }

    func updateToken(_ data: Data?) {
        token = data
        guard let deviceToken = data else { return }
        print("Registered for Push - Token: \(deviceToken.tokenToString)")
    }
}
