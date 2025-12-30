import Charts
import HStandard
import HStorage
import SwiftData
import SwiftUI

enum ChartRange: String, CaseIterable, Identifiable {
  case recent3Months
  case recent1Year
  case all

  var id: String { rawValue }

  var displayName: LocalizedStringKey {
    switch self {
    case .recent3Months:
      "growthchart.range.recent.3months"
    case .recent1Year:
      "growthchart.range.recent.1year"
    case .all:
      "growthchart.range.all"
    }
  }
}

struct GrowthChartView: View {
  let child: ChildEntity

  @Environment(\.locale) private var locale

  @Query private var measurements: [MeasurementEntity]

  @State private var selectedType: MeasurementType = .height
  @State private var selectedRange: ChartRange = .recent3Months
  @State private var standardSeries: [PercentileSeries] = []
  @State private var scrollPosition: Double?

  init(child: ChildEntity) {
    self.child = child
    let childId = child.id
    // We fetch all measurements for the child and filter by type in memory/view
    _measurements = Query(filter: #Predicate<MeasurementEntity> { $0.childId == childId }, sort: \.recordedAt)
  }

  // MARK: - Subviews

  private var typePicker: some View {
    Picker("growthchart.type", selection: $selectedType) {
      ForEach(MeasurementType.allCases, id: \.self) { type in
        Text(type.displayNameKey).tag(type)
      }
    }
    .pickerStyle(.segmented)
    .padding()
    .accessibilityLabel(Text("growthchart.type"))
  }

  private var rangePicker: some View {
    Picker("timerange.section", selection: $selectedRange) {
      ForEach(ChartRange.allCases) { range in
        Text(range.displayName).tag(range)
      }
    }
    .pickerStyle(.segmented)
    .padding(.horizontal)
    .accessibilityLabel(Text("timerange.section"))
  }

  var body: some View {
    VStack {
      typePicker
      rangePicker

      if filteredMeasurements.isEmpty, standardSeries.isEmpty {
        emptyView
      } else {
        chartView
      }

      SwiftUI.Spacer()
    }
    .navigationTitle("growthchart.title")
    .task(id: selectedType) {
      await updateChartData()
    }
    .onChange(of: selectedRange) {
      if let age = daysSinceBirth(date: Date()) {
        withAnimation {
          scrollPosition = age
        }
      }
    }
    .onAppear {
      Task { await updateChartData() }
    }
  }

  private var emptyView: some View {
    ContentUnavailableView(
      "growthchart.empty.title",
      systemImage: "chart.xyaxis.line",
      description: Text("growthchart.empty.description")
    )
    .accessibilityLabel(Text("growthchart.empty.title"))
  }

  @ViewBuilder
  private var chartView: some View {
    let chart = makeChart()
      .chartForegroundStyleScale(percentileColors)
      .chartXAxis { xAxisMarks }
      .chartYAxis { yAxisMarks }
      .chartScrollableAxes(.horizontal)

    Group {
      if let length = visibleDomainLength {
        if let scrollPosition = Binding($scrollPosition) {
          chart.chartXVisibleDomain(length: length)
            .chartScrollPosition(x: scrollPosition)
        } else {
          chart.chartXVisibleDomain(length: length)
        }
      } else {
        if let scrollPosition = Binding($scrollPosition) {
          chart.chartScrollPosition(x: scrollPosition)
        } else {
          chart
        }
      }
    }
    .padding()
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    .accessibilityElement(children: .contain)
    .accessibilityLabel(Text("growthchart.title"))
  }

  private func makeChart() -> some View {
    let ageDaysLabel = String(localized: "年龄(天)", locale: locale)
    let valueLabel = String(localized: "数值", locale: locale)
    let percentileLabel = String(localized: "百分位", locale: locale)

    return Chart {
      ForEach(standardSeries) { series in
        ForEach(series.points) { point in
          LineMark(
            x: .value(ageDaysLabel, point.ageDays),
            y: .value(valueLabel, point.value),
            series: .value(percentileLabel, series.label)
          )
          .foregroundStyle(by: .value(percentileLabel, series.label))
          .interpolationMethod(.catmullRom)
          .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
        }
      }

      ForEach(filteredMeasurements) { measurement in
        if let ageDays = daysSinceBirth(date: measurement.recordedAt), ageDays >= 0 {
          PointMark(
            x: .value(ageDaysLabel, ageDays),
            y: .value(valueLabel, measurement.value)
          )
          .foregroundStyle(.blue)
          .symbolSize(50)
        }
      }
    }
  }

  private var percentileColors: KeyValuePairs<String, Color> {
    [
      "P3": .gray.opacity(0.3),
      "P10": .gray.opacity(0.4),
      "P25": .gray.opacity(0.5),
      "P50": .green,
      "P75": .gray.opacity(0.5),
      "P90": .gray.opacity(0.4),
      "P97": .gray.opacity(0.3),
    ]
  }

  @AxisContentBuilder private var xAxisMarks: some AxisContent {
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

  @AxisContentBuilder private var yAxisMarks: some AxisContent {
    AxisMarks { _ in
      AxisValueLabel()
      AxisGridLine()
    }
  }

  private var filteredMeasurements: [MeasurementEntity] {
    measurements.filter { $0.typeRaw == selectedType.rawValue }
  }

  private var visibleDomainLength: Double? {
    switch selectedRange {
    case .recent3Months: 90
    case .recent1Year: 365
    case .all: nil
    }
  }

  private func daysSinceBirth(date: Date) -> Double? {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: child.birthday, to: date)
    return components.day.map { Double($0) }
  }

  private func formatAge(days: Double) -> String {
    let totalMonths = max(0, Int((days / 30.44).rounded(.down)))
    var components = DateComponents()
    if totalMonths < 12 {
      components.month = totalMonths
    } else {
      components.year = totalMonths / 12
      components.month = totalMonths % 12
    }

    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .short
    formatter.maximumUnitCount = 2
    //    formatter.locale = locale

    if components.year == nil {
      formatter.allowedUnits = [.month]
    } else {
      formatter.allowedUnits = [.year, .month]
    }

    return formatter.string(from: components) ?? ""
  }

  private func updateChartData() async {
    let now = Date()
    // Always fetch from birth (0) to now so we can scroll back
    let startAgeDays = 0.0
    let endAgeDays = max(startAgeDays + 1, daysSinceBirth(date: now) ?? 0)

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
      await GrowthChartDataService.getStandardPoints(
        gender: gender,
        type: type,
        minAgeDays: startAgeDays,
        maxAgeDays: endAgeDays + 30 // Add a buffer
      )
    }.value

    await MainActor.run {
      standardSeries = series
      if scrollPosition == nil {
        scrollPosition = endAgeDays
      }
    }
  }
}
