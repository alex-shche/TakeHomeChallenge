//
//  FilterItemView.swift
//  TechChallenge
//
//  Created by Alexander Shchegryaev on 17/05/2022.
//

import SwiftUI

struct FilterItemView: View {
    let item: FilterItem
    
    var body: some View {
        Button(
            action: { item.onTap() }
        ) {
            Text(item.text)
                .font(.system(.title2))
                .bold()
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .foregroundColor(.white)
                .background(item.color)
        }
        .clipShape(Capsule())
    }
}

struct FilterItemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FilterItemView(
                item: .init(
                    id: "food",
                    text: "food",
                    color: .green,
                    onTap: {}
                )
            )
            FilterItemView(
                item: .init(
                    id: "entertainment",
                    text: "entertainment",
                    color: .orange,
                    onTap: {}
                )
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
