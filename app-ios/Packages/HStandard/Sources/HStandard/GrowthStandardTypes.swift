// The Swift Programming Language
// https://docs.swift.org/swift-book

// 单位标记类型
public protocol MeasurementUnitType: Sendable {
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
public struct PercentileValues<Unit: MeasurementUnitType>: Codable, Sendable {
  public let p3: Double
  public let p10: Double
  public let p25: Double
  public let p50: Double
  public let p75: Double
  public let p90: Double
  public let p97: Double

  var unit: String {
    Unit.unitString
  }
}

// 便捷类型别名
public typealias HeightPercentiles = PercentileValues<Centimeter>
public typealias HeadCircumferencePercentile = PercentileValues<Centimeter>
public typealias WeightPercentiles = PercentileValues<Kilogram>
public typealias BMIPercentiles = PercentileValues<BMI>

public struct GrowthReference: Codable, Sendable { // 单一年龄性别标准
  public let ageMonth: Int // 统一转为月
  public let biologicalSex: BiologicalSex // male/female
  public let height: HeightPercentiles
  public let weight: WeightPercentiles
  public let headCircumference: HeadCircumferencePercentile?
  public let bmi: BMIPercentiles
}

public struct WeightForHeightReference: Codable, Sendable {
  let height: Double
  let biologicalSex: BiologicalSex
  let weight: WeightPercentiles
}

public enum BiologicalSex: CaseIterable, Hashable, Identifiable, Codable, Sendable {
  case male
  case female

  public var id: Self {
    self
  }
}
