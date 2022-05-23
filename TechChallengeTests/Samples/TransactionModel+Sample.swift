//
//  TransactionModel+Sample.swift
//  TechChallengeTests
//
//  Created by Alexander Shchegryaev on 22/05/2022.
//

import Foundation
@testable import TechChallenge

extension TransactionModel {
    static func sample(
        id: Int = 0,
        name: String = "Txn_name",
        category: TransactionModel.Category = .health,
        amount: Double = 123.45,
        date: Date = Date(timeIntervalSince1970: 1653083712),
        accountName: String = "Account_name",
        provider: Provider = .amazon
    ) -> TransactionModel {
        .init(
            id: id,
            name: name,
            category: category,
            amount: amount,
            date: date,
            accountName: accountName,
            provider: provider
        )
    }
}
