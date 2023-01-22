//
//  Quote+Extensions.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/22.
//

import Foundation
import XCAStocksAPI

extension Quote {
    var regularPriceText: String? {
        Utils.format(value: regularMarketPrice)
    }
    var regularDiffText: String? {
        guard let text = Utils.format(value: regularMarketChange)
        else {return nil}
        return text.hasPrefix("-") ? text : "+\(text)"
    }
}
