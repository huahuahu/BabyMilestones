import Foundation
import HStorage
import SwiftData

/// Convenience factory for SwiftData containers used in SwiftUI previews.
///
/// Use this from `#Preview` via the `.modelContainer(_:)` preview trait to
/// get an in-memory store seeded with stable sample data.
enum PreviewModelContainerFactory {
    /// Creates an in-memory `ModelContainer` configured with all app models.
    /// Optionally seeds the container with sample data for UI previews.
    ///
    /// - Parameter seedSampleData: When `true`, inserts a few children and
    ///   measurements so previews have realistic content.
    /// - Returns: A `ModelContainer` backed by an in-memory store.
    static func make(seedSampleData: Bool = true) -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)

        let container: ModelContainer
        do {
            container = try ModelContainer(
                for: ChildEntity.self,
                MeasurementEntity.self,
                configurations: configuration
            )
        } catch {
            fatalError("Failed to create preview ModelContainer: \(error)")
        }

        guard seedSampleData else { return container }

        let context = ModelContext(container)
        seed(context: context)

        return container
    }

    /// Inserts stable, deterministic sample data for previews.
    private static func seed(context: ModelContext) {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()

        let baby1Birthday = calendar.date(byAdding: .month, value: -6, to: now) ?? now
        let baby2Birthday = calendar.date(byAdding: .year, value: -2, to: now) ?? now

        let baby1 = ChildEntity(
            name: "Luna",
            genderRaw: "female",
            birthday: baby1Birthday
        )

        let baby2 = ChildEntity(
            name: "Noah",
            genderRaw: "male",
            birthday: baby2Birthday
        )

        context.insert(baby1)
        context.insert(baby2)

        // A couple of sample measurements per child for charts and history views.
        let measurements: [MeasurementEntity] = [
            MeasurementEntity(
                childId: baby1.id,
                typeRaw: "height",
                value: 65.0,
                recordedAt: calendar.date(byAdding: .day, value: -7, to: now) ?? now
            ),
            MeasurementEntity(
                childId: baby1.id,
                typeRaw: "weight",
                value: 7.2,
                recordedAt: calendar.date(byAdding: .day, value: -3, to: now) ?? now
            ),
            MeasurementEntity(
                childId: baby2.id,
                typeRaw: "height",
                value: 92.0,
                recordedAt: calendar.date(byAdding: .day, value: -10, to: now) ?? now
            ),
            MeasurementEntity(
                childId: baby2.id,
                typeRaw: "weight",
                value: 13.5,
                recordedAt: calendar.date(byAdding: .day, value: -1, to: now) ?? now
            ),
        ]

        for measurement in measurements {
            context.insert(measurement)
        }

        do {
            try context.save()
        } catch {
            // For previews we prefer not to crash; log for visibility in console.
            print("[PreviewModelContainerFactory] Failed to save seed data: \(error)")
        }
    }
}
