//
//  SwiftChartStocksApp.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/22.
//

import SwiftUI

@main
struct SwiftChartStocksApp: App {
    @StateObject var appVM = AppViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainListView()
            }
            .environmentObject(appVM)
        }
    }
}
