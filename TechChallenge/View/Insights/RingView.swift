//
//  RingView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 29/7/21.
//

import SwiftUI

fileprivate typealias Category = TransactionModel.Category

struct RingView: View {
    let spendingsData: SpendingsData
    let drawingData: [DrawingData]
    
    init(spendingsData: SpendingsData) {
        self.spendingsData = spendingsData
        self.drawingData = RingView.calculateDrawingData(spendingsData: spendingsData)
    }
    
    private func ratio(for categoryIndex: Int) -> Double {
        guard categoryIndex < drawingData.count else { return 0 }
        return drawingData[categoryIndex].ratio
    }
    
    private func offset(for categoryIndex: Int) -> Double {
        guard categoryIndex < drawingData.count else { return 0 }
        return drawingData[categoryIndex].offset
    }

    private func gradient(for categoryIndex: Int) -> AngularGradient {
        let color = Category[categoryIndex]?.color ?? .black
        return AngularGradient(
            gradient: Gradient(colors: [color.unsaturated, color]),
            center: .center,
            startAngle: .init(
                offset: offset(for: categoryIndex),
                ratio: 0
            ),
            endAngle: .init(
                offset: offset(for: categoryIndex),
                ratio: ratio(for: categoryIndex)
            )
        )
    }
    
    private func percentageText(for categoryIndex: Int) -> String {
        "\((ratio(for: categoryIndex) * 100).formatted(hasDecimals: false))%"
    }
    
    var body: some View {
        ZStack {
            ForEach(Category.allCases.indices) { categoryIndex in
                if let category = Category[categoryIndex],
                      spendingsData.spendingsByCategory[category] ?? 0 > 0 {
                    PartialCircleShape(
                        offset: offset(for: categoryIndex),
                        ratio: ratio(for: categoryIndex)
                    )
                    .stroke(
                        gradient(for: categoryIndex),
                        style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                    )
                    .overlay(
                        PercentageText(
                            offset: offset(for: categoryIndex),
                            ratio: ratio(for: categoryIndex),
                            text: percentageText(for: categoryIndex)
                        )
                    )
                }
            }
        }
    }
    
    private static func calculateDrawingData(
        spendingsData: SpendingsData
    ) -> [DrawingData] {
        var data = [DrawingData]()
        var offset = 0.0
        for category in Category.allCases {
            guard spendingsData.totalSpendings > 0 else {
                return []
            }
            let categorySpendings =  spendingsData.spendingsByCategory[category] ?? 0
            let ratio = categorySpendings / spendingsData.totalSpendings
            data.append(.init(offset: offset, ratio: ratio))
            offset += ratio
        }
        return data
    }
}


extension RingView {
    struct DrawingData {
        let offset: Double
        let ratio: Double
    }
    
    struct PartialCircleShape: Shape {
        let offset: Double
        let ratio: Double
        
        func path(in rect: CGRect) -> Path {
            Path(offset: offset, ratio: ratio, in: rect)
        }
    }
    
    struct PercentageText: View {
        let offset: Double
        let ratio: Double
        let text: String
        
        private func position(for geometry: GeometryProxy) -> CGPoint {
            let rect = geometry.frame(in: .local)
            let path = Path(offset: offset, ratio: ratio / 2.0, in: rect)
            return path.currentPoint ?? .zero
        }
        
        var body: some View {
            GeometryReader { geometry in
                Text(text)
                    .percentage()
                    .position(position(for: geometry))
            }
        }
    }
}

#if DEBUG
struct RingView_Previews: PreviewProvider {
    static var sampleRing: some View {
        ZStack {
            RingView.PartialCircleShape(offset: 0.0, ratio: 0.15)
                .stroke(
                    Color.red,
                    style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                )
            
            RingView.PartialCircleShape(offset: 0.15, ratio: 0.5)
                .stroke(
                    Color.green,
                    style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                )
                
            RingView.PartialCircleShape(offset: 0.65, ratio: 0.35)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                )
        }
    }
    
    static var previews: some View {
        VStack {
            sampleRing
                .scaledToFit()
            
            RingView(spendingsData: .sample())
                .scaledToFit()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

extension SpendingsData {
    static func sample() -> SpendingsData {
        .init(
            spendingsByCategory: [
                .food: 0,
                .shopping: 100,
                .entertainment: 130,
                .health: 200
            ],
            totalSpendings: 430
        )
    }
}
#endif
