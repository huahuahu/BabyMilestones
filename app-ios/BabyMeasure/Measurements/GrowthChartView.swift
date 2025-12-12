import SwiftUI
import Charts
import SwiftData
import HStorage
import HStandard

enum ChartRange: String, CaseIterable, Identifiable {
    case recent3Months = "近3个月"
    case recent1Year = "近1年"
    case all = "全部"
    
    var id: String { rawValue }
}

struct GrowthChartView: View {
    let child: ChildEntity
    
    @Query private var measurements: [MeasurementEntity]
    
    @State private var selectedType: MeasurementType = .height
    @State private var selectedRange: ChartRange = .recent3Months
    @State private var standardSeries: [PercentileSeries] = []
    
    init(child: ChildEntity) {
        self.child = child
        let childId = child.id
        // We fetch all measurements for the child and filter by type in memory/view
        _measurements = Query(filter: #Predicate<MeasurementEntity> { $0.childId == childId }, sort: \.recordedAt)
    }
    
    var body: some View {
        VStack {
            Picker("测量类型", selection: $selectedType) {
                ForEach(MeasurementType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Picker("时间范围", selection: $selectedRange) {
                ForEach(ChartRange.allCases) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if filteredMeasurements.isEmpty && standardSeries.isEmpty {
                ContentUnavailableView("暂无数据", systemImage: "chart.xyaxis.line", description: Text("添加记录以查看生长曲线"))
            } else {
                Chart {
                    // Standard Percentiles
                    ForEach(standardSeries) { series in
                        ForEach(series.points) { point in
                            LineMark(
                                x: .value("年龄(天)", point.ageDays),
                                y: .value("数值", point.value),
                                series: .value("百分位", series.label)
                            )
                            .foregroundStyle(by: .value("百分位", series.label))
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        }
                    }
                    
                    // User Measurements
                    ForEach(filteredMeasurements) { measurement in
                        if let ageDays = daysSinceBirth(date: measurement.recordedAt), ageDays >= 0 {
                            PointMark(
                                x: .value("年龄(天)", ageDays),
                                y: .value("数值", measurement.value)
                            )
                            .foregroundStyle(.blue)
                            .symbolSize(50)
                        }
                    }
                }
                .chartForegroundStyleScale([
                    "P3": .gray.opacity(0.3),
                    "P10": .gray.opacity(0.4),
                    "P25": .gray.opacity(0.5),
                    "P50": .green,
                    "P75": .gray.opacity(0.5),
                    "P90": .gray.opacity(0.4),
                    "P97": .gray.opacity(0.3)
                ])
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        if let doubleValue = value.as(Double.self) {
                            AxisValueLabel {
                                Text(formatAge(days: doubleValue))
                            }
                        }
                        AxisGridLine()
                        AxisTick()
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                        AxisGridLine()
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .navigationTitle("生长曲线")
        .task(id: selectedType) {
            await updateChartData()
        }
        .task(id: selectedRange) {
            await updateChartData()
        }
        .onAppear {
            Task { await updateChartData() }
        }
    }
    
    private var filteredMeasurements: [MeasurementEntity] {
        measurements.filter { $0.typeRaw == selectedType.rawValue }
    }
    
    private func daysSinceBirth(date: Date) -> Double? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: child.birthday, to: date)
        return components.day.map { Double($0) }
    }
    
    private func formatAge(days: Double) -> String {
        let months = Int(days / 30.44)
        if months < 12 {
            return "\(months)月"
        } else {
            let years = months / 12
            let remainingMonths = months % 12
            if remainingMonths == 0 {
                return "\(years)岁"
            } else {
                return "\(years)岁\(remainingMonths)月"
            }
        }
    }
    
    private func updateChartData() async {
        // Calculate range
        let calendar = Calendar.current
        let now = Date()
        let minDate: Date
        
        switch selectedRange {
        case .recent3Months:
            minDate = calendar.date(byAdding: .month, value: -3, to: now) ?? now
        case .recent1Year:
            minDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        case .all:
            minDate = child.birthday
        }
        
        // Determine min and max age in days for the chart x-axis
        // We want to cover the selected range, but relative to the child's age.
        
        // If "Recent 3 Months", we want [Now - 3 months, Now] converted to Age.
        // But if the child is only 1 month old, we start from 0.
        
        let startAgeDays = max(0, daysSinceBirth(date: minDate) ?? 0)
        let endAgeDays = max(startAgeDays + 1, daysSinceBirth(date: now) ?? 0)
        
        // If "All", we go from 0 to current age (or max measurement age)
        // Let's just use the calculated start/end based on the time range.
        
        // Ensure we have a valid gender
        let gender = Gender(rawValue: child.genderRaw ?? "") ?? .unspecified
        if gender == .unspecified {
            // Handle unspecified gender? Maybe default to male or show error?
            // For now, let's default to male or just empty
             standardSeries = []
             return
        }
        
        // Run in background
        let type = selectedType
        let series = await Task.detached(priority: .userInitiated) {
            return await GrowthChartDataService.getStandardPoints(
                gender: gender,
                type: type,
                minAgeDays: startAgeDays,
                maxAgeDays: endAgeDays + 30 // Add a buffer
            )
        }.value
        
        await MainActor.run {
            self.standardSeries = series
        }
    }
}


