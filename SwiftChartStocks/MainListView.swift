//
//  ContentView.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/22.
//

import SwiftUI
import XCAStocksAPI

struct MainListView: View {
    let api = XCAStocksAPI()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
