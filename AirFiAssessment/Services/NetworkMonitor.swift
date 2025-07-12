//
//  NetworkMonitor.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 11/07/25.
//
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    private(set) var isConnected: Bool = false

    var onConnect: (() -> Void)?
    var onDisconnect: (() -> Void)?

    private init() {
        monitor.pathUpdateHandler = { path in
            let connected = path.status == .satisfied
            if connected != self.isConnected {
                self.isConnected = connected
                DispatchQueue.main.async {
                    if connected {
                       
                        self.onConnect?()
                    } else {
                        self.onDisconnect?()
                    }
                }
            }
        }
        monitor.start(queue: queue)
    }
}
