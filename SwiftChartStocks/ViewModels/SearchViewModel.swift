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
    
    private let stocksAPI: StocksAPI
    private var cancellables = Set<AnyCancellable>()
    
    init(query: String = "", stocksAPI: StocksAPI = XCAStocksAPI()) {
        self.query = query
        self.stocksAPI = stocksAPI
        
        startObserving()
    }
    
    func startObserving() {
        $query
            .debounce(for: 0.25, scheduler: DispatchQueue.main)
            .sink { _ in
                Task { [weak self] in await self?.searchTickers()}
            }.store(in: &cancellables)
        
        $query
            .filter { $0.isEmpty }
            .sink { [weak self] _ in self?.phase = .initial}
            .store(in: &cancellables)
    }
    func searchTickers() async {
        let searchQuery = trimmedQuery
        guard !searchQuery.isEmpty else {
            return
        }
        phase = .fetching
        
        do {
            let tickers = try await stocksAPI.searchTickers(query: searchQuery, isEquityTypeOnly: true)
            if searchQuery != trimmedQuery { return }
            if tickers.isEmpty {
                phase = .empty
            } else {
                phase = .success(tickers)
            }
        } catch {
            if searchQuery != trimmedQuery { return }
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
}
