//
//  TickerListRowData.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/22.
//

typealias PriceChange = (price: String, change: String)

struct TickerListRowData {

    enum RowType {
        case main
        case search(isSaved: Bool, onButtonTapped: () -> Void)
    }
    let symbol: String
    let name: String
    let price: PriceChange?
    let rowType: RowType
}
