//
//  TechChallengeApp.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI

@main
struct TechChallengeApp: App {
    private let transactionsRepository = TransactionsRepository()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    FilteredTransactionListView(
                        viewModel: .init(
                            transactionsRepository: transactionsRepository
                        )
                    )
                }
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet")
                }
                
                NavigationView {
                    InsightsView(viewModel: .init(transactionsRepository: transactionsRepository))
                }
                .tabItem {
                    Label("Insights", systemImage: "chart.pie.fill")
                }
            }
        }
    }
}
