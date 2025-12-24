import Foundation
import HStorage
import Observation

@MainActor
@Observable
class SelectedChildState {
    var current: ChildEntity?

    func select(_ child: ChildEntity) {
        current = child
    }

    func clear() {
        current = nil
    }
}
