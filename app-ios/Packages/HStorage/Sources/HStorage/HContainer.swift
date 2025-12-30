import Foundation
import SwiftData

/// Namespace for shared storage resources.
/// Provides SwiftData `ModelContainer` instances configured with all app model types.
/// Use this container in `@Environment(\.modelContext)` injection via `.modelContainer(HContainer.container(for:))` at the app root.
public enum HContainer {
    // MARK: - Schema

    /// All model types used in the app.
    private static let schema: [any PersistentModel.Type] = [
        ChildEntity.self,
        MeasurementEntity.self,
    ]

    // MARK: - Containers

    /// iCloud-synced container via CloudKit.
    /// Data syncs across all devices signed into the same iCloud account.
    public static let iCloudContainer: ModelContainer = {
        do {
            let configuration = ModelConfiguration(
                cloudKitDatabase: .private("iCloud.com.tiger.suzhou.babymeasure")
            )
            return try ModelContainer(for: ChildEntity.self, MeasurementEntity.self, configurations: configuration)
        } catch {
            fatalError("Failed to create iCloud ModelContainer: \(error)")
        }
    }()

    /// Local persistent container.
    /// Data is stored on device only and persists across app launches.
    public static let localContainer: ModelContainer = {
        do {
            let configuration = ModelConfiguration(
                "LocalStore",
                cloudKitDatabase: .none
            )
            return try ModelContainer(for: ChildEntity.self, MeasurementEntity.self, configurations: configuration)
        } catch {
            fatalError("Failed to create local ModelContainer: \(error)")
        }
    }()

    /// In-memory container for testing and previews.
    /// Data is lost when the app terminates.
    public static let memoryContainer: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            return try ModelContainer(for: ChildEntity.self, MeasurementEntity.self, configurations: configuration)
        } catch {
            fatalError("Failed to create memory ModelContainer: \(error)")
        }
    }()

    // MARK: - Container Selection

    /// Returns the appropriate container for the given storage mode.
    /// - Parameter mode: The storage mode to use.
    /// - Returns: A `ModelContainer` configured for the specified mode.
    public static func container(for mode: StorageMode) -> ModelContainer {
        switch mode {
        case .iCloud:
            iCloudContainer
        case .local:
            localContainer
        case .memory:
            memoryContainer
        }
    }
}
