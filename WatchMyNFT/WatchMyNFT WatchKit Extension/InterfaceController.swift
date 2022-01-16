//
//  InterfaceController.swift
//  WatchMyNFT WatchKit Extension
//
//  Created by Hideyoshi Moriya on 2022/01/16.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var imageView: WKInterfaceImage!
    
    let session: WCSession = WCSession.default

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        if WCSession.isSupported() {
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activated")
    }

    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print(messageData)
//        let image = UIImage.init(data: messageData)!
        imageView.setImageData(messageData)
        replyHandler(messageData)
    }

}
