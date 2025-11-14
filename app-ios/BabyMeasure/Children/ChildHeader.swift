import Observation
import SwiftData
import SwiftUI

struct ChildHeader: View {
  @Binding
  var selected: ChildEntity?
  var children: [ChildEntity]
  var onSelect: (ChildEntity) -> Void
  var body: some View {
    HStack {
      Menu {
        ForEach(children, id: \ChildEntity.persistentModelID) { child in
          Button(action: { onSelect(child) }) {
            Text(child.name)
          }
        }
      } label: {
        HStack(spacing: 8) {
          Image(systemName: "person.crop.circle")
          Text(selected?.name ?? "选择儿童")
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
  }
}

#Preview {
  struct Wrapper: View {
    @State
    var sel: ChildEntity?
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
