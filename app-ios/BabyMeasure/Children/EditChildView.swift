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
    @State private var errorMessage: String?

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
        NavigationStack {
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
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundStyle(.gray)
                                    .frame(width: 100, height: 100)
                            }

                            PhotosPicker(selection: $avatarItem, matching: .images) {
                                Text("更换头像")
                            }
                        }
                        Spacer()
                    }
                }

                Section("基本信息") {
                    TextField("姓名", text: $name)
                    Picker("性别", selection: $gender) {
                        ForEach(Array(Gender.allCases), id: \.self) { genderOption in
                            Text(String(describing: genderOption))
                        }
                    }
                    DatePicker("生日", selection: $birthday, in: ...Date(), displayedComponents: .date)
                }

                Section {
                    Button("删除儿童", role: .destructive) {
                        showingDeleteConfirmation = true
                    }
                }

                if let errorMessage { Text(errorMessage).foregroundStyle(.red) }
            }
            .navigationTitle("编辑儿童")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("取消") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("保存") { save() } }
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
            .alert("确认删除", isPresented: $showingDeleteConfirmation) {
                Button("删除", role: .destructive) { deleteChild() }
                Button("取消", role: .cancel) {}
            } message: {
                Text("删除后将无法恢复，所有相关记录也将被删除。")
            }
        }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { errorMessage = "姓名不能为空"; return }
        guard birthday <= Date() else { errorMessage = "生日不能晚于今天"; return }

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
            errorMessage = "保存失败"
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
            errorMessage = "删除失败: \(error.localizedDescription)"
        }
    }
}
