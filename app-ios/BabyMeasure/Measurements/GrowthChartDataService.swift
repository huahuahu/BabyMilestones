import Foundation
import HStandard
import HStorage

struct ChartPoint: Identifiable {
  let id = UUID()
  let ageDays: Double
  let value: Double
}

struct PercentileSeries: Identifiable {
  var id: String { label }
  let label: String
  let points: [ChartPoint]
}

class GrowthChartDataService {
  static func getStandardPoints(
    gender: Gender,
    type: MeasurementType,
    minAgeDays: Double,
    maxAgeDays: Double
  ) -> [PercentileSeries] {
    let references = gender == .female ? GrowthReference.female : GrowthReference.male

    // Filter references relevant to the range (with some buffer)
    // We need to find the references that cover the range.
    // Since references are sorted by ageMonth, we can just use them.

    // We want to generate points at intervals.
    // If range is small (e.g. 90 days), maybe every 5 days.
    // If range is large (e.g. 5 years), maybe every 30 days.

    let rangeSpan = maxAgeDays - minAgeDays
    let step: Double = rangeSpan <= 180 ? 5 : 30

    var currentAge = minAgeDays
    var pointsP3: [ChartPoint] = []
    var pointsP10: [ChartPoint] = []
    var pointsP25: [ChartPoint] = []
    var pointsP50: [ChartPoint] = []
    var pointsP75: [ChartPoint] = []
    var pointsP90: [ChartPoint] = []
    var pointsP97: [ChartPoint] = []

    while currentAge <= maxAgeDays {
      if let values = interpolate(ageDays: currentAge, references: references, type: type) {
        pointsP3.append(ChartPoint(ageDays: currentAge, value: values.p3))
        pointsP10.append(ChartPoint(ageDays: currentAge, value: values.p10))
        pointsP25.append(ChartPoint(ageDays: currentAge, value: values.p25))
        pointsP50.append(ChartPoint(ageDays: currentAge, value: values.p50))
        pointsP75.append(ChartPoint(ageDays: currentAge, value: values.p75))
        pointsP90.append(ChartPoint(ageDays: currentAge, value: values.p90))
        pointsP97.append(ChartPoint(ageDays: currentAge, value: values.p97))
      }
      currentAge += step
    }

    return [
      PercentileSeries(label: "P3", points: pointsP3),
      PercentileSeries(label: "P10", points: pointsP10),
      PercentileSeries(label: "P25", points: pointsP25),
      PercentileSeries(label: "P50", points: pointsP50),
      PercentileSeries(label: "P75", points: pointsP75),
      PercentileSeries(label: "P90", points: pointsP90),
      PercentileSeries(label: "P97", points: pointsP97),
    ]
  }

  // Helper struct to hold interpolated values
  struct InterpolatedValues {
    let p3, p10, p25, p50, p75, p90, p97: Double
  }

  private static func interpolate(ageDays: Double, references: [GrowthReference], type: MeasurementType) -> InterpolatedValues? {
    let ageMonths = ageDays / 30.4375

    // Find the two references surrounding the age
    guard let upperIndex = references.firstIndex(where: { Double($0.ageMonth) >= ageMonths }) else {
      // Age is beyond our data, use the last one if close enough? Or return nil.
      // For now, if it's beyond, we return nil (no standard data).
      return nil
    }

    let upperRef = references[upperIndex]

    if upperIndex == 0 {
      // Age is before the first reference (shouldn't happen if starts at 0)
      return extractValues(from: upperRef, type: type)
    }

    let lowerRef = references[upperIndex - 1]

    let lowerAge = Double(lowerRef.ageMonth)
    let upperAge = Double(upperRef.ageMonth)

    let fraction = (ageMonths - lowerAge) / (upperAge - lowerAge)

    guard let lowerVal = extractValues(from: lowerRef, type: type),
          let upperVal = extractValues(from: upperRef, type: type)
    else {
      return nil
    }

    return InterpolatedValues(
      p3: lerp(start: lowerVal.p3, end: upperVal.p3, t: fraction),
      p10: lerp(start: lowerVal.p10, end: upperVal.p10, t: fraction),
      p25: lerp(start: lowerVal.p25, end: upperVal.p25, t: fraction),
      p50: lerp(start: lowerVal.p50, end: upperVal.p50, t: fraction),
      p75: lerp(start: lowerVal.p75, end: upperVal.p75, t: fraction),
      p90: lerp(start: lowerVal.p90, end: upperVal.p90, t: fraction),
      p97: lerp(start: lowerVal.p97, end: upperVal.p97, t: fraction)
    )
  }

  private static func extractValues(from ref: GrowthReference, type: MeasurementType) -> InterpolatedValues? {
    switch type {
    case .height:
      let refHeight = ref.height
      return InterpolatedValues(p3: refHeight.p3, p10: refHeight.p10, p25: refHeight.p25, p50: refHeight.p50, p75: refHeight.p75, p90: refHeight.p90, p97: refHeight.p97)
    case .weight:
      let refWeight: WeightPercentiles = ref.weight
      return InterpolatedValues(p3: refWeight.p3, p10: refWeight.p10, p25: refWeight.p25, p50: refWeight.p50, p75: refWeight.p75, p90: refWeight.p90, p97: refWeight.p97)
    case .headCircumference:
      guard let refHeadCircumference = ref.headCircumference else { return nil }
      return InterpolatedValues(p3: refHeadCircumference.p3, p10: refHeadCircumference.p10, p25: refHeadCircumference.p25, p50: refHeadCircumference.p50, p75: refHeadCircumference.p75, p90: refHeadCircumference.p90, p97: refHeadCircumference.p97)
    }
  }

  private static func lerp(start: Double, end: Double, t: Double) -> Double {
    start + (end - start) * t
  }
}
