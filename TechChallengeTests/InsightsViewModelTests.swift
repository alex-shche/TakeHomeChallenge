//
//  InsightsViewModelTests.swift
//  TechChallengeTests
//
//  Created by Alexander Shchegryaev on 23/05/2022.
//

import XCTest
@testable import TechChallenge

final class InsightsViewModelTests: XCTestCase {
    func testWhenAllTransactionsPinnedCalculatesSpendingsData() {
        let builder = Builder()
        var transactionsWereFetched = false
        builder.transactionsRepository.stubbedTransactions = {
            transactionsWereFetched = true
            return builder.transactions
        }
        builder.transactionsRepository.stubbedIsTransactionPinned = { _ in
            true
        }
        
        let viewModel = builder.make()
        
        let expectedSpendingsData = SpendingsData(
            spendingsByCategory: [.food: 11.4, .health: 20, .entertainment: 2.15],
            totalSpendings: 33.55
        )
        
        XCTAssertTrue(transactionsWereFetched)
        XCTAssertEqual(viewModel.spendingsData, expectedSpendingsData)
    }
    
    func testWhenSomeTransactionsPinnedCalculatesSpendingsData() {
        let builder = Builder()
        var transactionsWereFetched = false
        builder.transactionsRepository.stubbedTransactions = {
            transactionsWereFetched = true
            return builder.transactions
        }
        builder.transactionsRepository.stubbedIsTransactionPinned = { transactionId in
            Set([0, 2]).contains(transactionId)
        }
        
        let viewModel = builder.make()
        
        let expectedSpendingsData = SpendingsData(
            spendingsByCategory: [.food: 10, .entertainment: 2.15],
            totalSpendings: 12.15
        )
        
        XCTAssertTrue(transactionsWereFetched)
        XCTAssertEqual(viewModel.spendingsData, expectedSpendingsData)
    }
}

private final class Builder {
    let transactions: [TransactionModel] = [
        .sample(id: 0, category: .food, amount: 10.00),
        .sample(id: 1, category: .health, amount: 5.00),
        .sample(id: 2, category: .entertainment, amount: 2.15),
        .sample(id: 3, category: .food, amount: 1.4),
        .sample(id: 4, category: .health, amount: 15.00)
    ]
    
    let transactionsRepository = TransactionsRepositoryMock()
    
    func make() -> InsightsViewModel {
        .init(transactionsRepository: transactionsRepository)
    }
}
