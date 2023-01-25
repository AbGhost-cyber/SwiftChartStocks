//
//  TickerRepository.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/25.
//

import Foundation
import XCAStocksAPI

protocol TickerListRepository {
    func save(_ current: [Ticker]) async throws
    func load() async throws -> [Ticker]
}

class TickerListRepoImpl: TickerListRepository {
    private var saved: [Ticker]?
    private let fileName: String
    
    private var url: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appending(component: "\(fileName).plist")
    }
    
    init(fileName: String = "my_tickers") {
        self.fileName = fileName
    }
    
    func save(_ current: [Ticker]) async throws {
        if let saved, saved == current {
            return
        }
        let encoded = PropertyListEncoder()
        encoded.outputFormat = .binary
        let data = try encoded.encode(current)
        try data.write(to: url, options: .atomic)
        self.saved = current
    }
    
    func load() throws -> [Ticker] {
        let data = try Data(contentsOf: url)
        let current = try PropertyListDecoder().decode([Ticker].self, from: data)
        self.saved = current
        return current
    }
}
