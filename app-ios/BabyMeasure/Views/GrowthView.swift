//
//  GrowthView.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import SwiftUI
import UIKit

struct GrowthView: View {
  @Environment(NavigationManager.self) private var navigation
  @Environment(DataManager.self) private var dataManager
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          // Growth Types Grid
          LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            ForEach(GrowthType.allCases, id: \.self) { type in
              GrowthTypeCard(type: type)
            }
          }
          .padding()
          
          // Recent Measurements
          VStack(alignment: .leading) {
            Text("Recent Measurements")
              .font(.headline)
              .padding(.horizontal)
            
            if dataManager.growthMeasurements.isEmpty {
              Text("No measurements recorded yet")
                .foregroundColor(.secondary)
                .padding(.horizontal)
            } else {
              ForEach(dataManager.growthMeasurements.prefix(5), id: \.id) { measurement in
                MeasurementRowView(measurement: measurement)
              }
            }
          }
        }
      }
      .navigationTitle("Growth")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Menu {
            ForEach(GrowthType.allCases, id: \.self) { type in
              Button(type.rawValue) {
                navigation.navigateToAddGrowth(type: type)
              }
            }
          } label: {
            Image(systemName: "plus")
          }
        }
      }
    }
  }
}

struct GrowthTypeCard: View {
  let type: GrowthType
  @Environment(NavigationManager.self) private var navigation
  
  var body: some View {
    Button {
      navigation.navigateToAddGrowth(type: type)
    } label: {
      VStack {
        Image(systemName: type.icon)
          .font(.largeTitle)
          .foregroundColor(.accentColor)
        
        Text(type.rawValue)
          .font(.headline)
          .multilineTextAlignment(.center)
      }
      .frame(maxWidth: .infinity)
      .frame(height: 120)
      .background(Color(UIColor.secondarySystemBackground))
      .cornerRadius(12)
    }
  }
}

struct MeasurementRowView: View {
  let measurement: GrowthMeasurement
  
  var body: some View {
    HStack {
      Image(systemName: measurement.type.icon)
        .foregroundColor(.accentColor)
        .frame(width: 30)
      
      VStack(alignment: .leading) {
        Text(measurement.type.rawValue)
          .font(.headline)
        
        Text(measurement.date, style: .date)
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      Spacer()
      
      Text("\(measurement.value, specifier: "%.1f") \(measurement.type.unit)")
        .font(.title3)
        .fontWeight(.semibold)
    }
    .padding(.horizontal)
    .padding(.vertical, 8)
  }
}

#Preview {
  GrowthView()
    .environment(NavigationManager())
    .environment(DataManager())
}