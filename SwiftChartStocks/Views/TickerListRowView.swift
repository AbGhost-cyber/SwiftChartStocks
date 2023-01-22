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
                    
                }
            }
        }
    }
    
    @ViewBuilder
    func image(isSaved: Bool) -> some View {
        if isSaved {
            Image(systemName: "checkmark.circle.fill")
                .symbolRenderingMode(.palette)
        } else {
            
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
