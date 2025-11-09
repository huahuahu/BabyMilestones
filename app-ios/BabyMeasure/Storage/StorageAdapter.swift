import Foundation
import SwiftData

public protocol StorageAdapter {
  var childStore: ChildStore { get }
  var measurementStore: MeasurementStore { get }
}

public class SwiftDataStorageAdapter: StorageAdapter {
  public let childStore: ChildStore
  public let measurementStore: MeasurementStore
  let context: ModelContext
  
  public init(context: ModelContext) {
    self.context = context
    self.childStore = ChildStore(context: context)
    self.measurementStore = MeasurementStore(context: context)
  }
}
