//
//  InsightsView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 29/7/21.
//

import SwiftUI

struct InsightsView: View {
    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        List {
            RingView(spendingsData: viewModel.spendingsData)
                .scaledToFit()
            
            ForEach(TransactionModel.Category.allCases) { category in
                HStack {
                    Text(category.rawValue)
                        .font(.headline)
                        .foregroundColor(category.color)
                    Spacer()
                    Text(
                        "$\((spendings(for:category)).formatted())"
                    )
                    .bold()
                    .secondary()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Insights")
        .onAppear {
            viewModel.calculateSpendings()
        }
    }
    
    private func spendings(for category: TransactionModel.Category) -> Double {
        viewModel.spendingsData.spendingsByCategory[category] ?? 0
    }
}

#if DEBUG
struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView(
            viewModel: .init(
                transactionsRepository: TransactionsRepository()
            )
        )
        .previewLayout(.sizeThatFits)
    }
}
#endif
