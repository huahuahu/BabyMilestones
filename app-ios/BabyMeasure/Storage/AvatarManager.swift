import SwiftUI
import UIKit

struct AvatarManager {
    static let shared = AvatarManager()

    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func saveAvatar(_ image: UIImage, for childId: UUID) throws {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let filename = documentsDirectory.appendingPathComponent("\(childId.uuidString).jpeg")
        try data.write(to: filename)
    }

    func loadAvatar(for childId: UUID) -> UIImage? {
        let filename = documentsDirectory.appendingPathComponent("\(childId.uuidString).jpeg")
        guard let data = try? Data(contentsOf: filename) else { return nil }
        return UIImage(data: data)
    }

    func deleteAvatar(for childId: UUID) {
        let filename = documentsDirectory.appendingPathComponent("\(childId.uuidString).jpeg")
        try? FileManager.default.removeItem(at: filename)
    }
}
