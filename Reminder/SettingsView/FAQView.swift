import SwiftUI

// MARK: - Layout Constants
private enum LayoutConstants {
    static let cardPadding: CGFloat = 16
    static let cardSpacing: CGFloat = 8
    static let cardMinHeight: CGFloat = 160
    static let cornerRadius: CGFloat = 20
    static let shadowRadius: CGFloat = 4
    static let shadowXOffset: CGFloat = 0
    static let shadowYOffset: CGFloat = 2
    static let shadowOpacity: Double = 0.1
    static let FAQVerticalSpacing: CGFloat = 16
    static let FAQHorizontalPadding: CGFloat = 16
}

// MARK: - FAQ Card View with Uniform Size
struct FAQCardView: View {
    let question: String
    let answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConstants.cardSpacing) {
            Text(question)
                .font(.headline)
                .foregroundColor(.black)
            Text(answer)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(LayoutConstants.cardPadding)
        .frame(maxWidth: .infinity,
               minHeight: LayoutConstants.cardMinHeight,
               alignment: .topLeading)
        .background(Color(.systemGray6))
        .cornerRadius(LayoutConstants.cornerRadius)
        .shadow(color: Color.black.opacity(LayoutConstants.shadowOpacity),
                radius: LayoutConstants.shadowRadius,
                x: LayoutConstants.shadowXOffset,
                y: LayoutConstants.shadowYOffset)
    }
}

// MARK: - FAQ Screen
struct FAQView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: LayoutConstants.FAQVerticalSpacing) {
                TopHeaderView(title: "FAQ".localized, onBack: { dismiss() })
                
                ScrollView {
                    VStack(spacing: LayoutConstants.FAQVerticalSpacing) {
                        FAQCardView(
                            question: "Q: What are beautiful dates?".localized,
                            answer: "A: Beautiful dates are dates that meet certain aesthetic and symbolic criteria making them memorable.".localized
                        )
                        FAQCardView(
                            question: "Q: How is a beautiful date determined?".localized,
                            answer: "A: It is determined based on built-in criteria such as palindromes, repeating digits, symmetry, and other rules.".localized
                        )
                        FAQCardView(
                            question: "Q: Where can I use beautiful dates?".localized,
                            answer: "A: They can be used for planning events, celebrations, or personal occasions to add a unique touch.".localized
                        )
                    }
                    .padding(.vertical, LayoutConstants.FAQVerticalSpacing)
                    .padding(.horizontal, LayoutConstants.FAQHorizontalPadding)
                }
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.white)
        }
    }
}
