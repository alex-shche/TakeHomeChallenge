//
//  FloatingSumView.swift
//  TechChallenge
//
//  Created by Alexander Shchegryaev on 17/05/2022.
//

import SwiftUI

struct FloatingSumViewModel {
    let categoryName: String
    let categoryColor: Color
    let amount: Double
}

struct FloatingSumView: View {
    let model: FloatingSumViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(model.categoryName)
                    .foregroundColor(model.categoryColor)
                    .font(.system(.headline))
            }
            HStack {
                Text("Total spent:")
                    .secondary()
                Spacer()
                Text("$\(model.amount.formatted())")
                    .bold()
                    .secondary()
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.accentColor, lineWidth: 2)
        )
        .padding(8)
        .background(Color.white)
    }
}

#if DEBUG
struct FloatingSumView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingSumView(
            model: .init(
                categoryName: "food",
                categoryColor: .green,
                amount: 200.45
            )
        )
        .previewLayout(.sizeThatFits)
    }
}
#endif
