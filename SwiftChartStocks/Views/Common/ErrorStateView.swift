//
//  ErrorStateView.swift
//  SwiftChartStocks
//
//  Created by dremobaba on 2023/1/22.
//

import SwiftUI

struct ErrorStateView: View {
    let error: String
    var retryCallback: (()-> ())?
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 16) {
                Text(error)
                if let retryCallback {
                    Button("Retry", action: retryCallback)
                        .buttonStyle(.borderedProminent)
                }
            }
            Spacer()
        }.padding(64)
    }
}

struct ErrorStateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ErrorStateView(error: "An error occurred cabron") {}
                .previewDisplayName("With button")
            ErrorStateView(error: "An error occurred cabron")
                .previewDisplayName("Without button")
        }
            .previewLayout(.sizeThatFits)
    }
}
