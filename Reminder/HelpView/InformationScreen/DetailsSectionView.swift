import SwiftUI

struct DetailsSectionView: View {
    @Binding var detailsText: String
    @FocusState private var isEditing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: EventInformationUI.sectionStackSpacing) {
            Text("Details".localized)
                .font(.headline)
                .padding(.horizontal, EventInformationUI.horizontalPadding)
            
            TextEditor(text: $detailsText)
                .focused($isEditing)                                                 // 1. Привязываем фокус
                .frame(minHeight: EventInformationUI.textEditorMinHeight)
                .padding(EventInformationUI.textEditorPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: EventInformationUI.cornerRadius)
                        .stroke(Color.gray.opacity(EventInformationUI.photoOverlayOpacity),
                                lineWidth: EventInformationUI.textWidth)
                )
                .padding(.horizontal, EventInformationUI.horizontalPadding)
                .toolbar {                                                           // 2. Кнопка над клавиатурой
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            isEditing = false
                        }
                    }
                }
        }
    }
}
