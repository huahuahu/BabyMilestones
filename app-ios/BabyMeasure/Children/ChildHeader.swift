import HStorage
import Observation
import SwiftData
import SwiftUI

struct ChildHeader: View {
    @Binding var selected: ChildEntity?
    var children: [ChildEntity]
    var onSelect: (ChildEntity) -> Void

    @State private var showingEditSheet = false
    @State private var avatar: UIImage?

    var body: some View {
        HStack {
            Menu {
                ForEach(children, id: \ChildEntity.persistentModelID) { child in
                    Button(action: { onSelect(child) }) {
                        Text(child.name)
                        if selected?.id == child.id {
                            Image(systemName: "checkmark")
                        }
                    }
                }

                Divider()

                Button(action: { showingEditSheet = true }) {
                    Label("child.profile.edit", systemImage: "pencil")
                }
                .disabled(selected == nil)

            } label: {
                HStack(spacing: 8) {
                    if let avatar {
                        Image(uiImage: avatar)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .clipShape(.circle)
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }

                    Group {
                        if let name = selected?.name {
                            Text(name)
                        } else {
                            Text("child.select")
                        }
                    }
                    .font(.headline)

                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .glassEffect(.clear, in: .rect(cornerRadius: 8))
            }

            Spacer()
        }
        .padding(.horizontal)
        .sheet(isPresented: $showingEditSheet) {
            if let child = selected {
                NavigationStack {
                    EditChildView(child: child)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("common.cancel") { showingEditSheet = false }
                            }
                        }
                }
            }
        }
        .onAppear { loadAvatar() }
        .onChange(of: selected) { loadAvatar() }
        .onChange(of: showingEditSheet) {
            if !showingEditSheet {
                loadAvatar()
            }
        }
    }

    private func loadAvatar() {
        if let id = selected?.id {
            avatar = AvatarManager.shared.loadAvatar(for: id)
        } else {
            avatar = nil
        }
    }
}

#Preview {
    struct Wrapper: View {
        @State var sel: ChildEntity?
        let children: [ChildEntity]
        init() {
            children = [ChildEntity(name: "Alice", genderRaw: nil, birthday: .now)]
        }

        var body: some View {
            ChildHeader(selected: $sel, children: children) { sel = $0 }
        }
    }
    return Wrapper()
}
