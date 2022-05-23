//
//  TransactionsRepository.swift
//  TechChallenge
//
//  Created by Alexander Shchegryaev on 22/05/2022.
//

import Foundation
import Combine

protocol TransactionsRepositoryProtocol {
    var transactions: [TransactionModel] { get }
    func isTransactionPinned(identifier: TransactionModel.ID) -> Bool
    func pinTransaction(identifier: TransactionModel.ID)
    func unpinTransaction(identifier: TransactionModel.ID)
    func toggleTransactionPinState(identifier: TransactionModel.ID)
}

extension TransactionsRepositoryProtocol {
    func toggleTransactionPinState(identifier: TransactionModel.ID) {
        if isTransactionPinned(identifier: identifier) {
            unpinTransaction(identifier: identifier)
        } else {
            pinTransaction(identifier: identifier)
        }
    }
}

final class TransactionsRepository: TransactionsRepositoryProtocol {
    let transactions: [TransactionModel]
    private var pinnedTransactions: Set<TransactionModel.ID>
    
    init(transactions: [TransactionModel]) {
        self.transactions = transactions
        self.pinnedTransactions = Set(transactions.map {$0.id })
    }
    
    convenience init() {
        self.init(transactions: ModelData.sampleTransactions)
    }
    
    func isTransactionPinned(identifier: TransactionModel.ID) -> Bool {
        pinnedTransactions.contains(identifier)
    }
    
    func pinTransaction(identifier: TransactionModel.ID) {
        pinnedTransactions.insert(identifier)
    }
    
    func unpinTransaction(identifier: TransactionModel.ID) {
        pinnedTransactions.remove(identifier)
    }
}

