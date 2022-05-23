//
//  TransactionsRepositoryMock.swift
//  TechChallengeTests
//
//  Created by Alexander Shchegryaev on 22/05/2022.
//

@testable import TechChallenge

final class TransactionsRepositoryMock: TransactionsRepositoryProtocol {
    var stubbedTransactions: () -> [TransactionModel] = {
        fatalError("mock TransactionsRepositoryMock.transactions")
    }
    
    var transactions: [TransactionModel] {
        stubbedTransactions()
    }
    
    var stubbedIsTransactionPinned: (TransactionModel.ID) -> Bool = { _ in
        fatalError("mock TransactionsRepositoryMock.isTransactionPinned")
    }
    func isTransactionPinned(identifier: TransactionModel.ID) -> Bool {
        stubbedIsTransactionPinned(identifier)
    }
    
    var stubbedPinTransaction: (TransactionModel.ID) -> Void = { _ in
        fatalError("mock TransactionsRepositoryMock.pinTransaction")
    }
    func pinTransaction(identifier: TransactionModel.ID) {
        stubbedPinTransaction(identifier)
    }
    
    var stubbedUnpinTransaction: (TransactionModel.ID) -> Void = { _ in
        fatalError("mock TransactionsRepositoryMock.unpinTransaction")
    }
    func unpinTransaction(identifier: TransactionModel.ID) {
        stubbedUnpinTransaction(identifier)
    }
}
