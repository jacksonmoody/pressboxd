//
//  ReviewChartView.swift
//  pressboxd
//
//  Created by Jackson Moody on 7/14/24.
//

import SwiftUI
import Charts

struct ReviewData: Identifiable {
    let rating: Int
    let count: Int
    let id = UUID()
}

func aggregateReviews(_ reviews: [Review]) -> [ReviewData] {
    var reviewCounts = [Int: Int]()
    
    for rating in 1...5 {
        reviewCounts[rating] = 0
    }
    
    for review in reviews {
        if let currentCount = reviewCounts[review.rating] {
            reviewCounts[review.rating] = currentCount + 1
        }
    }
    
    return reviewCounts.map { ReviewData(rating: $0.key, count: $0.value) }.sorted { $0.rating < $1.rating }
}

func averageReview(_ reviews: [Review]) -> Double {
    var sum = 0.0
    
    for review in reviews {
        sum = sum + Double(review.rating)
    }
    
    let result = sum / Double(reviews.count)
    return result
}

struct ReviewChartView: View {
    let reviews: [Review]
    var body: some View {
        VStack(alignment:.leading) {
            Text("Average Rating: " + averageReview(reviews).description)
                .font(.custom("Play-Bold", size: 30))
                .foregroundColor(Color("TextColor"))
                .padding(.leading, 20)
            Chart(aggregateReviews(reviews)) { data in
                BarMark(
                    x: .value("Rating", data.rating),
                    y: .value("Count", data.count),
                    width: .fixed(30)
                )
            }
            .chartXAxis {
                AxisMarks(values: [0,1,2,3,4,5]) {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .frame(height: 250)
            .padding(.horizontal, 20)
        }
    }
}
