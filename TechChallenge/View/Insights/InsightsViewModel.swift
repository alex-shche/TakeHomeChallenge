//
//  InsightsViewModel.swift
//  TechChallenge
//
//  Created by Alexander Shchegryaev on 22/05/2022.
//

import Foundation

struct SpendingsData: Equatable {
    let spendingsByCategory: [TransactionModel.Category: Double]
    let totalSpendings: Double
}

final class InsightsViewModel: ObservableObject {
    @Published private(set) var spendingsData: SpendingsData
    
    var transactions: [TransactionModel] {
        transactionsRepository.transactions
    }
    
    let transactionsRepository: TransactionsRepositoryProtocol
    
    init(transactionsRepository: TransactionsRepositoryProtocol) {
        self.transactionsRepository = transactionsRepository
        self.spendingsData = .init(spendingsByCategory: [:], totalSpendings: 0)
        calculateSpendings()
    }
    
    func calculateSpendings() {
        var spendingsByCategory = [TransactionModel.Category: Double]()
        var totalSpendings = 0.0
        for transaction in transactions where transactionsRepository.isTransactionPinned(identifier: transaction.id) {
            spendingsByCategory[transaction.category, default: 0] += transaction.amount
            totalSpendings += transaction.amount
        }
        spendingsData = .init(spendingsByCategory: spendingsByCategory, totalSpendings: totalSpendings)
    }
}
