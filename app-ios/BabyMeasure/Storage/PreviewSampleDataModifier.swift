import SwiftData
import SwiftUI

// Convenience alias matching naming style in example snippet if preferred.
/// Alternate shorter name mirroring the example `SampleData` pattern.
struct SampleData: PreviewModifier {
  static func makeSharedContext() throws -> ModelContainer {
    PreviewModelContainerFactory.make(seedSampleData: true)
  }

  func body(content: Content, context: ModelContainer) -> some View {
    content.modelContainer(context)
  }
}
