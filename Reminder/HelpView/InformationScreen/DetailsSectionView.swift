import SwiftUI

struct DetailsSectionView: View {
    @Binding var detailsText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: EventInformationUI.sectionStackSpacing) {
            Text("Details".localized)
                .font(.headline)
                .padding(.horizontal, EventInformationUI.horizontalPadding)
            
            TextEditor(text: $detailsText)
                .frame(minHeight: EventInformationUI.textEditorMinHeight)
                .padding(EventInformationUI.textEditorPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: EventInformationUI.cornerRadius)
                        .stroke(Color.gray.opacity(EventInformationUI.photoOverlayOpacity), lineWidth: EventInformationUI.textWidth)
                )
                .padding(.horizontal, EventInformationUI.horizontalPadding)
        }
    }
}
