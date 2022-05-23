//
//  FilteredTransactionListView.swift
//  TechChallenge
//
//  Created by Alexander Shchegryaev on 17/05/2022.
//

import SwiftUI

struct FilteredTransactionListView: View {
    @ObservedObject var viewModel: FilteredTransactionListViewModel
    
    var body: some View {
        if #available(iOS 15.0, *) {
            VStack(spacing: 0) {
                FiltersView(items: viewModel.filters)
                TransactionListView(
                    viewModel: .init(
                        transactions: viewModel.filteredTransactions,
                        repository: viewModel.transactionsRepository,
                        onTransactionTap: { transaction in
                            viewModel.toggleTransactionPinState(
                                identifier: transaction.id
                            )
                        }
                    )
                ).safeAreaInset(edge: .bottom) {
                    footer
                }
            }
        } else {
            // .safeAreaInset is only available for iOS 15
            // all my attempts to do something similar for iOS 14 were unsuccessfull (there was a redundant separator)
            // so, for iOS 14 the view isn't "floating". It's added after the list
            VStack(spacing: 0) {
                FiltersView(items: viewModel.filters)
                TransactionListView(
                    viewModel: .init(
                        transactions: viewModel.filteredTransactions,
                        repository: viewModel.transactionsRepository,
                        onTransactionTap: { transaction in
                            viewModel.toggleTransactionPinState(
                                identifier: transaction.id
                            )
                        }
                    )
                )
                footer
            }
        }
    }
    
    private var footer: some View {
        FloatingSumView(
            model: viewModel.floatingSumViewModel
        )
    }
}

struct FilteredTransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        FilteredTransactionListView(
            viewModel: .init(
                transactionsRepository: TransactionsRepository()
            )
        )
    }
}
