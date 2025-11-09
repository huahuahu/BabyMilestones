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
    childStore = ChildStore(context: context)
    measurementStore = MeasurementStore(context: context)
  }
}
