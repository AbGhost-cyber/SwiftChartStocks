//
//  StockTickerView.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/25.
//

import SwiftUI
import XCAStocksAPI

struct StockTickerView: View {
    
    @StateObject var quoteVM: TickerQuoteViewModel
    @Environment(\.dismiss) private var dismiss
    @State var selectedRange = ChartRange.oneDay
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView.padding(.horizontal)
            Divider()
                .padding(.vertical, 8)
                .padding(.horizontal)
            scrollView
        }
        .padding(.top)
        .background(Color(uiColor: .systemBackground))
        .task {
            await quoteVM.fetchQuote()
        }
    }
    
    private var scrollView: some View {
        ScrollView {
            priceDiffRowView
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
                .padding(.horizontal)
            Divider()
            DateRangePickerView(selectedRange: $selectedRange)
            Divider()
            
            Text("Chart View Placeholder")
                .padding(.horizontal)
                .frame(maxWidth: .infinity, minHeight: 220)
            
            Divider().padding([.horizontal, .top])
            
            quoteDetailRowView
                .frame(maxWidth: .infinity, minHeight: 80)
        }.scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    @ViewBuilder
    private var quoteDetailRowView: some View {
        switch quoteVM.phase {
        case .fetching: LoadingStateView()
        case .failure(let error): ErrorStateView(error: "Quote: \(error.localizedDescription)")
                .padding(.horizontal)
        case .success(let quote):
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(quote.columnItems) {
                        QuoteDetailRowColumnView(item: $0)
                    }
                }
                .padding(.horizontal)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
            }
            .scrollIndicators(.hidden)
    
            
        default: EmptyView()
        }
    }
    
    private var priceDiffRowView: some View {
        VStack(alignment: .leading, spacing:  8) {
            if let quote = quoteVM.quote {
                HStack {
                    if quote.isTrading,
                       let price = quote.regularPriceText,
                       let diff = quote.regularDiffText{
                        priceDiffStackView(price: price, diff: diff, caption: nil)
                    } else {
                        if let atCloseText = quote.regularPriceText,
                           let atCloseDiffText = quote.regularDiffText {
                            priceDiffStackView(price: atCloseText, diff: atCloseDiffText, caption: "At Close")
                        }
                        if let afterHourText = quote.postPriceText,
                           let afterHourDiffText = quote.postPriceDiffText {
                            priceDiffStackView(price: afterHourText, diff: afterHourDiffText, caption: "After Hours")
                        }
                    }
                    Spacer()
                }
            }
            exchangeCurrencyView
        }
    }
    
    private var exchangeCurrencyView: some View {
        HStack(spacing: 4) {
            if let exchange = quoteVM.ticker.exchDisp {
                Text(exchange)
            }
            
            if let currency = quoteVM.quote?.currency {
                Text("·")
                Text(currency)
            }
        }
        .font(.subheadline.weight(.semibold))
        .foregroundColor(Color(uiColor: .secondaryLabel))
    }
    
    
    
    private func priceDiffStackView(price: String, diff: String, caption: String?) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline, spacing: 16) {
                Text(price).font(.headline.bold())
                Text(diff).font(.subheadline.weight(.semibold))
                    .foregroundColor(diff.hasPrefix("-") ? .red : .green)
            }
            if let caption {
                Text(caption)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
        }
    }
    private var headerView: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(quoteVM.ticker.symbol)
                .font(.title)
                .bold()
            if let shortName = quoteVM.ticker.shortname {
                Text(shortName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
            Spacer()
            closeButton
        }
    }
    
    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Circle()
                .frame(width: 36)
                .foregroundColor(.gray.opacity(0.1))
                .overlay {
                    Image(systemName: "xmark")
                        .font(.system(size: 18).bold())
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
        }
        .buttonStyle(.plain)
        
    }
}

struct StockTickerView_Previews: PreviewProvider {
    static var tradingStubsQuoteVM: TickerQuoteViewModel = {
        var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            [Quote.stub(isTrading: true)]
        }
        return TickerQuoteViewModel(ticker: .stub, stocksAPI: mockAPI)
    }()
    
    static var closedStubsQuoteVM: TickerQuoteViewModel = {
        var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            [Quote.stub(isTrading: false)]
        }
        return TickerQuoteViewModel(ticker: .stub, stocksAPI: mockAPI)
    }()
    
    
    static var loadingStubsQuoteVM: TickerQuoteViewModel = {
        var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            await withCheckedContinuation { _ in
                
            }
        }
        return TickerQuoteViewModel(ticker: .stub, stocksAPI: mockAPI)
    }()
    
    
    static var errorStubsQuoteVM: TickerQuoteViewModel = {
        var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            throw NSError(domain: "error", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error has been occured"])
        }
        return TickerQuoteViewModel(ticker: .stub, stocksAPI: mockAPI)
    }()
    
    static var previews: some View {
        Group {
            StockTickerView(quoteVM: tradingStubsQuoteVM)
                .previewDisplayName("Trading")
                .frame(height: 700)
            
            StockTickerView(quoteVM: closedStubsQuoteVM)
                .previewDisplayName("Closed")
                .frame(height: 700)
            
            StockTickerView(quoteVM: loadingStubsQuoteVM)
                .previewDisplayName("Loading Quote")
                .frame(height: 700)
            
            StockTickerView(quoteVM: errorStubsQuoteVM)
                .previewDisplayName("Error Quote")
                .frame(height: 700)
            
        }.previewLayout(.sizeThatFits)
    }
}
