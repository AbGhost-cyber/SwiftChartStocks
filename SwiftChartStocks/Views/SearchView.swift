//
//  SearchView.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/24.
//

import SwiftUI
import XCAStocksAPI

struct SearchView: View {
    @ObservedObject var searchVm: SearchViewModel
    @EnvironmentObject var appVm: AppViewModel
    @StateObject var quotesVm: QuotesViewModel
    
    var body: some View {
        List(searchVm.tickers) { ticker in
            TickerListRowView(data: .init(symbol: ticker.symbol, name: ticker.shortname, price: quotesVm.priceForTicker(ticker), rowType: .search(isSaved: appVm.isAddedToMyTicker(ticker), onButtonTapped: {
                appVm.toggleTicker(ticker)
            })))
            .contentShape(Rectangle())
            .onTapGesture {
                
            }
        }
        .listStyle(.plain)
        .overlay {listSearchOverlay}
    }
    
    @ViewBuilder
    private var listSearchOverlay: some View {
        switch searchVm.phase {
        case .failure(let error):
            ErrorStateView(error: error.localizedDescription){}
        case .empty:
            EmptyStateView(text: searchVm.emptyListText)
        case .fetching:
            LoadingStateView()
        default: EmptyView()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    @StateObject static var stubbedSearchVm: SearchViewModel = {
        let vm = SearchViewModel()
        vm.phase = .success(Ticker.stubs)
        return vm
    }()
    @StateObject static var emptySearchVm: SearchViewModel = {
        let vm = SearchViewModel()
        vm.query = "Theranos"
        vm.phase = .empty
        return vm
    }()
    @StateObject static var loadingSearchVm: SearchViewModel = {
        let vm = SearchViewModel()
        vm.phase = .fetching
        return vm
    }()
    @StateObject static var errorSearchVm: SearchViewModel = {
        let vm = SearchViewModel()
        vm.phase = .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "An Error has occurred"]))
        return vm
    }()
    @StateObject static var appVm: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = Ticker.stubs
        return vm
    }()
    @StateObject static var quotesVm: QuotesViewModel = {
        let vm = QuotesViewModel()
        vm.quotesDict = Quote.stubsDict
        return vm
    }()
    static var previews: some View {
        Group {
            NavigationStack {
                SearchView(searchVm: stubbedSearchVm, quotesVm: quotesVm)
            }.searchable(text: $stubbedSearchVm.query)
                .previewDisplayName("Results")
            NavigationStack {
                SearchView(searchVm: emptySearchVm, quotesVm: quotesVm)
            }.searchable(text: $stubbedSearchVm.query)
                .previewDisplayName("Empty")
            NavigationStack {
                SearchView(searchVm: loadingSearchVm, quotesVm: quotesVm)
            }.searchable(text: $stubbedSearchVm.query)
                .previewDisplayName("Loading")
            NavigationStack {
                SearchView(searchVm: errorSearchVm, quotesVm: quotesVm)
            }.searchable(text: $stubbedSearchVm.query)
                .previewDisplayName("Error")
        }.environmentObject(appVm)    }
}
