//
//  TickerQuoteViewModel.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/25.
//

import Foundation
import XCAStocksAPI


@MainActor
class TickerQuoteViewModel: ObservableObject {
    @Published var phase: FetchPhase<Quote> = .initial
    var quote: Quote? { phase.value}
    var error: Error? { phase.error}
    
    let stocksAPI: StocksAPI
    let ticker: Ticker
    
    init(ticker: Ticker, stocksAPI: StocksAPI = XCAStocksAPI()) {
        self.ticker = ticker
        self.stocksAPI = stocksAPI
    }
    
    func fetchQuote() async {
        phase = .fetching
        do {
            let response = try await stocksAPI.fetchQuotes(symbols: ticker.symbol)
            if let quote = response.first {
                phase = .success(quote)
            } else {
                phase = .empty
            }
        } catch {
            phase = .failure(error)
            print(error.localizedDescription)
        }
    }
}
