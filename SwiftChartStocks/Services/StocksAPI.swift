//
//  StocksAPI.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/25.
//

import Foundation
import XCAStocksAPI

protocol StocksAPI {
    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker]
    func fetchQuotes(symbols: String) async throws -> [Quote]
}

extension XCAStocksAPI: StocksAPI {
    
}
