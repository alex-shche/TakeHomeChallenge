//
//  TransactionListViewModel.swift
//  TechChallenge
//
//  Created by Alexander Shchegryaev on 22/05/2022.
//

import Foundation

final class TransactionListViewModel {
    let transactions: [TransactionModel]
    let onTransactionTap: (TransactionModel) -> Void
    
    private let repository: TransactionsRepositoryProtocol
    
    init(
        transactions: [TransactionModel],
        repository: TransactionsRepositoryProtocol,
        onTransactionTap: @escaping (TransactionModel) -> Void
    ) {
        self.transactions = transactions
        self.repository = repository
        self.onTransactionTap = onTransactionTap
    }
    
    func isTransactionPinned(_ transaction: TransactionModel) -> Bool {
        repository.isTransactionPinned(identifier: transaction.id)
    }
}
