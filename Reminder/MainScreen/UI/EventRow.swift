import SwiftUI
struct EventRow: View {
    let model: MainModel
    
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "bookmark")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 4)
            
            Image(systemName: model.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(model.title)
                    .font(.headline)
                Text("\(model.dateFormatted) \(model.dayOfWeek).")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(model.daysLeft) days")
                .font(.subheadline)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

