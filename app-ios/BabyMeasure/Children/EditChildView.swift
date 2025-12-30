import HStorage
import PhotosUI
import SwiftData
import SwiftUI

struct EditChildView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(SelectedChildState.self) private var selectedChildState

    let child: ChildEntity

    @State private var name: String
    @State private var birthday: Date
    @State private var gender: Gender
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    @State private var showingDeleteConfirmation = false
    @State private var errorMessage: LocalizedStringKey?

    init(child: ChildEntity) {
        self.child = child
        _name = State(initialValue: child.name)
        _birthday = State(initialValue: child.birthday)
        if let raw = child.genderRaw, let gender = Gender(rawValue: raw) {
            _gender = State(initialValue: gender)
        } else {
            _gender = State(initialValue: .unspecified)
        }
    }

    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        if let avatarImage {
                            Image(uiImage: avatarImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(.circle)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .foregroundStyle(.gray)
                                .frame(width: 100, height: 100)
                        }

                        PhotosPicker(selection: $avatarItem, matching: .images) {
                            Text("child.edit.avatar.change")
                        }
                    }
                    Spacer()
                }
            }

            Section("child.info.basic") {
                TextField("child.name", text: $name)
                Picker("child.gender", selection: $gender) {
                    ForEach(Array(Gender.allCases), id: \.self) { genderOption in
                        Text(String(describing: genderOption))
                    }
                }
                DatePicker("child.birthday", selection: $birthday, in: ...Date(), displayedComponents: .date)
            }

            Section {
                if selectedChildState.current?.id == child.id {
                    Label("child.edit.current", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.accent)
                } else {
                    Button("child.edit.setCurrent", systemImage: "checkmark.circle") {
                        selectedChildState.select(child)
                    }
                }
            }

            Section {
                Button("child.delete.button", role: .destructive) {
                    showingDeleteConfirmation = true
                }
            }

            if let errorMessage { Text(errorMessage).foregroundStyle(.red) }
        }
        .navigationTitle("child.edit.title")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) { Button("common.save") { save() } }
        }
        .onChange(of: avatarItem) {
            Task {
                if let data = try? await avatarItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    avatarImage = uiImage
                }
            }
        }
        .onAppear {
            avatarImage = AvatarManager.shared.loadAvatar(for: child.id)
        }
        .alert("child.delete.confirm.title", isPresented: $showingDeleteConfirmation) {
            Button("common.delete", role: .destructive) { deleteChild() }
            Button("common.cancel", role: .cancel) {}
        } message: {
            Text("child.delete.confirm.message")
        }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { errorMessage = "error.name.empty"; return }
        guard birthday <= Date() else { errorMessage = "error.birthday.future"; return }

        child.name = trimmed
        child.birthday = birthday
        child.genderRaw = gender == .unspecified ? nil : gender.rawValue
        child.updatedAt = Date()

        if let avatarImage {
            try? AvatarManager.shared.saveAvatar(avatarImage, for: child.id)
        }

        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "error.save.generic"
        }
    }

    private func deleteChild() {
        do {
            let childId = child.id
            let descriptor = FetchDescriptor<MeasurementEntity>(predicate: #Predicate { $0.childId == childId })
            let measurements = try modelContext.fetch(descriptor)
            for measurement in measurements {
                modelContext.delete(measurement)
            }

            modelContext.delete(child)
            AvatarManager.shared.deleteAvatar(for: childId)

            if selectedChildState.current?.id == childId {
                selectedChildState.clear()
            }

            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "error.delete.generic"
        }
    }
}
