// The Swift Programming Language
// https://docs.swift.org/swift-book

// 单位标记类型
public protocol MeasurementUnitType {
  static var unitString: String { get }
}

public enum Kilogram: MeasurementUnitType {
  public static let unitString = "kg"
}

public enum Centimeter: MeasurementUnitType {
  public static let unitString = "cm"
}

public enum BMI: MeasurementUnitType {
    public static let unitString: String = "kg/m2"
}

// 使用幽灵类型，将单位编码在类型中
struct PercentileValues<Unit: MeasurementUnitType> : Codable  {
  let p3: Double
  let p10: Double
    let p25: Double
  let p50: Double
    let p75: Double
  let p90: Double
  let p97: Double
  
  var unit: String {
    Unit.unitString
  }
}

// 便捷类型别名
typealias HeightPercentiles = PercentileValues<Centimeter>
typealias headCircumferencePercentile = PercentileValues<Centimeter>
typealias WeightPercentiles = PercentileValues<Kilogram>
typealias BMIPercentiles = PercentileValues<BMI>


struct GrowthReference: Codable { // 单一年龄性别标准
  let ageMonth: Int // 统一转为月
  let biologicalSex: BiologicalSex // male/female
  let height: HeightPercentiles
  let weight: WeightPercentiles
  let headCircumference: headCircumferencePercentile?
    let bmi: BMIPercentiles
}

struct WeightForHeightReference: Codable {
    let height: Double
    let biologicalSex: BiologicalSex
    let weight: WeightPercentiles
}



enum BiologicalSex: CaseIterable, Hashable, Identifiable, Codable {
  case male
  case female

  var id: Self {
    self
  }
}
