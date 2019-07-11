//
//  Server.swift
//  PlotAR
//
//  Created by Philipp Thomann on 10.07.19.
//  Copyright © 2019 Philipp Thomann. All rights reserved.
//

import Foundation

import Starscream


enum ServerStatus {
    case unknown
    case offline
    case ping
    case online
    case connecting
    case connected
}

class Server {
    
    let url: URL
    lazy var dataset: Dataset = {
        Dataset(url: url)
    }()
    
    var ws: WebSocket? = nil
    var status: ServerStatus = .unknown
    
    var delegate: DatasetHandler? = nil
    
    init(url: URL) {
        self.url = url
    }
    convenience init(string: String) {
        self.init(url: URL(string: string)!)
    }
    
//    func alive() -> Bool{
//        URLRequest request = URLRequest(self.url)
//        request.httpMethod = "HEAD"
//    }
    
    func ensureConnect(){
        if status != .connected && status != .connecting {
            startSession()
        }
    }
    func startSession(){
        let wsUrl = url.appendingPathComponent("ws", isDirectory: false)
        print("Starting websocket to \(wsUrl)")
        status = .connecting
        let sock = WebSocket(url: wsUrl)
        ws = sock
        sock.disableSSLCertValidation = true
        //websocketDidConnect
        sock.onConnect = {
            print("websocket is connected")
            self.status = .connected
            sock.write(string: "{\"device\": true}\n")
        }
        //websocketDidDisconnect
        sock.onDisconnect = { (error: Error?) in
            print("websocket is disconnected: \(error?.localizedDescription ?? "(nil)")")
            self.status = .unknown
        }
        //websocketDidReceiveMessage
        sock.onText = { (text: String) in
            print("got some text: \(text)")
            self.handleWebSocketMessage(text)
        }
        //websocketDidReceiveData
        sock.onData = { (data: Data) in
            print("got some data: \(data.count)")
            //            self.handleWebSocketMessage(data)
        }
        //you could do onPong as well.
        sock.connect()
        print("Finished starting websocket to \(wsUrl)")
    }
    
    deinit {
        print("Disconnecting WebSocket")
        ws?.disconnect()
    }
    
    func handleWebSocketMessage(_ text: String){
        // doit
        print("ws message \(text)")
        
        if let json = try? JSONSerialization.jsonObject (with: text.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) {
            if let dictionary = json as? [String: Any] {
                
                if let keystroke = dictionary["key"] {
                    delegate?.handleKeyStroke(keystroke as! String)
                }
            }
        }else{
            print("Problem parsing json")
        }
    }
    
}
