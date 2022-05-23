//
//  FiltersView.swift
//  TechChallenge
//
//  Created by Alexander Shchegryaev on 17/05/2022.
//

import SwiftUI

struct FiltersView: View {
    let items: [FilterItem]
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(items) {
                    FilterItemView(item: $0)
                }
            }
            .padding()
        }
        .background(Color.accentColor.opacity(0.8))
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FiltersView(
                items: [
                    .init(
                        id: "all",
                        text: "all",
                        color: .black,
                        onTap: {})
                ] +
                TransactionModel.Category.allCases.map {
                    .init(
                        id: $0.rawValue,
                        text: $0.rawValue,
                        color: $0.color,
                        onTap: {}
                    )
                }
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
