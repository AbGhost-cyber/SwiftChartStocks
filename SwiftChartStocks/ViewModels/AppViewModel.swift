//
//  AppViewModel.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/22.
//

import Foundation
import SwiftUI
import XCAStocksAPI

@MainActor
class AppViewModel: ObservableObject {
    
    @Published var tickers: [Ticker] = []
    
    var emptyTickersText = "Search & add symbol to see stock quotes"
    var titleText = "XCA Stocks"
    var attributionText = "Powered by Yahoo! finance API"
    
    @Published var subtitleText: String
    private let subtitleDf: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d MMM"
        return df
    }()
    
    init() {
        self.subtitleText = subtitleDf.string(from: Date())
    }
    
    func removeTickers(atOffsets offsets: IndexSet) {
        tickers.remove(atOffsets: offsets)
    }
    
    func isAddedToMyTicker(_ ticker: Ticker) -> Bool {
       return tickers.first(where: {$0.symbol == ticker.symbol}) != nil
    }
    
    func toggleTicker(_ ticker: Ticker) {
        if isAddedToMyTicker(ticker) {
            removeFromMyTickers(ticker)
        } else {
            addToMyTickers(ticker)
        }
    }
    
    private func addToMyTickers(_ ticker: Ticker) {
        tickers.append(ticker)
    }
    
    private func removeFromMyTickers(_ ticker: Ticker) {
        guard let index = tickers.firstIndex(where: {$0.symbol == ticker.symbol}) else { return }
        tickers.remove(at: index)
    }
    
    func openYahooFinance() {
        let url = URL(string: "https://finance.yahoo.com")!
        guard UIApplication.shared.canOpenURL(url) else {return}
        UIApplication.shared.open(url)
    }
}
