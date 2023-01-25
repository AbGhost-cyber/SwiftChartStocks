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
    
    @Published var tickers: [Ticker] = [] {
        didSet { savedTickers() }
    }
    
    @Published var selectedTicker: Ticker?
    
    var emptyTickersText = "Search & add symbol to see stock quotes"
    var titleText = "XCA Stocks"
    var attributionText = "Powered by Yahoo! finance API"
    
    @Published var subtitleText: String
    private let subtitleDf: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d MMM"
        return df
    }()
    
    let tickerListRepo: TickerListRepository
    
    init(repository: TickerListRepository = TickerListRepoImpl()) {
        self.tickerListRepo = repository
        self.subtitleText = subtitleDf.string(from: Date())
        loadTickers()
    }
    
    private func loadTickers() {
        Task {[weak self] in
            guard let self  = self else { return }
            do {
                self.tickers = try await tickerListRepo.load()
            } catch {
                print(error.localizedDescription)
                self.tickers = []
            }
        }
    }
    
    private func savedTickers() {
        Task { [weak self] in
            guard let self  = self else { return }
            do {
                try await self.tickerListRepo.save(self.tickers)
            } catch {
                print(error.localizedDescription)
            }
        }
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
