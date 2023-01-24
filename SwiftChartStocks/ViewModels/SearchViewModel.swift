//
//  SearchViewModel.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/24.
//

import Foundation
import Combine
import XCAStocksAPI
@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var query: String = ""
    @Published var phase: FetchPhase<[Ticker]> = .initial
    
    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var tickers: [Ticker] {
        phase.value ?? []
    }
    var error: Error? {
        phase.error
    }
    var isSearching: Bool {!trimmedQuery.isEmpty}
    
    var emptyListText: String {
        "Symbols not found for\n\"\(query)\""
    }
}
