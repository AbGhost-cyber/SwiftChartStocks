//
//  SearchView.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/24.
//

import SwiftUI
import XCAStocksAPI

struct SearchView: View {
    @EnvironmentObject var appVm: AppViewModel
    @StateObject var quotesVm = QuotesViewModel()
    @ObservedObject var searchVm: SearchViewModel
    
    var body: some View {
        List(searchVm.tickers) { ticker in
            TickerListRowView(data: .init(symbol: ticker.symbol, name: ticker.shortname, price: quotesVm.priceForTicker(ticker), rowType: .search(isSaved: appVm.isAddedToMyTicker(ticker), onButtonTapped: {
                Task { @MainActor in
                    appVm.toggleTicker(ticker)
                }
            })))
            .contentShape(Rectangle())
            .onTapGesture {
                appVm.selectedTicker = ticker
            }
        }
        .listStyle(.plain)
        .refreshable {
            await quotesVm.fetchQuotes(tickers: searchVm.tickers)
        }
        .task(id: searchVm.tickers) {
            await quotesVm.fetchQuotes(tickers: searchVm.tickers)
        }
        .overlay {listSearchOverlay}
    }
    
    @ViewBuilder
    private var listSearchOverlay: some View {
        switch searchVm.phase {
        case .failure(let error):
            ErrorStateView(error: error.localizedDescription){
                Task { await searchVm.searchTickers()}
            }
        case .empty:
            EmptyStateView(text: searchVm.emptyListText)
        case .fetching:
            LoadingStateView()
        default: EmptyView()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    
    @StateObject static var stubbedSearchVM: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = { Ticker.stubs }
        return SearchViewModel(query: "Apple", stocksAPI: mock)
    }()
    
    @StateObject static var emptySearchVM: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = { [] }
        return SearchViewModel(query: "Theranos", stocksAPI: mock)
    }()
    
    @StateObject static var loadingSearchVM: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = {
            await withCheckedContinuation { _ in }
        }
        return SearchViewModel(query: "Apple", stocksAPI: mock)
    }()
    
    @StateObject static var errorSearchVM: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = { throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "An Error has been occured"]) }
        return SearchViewModel(query: "Apple", stocksAPI: mock)
    }()
    
    @StateObject static var appVM: AppViewModel = {
        var mock = MockTickerListRepository()
        mock.stubbedLoad = { Array(Ticker.stubs.prefix(upTo: 2)) }
        return AppViewModel(repository: mock)
    }()
    
    static var quotesVM: QuotesViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedFetchQuotesCallback = { Quote.stubs }
        return QuotesViewModel(stocksAPI: mock)
    }()
    
    static var previews: some View {
        Group {
            NavigationStack {
                SearchView(quotesVm: quotesVM, searchVm: stubbedSearchVM)
            }
            .searchable(text: $stubbedSearchVM.query)
            .previewDisplayName("Results")
            
            NavigationStack {
                SearchView(quotesVm: quotesVM, searchVm: emptySearchVM)
            }
            .searchable(text: $emptySearchVM.query)
            .previewDisplayName("Empty Results")
            
            NavigationStack {
                SearchView(quotesVm: quotesVM, searchVm: loadingSearchVM)
            }
            .searchable(text: $loadingSearchVM.query)
            .previewDisplayName("Loading State")
            
            NavigationStack {
                SearchView(quotesVm: quotesVM, searchVm: errorSearchVM)
            }
            .searchable(text: $errorSearchVM.query)
            .previewDisplayName("Error State")
            
            
        }.environmentObject(appVM)
    }
}
