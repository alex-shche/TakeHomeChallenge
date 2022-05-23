//
//  FilteredTransactionListViewModelTests.swift
//  TechChallengeTests
//
//  Created by Alexander Shchegryaev on 22/05/2022.
//

import XCTest
@testable import TechChallenge

final class FilteredTransactionListViewModelTests: XCTestCase {
    func testWhenNoCategorySelectedReturnsAllTransactions() {
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
        XCTAssertNil(viewModel.selectedCategory)
        XCTAssertFalse(transactionsWereFetched)
        
        let filteredTransactions = viewModel.filteredTransactions
        XCTAssertTrue(transactionsWereFetched)
        XCTAssertEqual(filteredTransactions, builder.transactions)
        
        let sumViewModel = viewModel.floatingSumViewModel
        XCTAssertEqual(sumViewModel.categoryName, "all")
        XCTAssertEqual(sumViewModel.categoryColor, .black)
        XCTAssertEqual(sumViewModel.amount, 33.55, accuracy: 0.0001)
    }
    
    func testWhenAllSelectedReturnsAllTransactions() {
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
        let filterItem = viewModel.filters.first(where: {$0.text == "all"})
        XCTAssertNotNil(filterItem)
        filterItem?.onTap()
        
        XCTAssertNil(viewModel.selectedCategory)
        XCTAssertFalse(transactionsWereFetched)
        
        let filteredTransactions = viewModel.filteredTransactions
        XCTAssertTrue(transactionsWereFetched)
        XCTAssertEqual(filteredTransactions, builder.transactions)
        
        let sumViewModel = viewModel.floatingSumViewModel
        XCTAssertEqual(sumViewModel.categoryName, "all")
        XCTAssertEqual(sumViewModel.categoryColor, .black)
        XCTAssertEqual(sumViewModel.amount, 33.55, accuracy: 0.0001)
    }
    
    func testWhenAllSelectedReturnsAllTransactionsAndSumPinned() {
        let builder = Builder()
        var transactionsWereFetched = false
        builder.transactionsRepository.stubbedTransactions = {
            transactionsWereFetched = true
            return builder.transactions
        }
        builder.transactionsRepository.stubbedIsTransactionPinned = { transactionId in
            Set([1, 2, 4]).contains(transactionId)
        }
        
        let viewModel = builder.make()
        let filterItem = viewModel.filters.first(where: {$0.text == "all"})
        XCTAssertNotNil(filterItem)
        filterItem?.onTap()
        
        XCTAssertNil(viewModel.selectedCategory)
        XCTAssertFalse(transactionsWereFetched)
        
        let filteredTransactions = viewModel.filteredTransactions
        XCTAssertTrue(transactionsWereFetched)
        XCTAssertEqual(filteredTransactions, builder.transactions)
        
        let sumViewModel = viewModel.floatingSumViewModel
        XCTAssertEqual(sumViewModel.categoryName, "all")
        XCTAssertEqual(sumViewModel.categoryColor, .black)
        XCTAssertEqual(sumViewModel.amount, 22.15, accuracy: 0.0001)
    }
    
    func testsWhenFoodSelectedReturnsFoodTransactions() {
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
        let filterItem = viewModel.filters.first(where: {$0.text == TransactionModel.Category.food.rawValue})
        XCTAssertNotNil(filterItem)
        filterItem?.onTap()
        
        XCTAssertEqual(viewModel.selectedCategory, .food)
        XCTAssertFalse(transactionsWereFetched)
        
        let filteredTransactions = viewModel.filteredTransactions
        XCTAssertTrue(transactionsWereFetched)
        XCTAssertEqual(
            filteredTransactions,
            [
                builder.transactions[0],
                builder.transactions[3]
            ]
        )
        
        let sumViewModel = viewModel.floatingSumViewModel
        XCTAssertEqual(sumViewModel.categoryName, TransactionModel.Category.food.rawValue)
        XCTAssertEqual(sumViewModel.categoryColor, TransactionModel.Category.food.color)
        XCTAssertEqual(sumViewModel.amount, 11.4, accuracy: 0.0001)
    }
    
    func testsWhenHealthSelectedReturnsHealthTransactionsAndSumPinned() {
        let builder = Builder()
        var transactionsWereFetched = false
        builder.transactionsRepository.stubbedTransactions = {
            transactionsWereFetched = true
            return builder.transactions
        }
        builder.transactionsRepository.stubbedIsTransactionPinned = { transactionId in
            transactionId != 1
        }
        
        let viewModel = builder.make()
        let filterItem = viewModel.filters.first(where: {$0.text == TransactionModel.Category.health.rawValue})
        XCTAssertNotNil(filterItem)
        filterItem?.onTap()
        
        XCTAssertEqual(viewModel.selectedCategory, .health)
        XCTAssertFalse(transactionsWereFetched)
        
        let filteredTransactions = viewModel.filteredTransactions
        XCTAssertTrue(transactionsWereFetched)
        XCTAssertEqual(
            filteredTransactions,
            [
                builder.transactions[1],
                builder.transactions[4]
            ]
        )
        
        let sumViewModel = viewModel.floatingSumViewModel
        XCTAssertEqual(sumViewModel.categoryName, TransactionModel.Category.health.rawValue)
        XCTAssertEqual(sumViewModel.categoryColor, TransactionModel.Category.health.color)
        XCTAssertEqual(sumViewModel.amount, 15, accuracy: 0.0001)
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
    
    func make() -> FilteredTransactionListViewModel {
        .init(transactionsRepository: transactionsRepository)
    }
}
