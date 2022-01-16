//
//  WatchConnectivityProvider.swift
//  WatchMyNFT
//
//  Created by Hideyoshi Moriya on 2022/01/16.
//

import UIKit
import WatchConnectivity

class WatchConnectivityProvider: NSObject, WCSessionDelegate {
    
    private let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.connect()
    }
    
    func connect() {
        guard WCSession.isSupported() else {return}
        self.session.activate()
    }
    
    func send(image: UIImage?) -> Void {
        guard let data = image?.pngData() else {return}
        self.session.sendMessageData(data) { data in
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }

    func send(data: Data) -> Void {
        self.session.sendMessageData(data) { data in
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(#function)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
}
