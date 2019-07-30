//
//  RNZendesk.swift
//  RNZendesk
//
//  Created by David Chavez on 24.04.18.
//  Copyright © 2018 David Chavez. All rights reserved.
//

import UIKit
import Foundation
import ZendeskSDK
import ZendeskCoreSDK

@objc(RNZendesk)
class RNZendesk: RCTEventEmitter {

    override open static func requiresMainQueueSetup() -> Bool {
        return false;
    }

    @objc(constantsToExport)
    override func constantsToExport() -> [AnyHashable: Any] {
        return [:]
    }

    @objc(supportedEvents)
    override func supportedEvents() -> [String] {
        return []
    }


    // MARK: - Initialization

    @objc(initialize:)
    func initialize(config: [String: Any]) {
        guard
            let appId = config["appId"] as? String,
            let clientId = config["clientId"] as? String,
            let zendeskUrl = config["zendeskUrl"] as? String else { return }

        Zendesk.initialize(appId: appId, clientId: clientId, zendeskUrl: zendeskUrl)
        Support.initialize(withZendesk: Zendesk.instance)
    }

    // MARK: - Indentification

    @objc(identifyJWT:)
    func identifyJWT(token: String?) {
        guard let token = token else { return }
        let identity = Identity.createJwt(token: token)
        Zendesk.instance?.setIdentity(identity)
    }

    @objc(identifyAnonymous:email:)
    func identifyAnonymous(name: String?, email: String?) {
        var identity = Identity.createAnonymous(name: name, email: email)
        Zendesk.instance?.setIdentity(identity)
    }

    // MARK: - UI Methods

    @objc(showHelpCenter:)
    func showHelpCenter(with options: [String: Any]) {
        DispatchQueue.main.async {
            let hcConfig = HelpCenterUiConfiguration()
            hcConfig.hideContactSupport = (options["hideContactSupport"] as? Bool) ?? false
            
            let config = RequestUiConfiguration()
            if let fields = options["fileds"] as? [[String: Any]] {
                config.fields = fields
                    .filter({ field in
                        if let id = filed["id"] as? Int, let value = field["value"] {
                            return true
                        } else {
                            return false
                        }
                    })
                    .map({ field in
                        return ZDKCustomField(fieldId: NSNumber(value: field["id"]), andValue: field["value"])
                        
                    })
            }
            
            let helpCenter = HelpCenterUi.buildHelpCenterOverview(withConfigs: [hcConfig, config])

            let nvc = UINavigationController(rootViewController: helpCenter)
            UIApplication.shared.keyWindow?.rootViewController?.present(nvc, animated: true, completion: nil)
        }
    }

    @objc(showNewTicket:)
    func showNewTicket(with options: [String: Any]) {
        DispatchQueue.main.async {
            let config = RequestUiConfiguration()
            if let tags = options["tags"] as? [String] {
                config.tags = tags
            }
            if let fields = options["fileds"] as? [[String: Any]] {
              config.fields = fields
                .filter({ field in
                    if let id = filed["id"] as? Int, let value = field["value"] {
                        return true
                    } else {
                        return false
                    }
                })
                .map({ field in
                    return ZDKCustomField(fieldId: NSNumber(value: field["id"]), andValue: field["value"])

                })
            }
            let requestScreen = RequestUi.buildRequestUi(with: [config])

            let nvc = UINavigationController(rootViewController: requestScreen)
            UIApplication.shared.keyWindow?.rootViewController?.present(nvc, animated: true, completion: nil)
        }
    }
    
    @objc(showTickets:)
    func showTickets(with options: [String: Any]) {
        DispatchQueue.main.async {
            let config = RequestUiConfiguration()
            if let tags = options["tags"] as? [String] {
                config.tags = tags
            }
            if let fields = options["fileds"] as? [[String: Any]] {
                config.fields = fields
                    .filter({ field in
                        if let id = filed["id"] as? Int, let value = field["value"] {
                            return true
                        } else {
                            return false
                        }
                    })
                    .map({ field in
                        return ZDKCustomField(fieldId: NSNumber(value: field["id"]), andValue: field["value"])
                        
                    })
            }
            let requestScreen = RequestUi.buildRequestList(with: [config])
            
            let nvc = UINavigationController(rootViewController: requestScreen)
            UIApplication.shared.keyWindow?.rootViewController?.present(nvc, animated: true, completion: nil)
        }
    }
}
