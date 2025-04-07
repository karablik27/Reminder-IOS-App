import SwiftUI

// MARK: - FAQ Card View with Uniform Size

struct FAQCardView: View {
    let question: String
    let answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question)
                .font(.headline)
                .foregroundColor(.black)
            Text(answer)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 160, alignment: .topLeading)
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - FAQ Screen

struct FAQView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TopHeaderView(title: "FAQ", onBack: { dismiss() })
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Each FAQCardView now has the same size constraints
                        FAQCardView(
                            question: "Q: What are beautiful dates?",
                            answer: "A: Beautiful dates are dates that meet certain aesthetic and symbolic criteria making them memorable."
                        )
                        FAQCardView(
                            question: "Q: How is a beautiful date determined?",
                            answer: "A: It is determined based on built-in criteria such as palindromes, repeating digits, symmetry, and other rules."
                        )
                        FAQCardView(
                            question: "Q: Where can I use beautiful dates?",
                            answer: "A: They can be used for planning events, celebrations, or personal occasions to add a unique touch."
                        )
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                }
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.white)
        }
    }
}
