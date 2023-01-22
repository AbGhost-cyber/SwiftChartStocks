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
    
    func priceForTicker(_ ticker: Ticker) -> PriceChange? {
        guard let quote = quotesDict[ticker.symbol],
              let price = quote.regularPriceText,
              let change = quote.regularDiffText
        else { return nil }
        return (price, change)
    }
}
