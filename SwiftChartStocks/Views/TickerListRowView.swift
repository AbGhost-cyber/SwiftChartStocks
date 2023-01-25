//
//  TickerListRowView.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/22.
//

import SwiftUI

struct TickerListRowView: View {
    let data: TickerListRowData
    
    var body: some View {
        HStack(alignment: .center) {
            if case let .search(isSaved, onButtonTapped) = data.rowType {
                Button {
                    onButtonTapped()
                } label: {
                    image(isSaved: isSaved)
                }
                .buttonStyle(.plain)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(data.symbol).font(.headline.bold())
                if let name = data.name {
                    Text(name)
                        .font(.subheadline)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
            }
            Spacer()
            if let (price, change) = data.price {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(price)
                    priceChangeView(text: change)
                }
            }
        }
    }
    
    @ViewBuilder
    func image(isSaved: Bool) -> some View {
        if isSaved {
            Image(systemName: "checkmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.white, Color.accentColor)
                .imageScale(.large)
        } else {
            Image(systemName: "plus.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.accentColor, Color.secondary.opacity(0.3))
                .imageScale(.large)
        }
    }
    
    @ViewBuilder
    func priceChangeView(text: String) -> some View {
        let color: Color = text.hasPrefix("-") ? .red : .green
        
        if case .main = data.rowType {
            ZStack(alignment: .trailing) {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(color)
                    .frame(height: 24)
                Text(text)
                    .foregroundColor(.white)
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
            }.fixedSize()
        } else {
            Text(text)
                .foregroundColor(color)
        }
    }
}

struct TickerListRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            Text("Main List")
                .font(.largeTitle.bold())
                .padding()
            VStack {
                TickerListRowView(data: appleTickerListRData(rowType: .main))
                Divider()
                TickerListRowView(data: teslaTickerListRData(rowType: .main))
            }.padding()
            Text("Search List")
                .font(.largeTitle.bold())
                .padding()
            VStack {
                TickerListRowView(data: appleTickerListRData(rowType: .search(isSaved: true, onButtonTapped: {})))
                Divider()
                TickerListRowView(data: teslaTickerListRData(rowType: .search(isSaved: false, onButtonTapped: {})))
            }.padding()
        }
        .previewLayout(.sizeThatFits)
    }
    
    static func appleTickerListRData(rowType: TickerListRowData.RowType) -> TickerListRowData {
        .init(symbol: "AAPL", name: "Apple Inc", price: ("100.0", "+0.7"), rowType: rowType)
    }
    static func teslaTickerListRData(rowType: TickerListRowData.RowType) -> TickerListRowData {
        .init(symbol: "TSLA", name: "Tesla", price: ("250.0", "-18.9"), rowType: rowType)
    }
}
