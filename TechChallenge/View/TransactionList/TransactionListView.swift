//
//  TransactionListView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI

struct TransactionListView: View {
    let viewModel: TransactionListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.transactions) { transaction in
                TransactionView(
                    transaction: transaction,
                    isPinned: viewModel.isTransactionPinned(transaction)
                ).onTapGesture {
                    viewModel.onTransactionTap(transaction)
                }
            }
        }
        .animation(.easeIn)
        .listStyle(PlainListStyle())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Transactions")
    }
}

#if DEBUG
struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(
            viewModel: .init(
                transactions: ModelData.sampleTransactions,
                repository: TransactionsRepository(),
                onTransactionTap: { _ in }
            )
        )
    }
}
#endif
