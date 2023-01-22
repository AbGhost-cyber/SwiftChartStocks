//
//  ContentView.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/22.
//

import SwiftUI
import XCAStocksAPI

struct MainListView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var quotesVM = QuotesViewModel()
    
    var body: some View {
        tickerListView
            .listStyle(.plain)
            .overlay {overlayView}
            .toolbar {
                titleToolbar
                attributeToolbar
            }
    }
    private var tickerListView: some View {
        List {
            ForEach(appVM.tickers) { ticker in
                TickerListRowView(data: .init(symbol: ticker.symbol, name: ticker.shortname, price: quotesVM.priceForTicker(ticker), rowType: .main))
                    .contentShape(Rectangle())
                    .onTapGesture { }
            }
            .onDelete {appVM.removeTickers(atOffsets: $0)}
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        if appVM.tickers.isEmpty {
            EmptyStateView(text: appVM.emptyTickersText)
        }
    }
    private var titleToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            VStack(alignment: .leading, spacing: -4) {
                Text(appVM.titleText)
                Text(appVM.subtitleText)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }.font(.title2.weight(.heavy))
                .padding()
        }
    }
    
    private var attributeToolbar: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button {
                    appVM.openYahooFinance()
                } label: {
                    Text(appVM.attributionText)
                        .font(.caption.weight(.heavy))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
                .buttonStyle(.plain)
                Spacer()

            }
        }
    }
    
}

struct MainListView_Previews: PreviewProvider {
    @StateObject static var appVm: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = Ticker.stubs
        return vm
    }()
    @StateObject static var emptyVm: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = []
        return vm
    }()
    @StateObject static var quotesVM: QuotesViewModel = {
        let vm = QuotesViewModel()
        vm.quotesDict = Quote.stubsDict
        return vm
    }()
    static var previews: some View {
        Group {
            NavigationStack {
                MainListView(quotesVM: quotesVM)
            }
            .environmentObject(appVm)
            .previewDisplayName("With Tickers")
            NavigationStack {
                MainListView(quotesVM: quotesVM)
            }
            .environmentObject(emptyVm)
            .previewDisplayName("Without Tickers")
        }
    }
}
