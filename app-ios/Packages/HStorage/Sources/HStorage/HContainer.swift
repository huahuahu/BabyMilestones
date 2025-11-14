import Foundation
import SwiftData

/// Namespace for shared storage resources.
/// Provides a static SwiftData `ModelContainer` configured with all app model types.
/// Use this container in `@Environment(\.modelContext)` injection via `.modelContainer(HContainer.modelContainer)` at the app root.
public enum HContainer {
  /// The shared `ModelContainer` holding all SwiftData models.
  /// Initialized once and reused application-wide.
  public static let localContainer: ModelContainer = {
    do {
      // Register all @Model types here as the schema evolves.
      return try ModelContainer(for: ChildEntity.self, MeasurementEntity.self)
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }()
}
