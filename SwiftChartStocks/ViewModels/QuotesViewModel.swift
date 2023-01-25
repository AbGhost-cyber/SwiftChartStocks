//
//  QuotesViewModel.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/22.
//

import Foundation
import SwiftUI
import XCAStocksAPI

@MainActor
class QuotesViewModel: ObservableObject {
    
    @Published var quotesDict: Dictionary<String, Quote> = [:]
    private let stocksAPI: StocksAPI
    
    init(stocksAPI: StocksAPI = XCAStocksAPI()) {
        self.stocksAPI = stocksAPI
    }
    
    func fetchQuotes(tickers: [Ticker]) async {
        guard !tickers.isEmpty else { return }
        do {
            let symbols = tickers.map { $0.symbol }.joined(separator: ",")
            let quotes = try await stocksAPI.fetchQuotes(symbols: symbols)
            var dict = [String: Quote]()
            quotes.forEach { quote in
                dict[quote.symbol] = quote
            }
            self.quotesDict = dict
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func priceForTicker(_ ticker: Ticker) -> PriceChange? {
        guard let quote = quotesDict[ticker.symbol],
              let price = quote.regularPriceText,
              let change = quote.regularDiffText
        else { return nil }
        return (price, change)
    }
}
