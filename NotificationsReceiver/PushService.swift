//
// Copyright © 2020 Bandyer. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class PushService {

    static let shared = PushService()

    var token: Data? {
        UserDefaults.standard.value(forKey: "push_token") as? Data
    }
    
    private let center: UNUserNotificationCenter = UNUserNotificationCenter.current()

    var onTokenUpdate: ((Data?) -> Void)?
    var onAuthorizationStatusUpdate: (() -> Void)?

    private init() {}

    func start() {
        guard let token = self.token else { return }
        print("Push Token: \(token.asTokenString)")
    }

    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }

    func registerForNotifications() {
        getAuthorizationStatus { [weak self] (status) in
            guard let self = self else { return }
            
            if status == .notDetermined {
                self.center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            UIApplication.shared.registerForRemoteNotifications()
                            self.onAuthorizationStatusUpdate?()
                        }
                    }
                }
            }
        }
    }

    func updateToken(_ data: Data?) {
        print("Push Token: \(data?.asTokenString ?? "")")

        UserDefaults.standard.set(data, forKey: "push_token")
        UserDefaults.standard.synchronize()
        onTokenUpdate?(token)
    }
}
