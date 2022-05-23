//
//  FilteredTransactionListViewModel.swift
//  TechChallenge
//
//  Created by Alexander Shchegryaev on 17/05/2022.
//

import Foundation
import SwiftUI

final class FilteredTransactionListViewModel: ObservableObject {
    @Published private(set) var selectedCategory: TransactionModel.Category?
    
    var filteredTransactions: [TransactionModel] {
        filterTransactions(category: selectedCategory)
    }
    
    var floatingSumViewModel: FloatingSumViewModel {
        makeFloatingSumViewModel()
    }
    
    private(set) lazy var filters: [FilterItem] = makeFilters()
    
    let transactionsRepository: TransactionsRepositoryProtocol
    
    init(
        transactionsRepository: TransactionsRepositoryProtocol
    ) {
        self.transactionsRepository = transactionsRepository
    }
    
    func toggleTransactionPinState(identifier: TransactionModel.ID) {
        objectWillChange.send()
        transactionsRepository.toggleTransactionPinState(identifier: identifier)
    }
}

private extension FilteredTransactionListViewModel {
    func makeFilters() -> [FilterItem] {
        [makeAllTransactionFilter()] + makeCategoryTransactionFilters()
    }
    
    func makeAllTransactionFilter() -> FilterItem {
        .init(
            id: "ALL_TRANSACTIONS_CATEGORY",
            text: categoryName(nil),
            color: categoryColor(nil)
        ) { [weak self] in
            self?.selectedCategory = nil
        }
    }
    
    func makeCategoryTransactionFilters() -> [FilterItem] {
        TransactionModel.Category.allCases.map { category in
            FilterItem(
                id: category.id,
                text: categoryName(category),
                color: categoryColor(category),
                onTap: { [weak self] in
                    self?.selectedCategory = category
                }
            )
        }
    }
    
    func filterTransactions(category: TransactionModel.Category?) -> [TransactionModel] {
        guard let category = category else {
            return transactionsRepository.transactions
        }
        return transactionsRepository.transactions.filter { $0.category == category }
    }
    
    func makeFloatingSumViewModel() -> FloatingSumViewModel {
        let totalAmount = filteredTransactions
            .filter { transactionsRepository.isTransactionPinned(identifier: $0.id) }
            .reduce(0.0) {$0 + $1.amount }
        
        return .init(
            categoryName: categoryName(selectedCategory),
            categoryColor: categoryColor(selectedCategory),
            amount: totalAmount
        )
    }
    
    func categoryName(_ category: TransactionModel.Category?) -> String {
        category.map { $0.rawValue } ?? "all"
    }
    
    func categoryColor(_ category: TransactionModel.Category?) -> Color {
        category.map { $0.color } ?? .black
    }
}
