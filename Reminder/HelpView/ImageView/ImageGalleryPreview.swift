import SwiftUI

struct ImageGalleryPreview: View {
    let images: [UIImage]
    var startIndex: Int
    var onDismiss: () -> Void

    @State private var currentIndex: Int
    @GestureState private var scale: CGFloat = 1.0

    init(images: [UIImage], startIndex: Int, onDismiss: @escaping () -> Void) {
        self.images = images
        self.startIndex = startIndex
        self.onDismiss = onDismiss
        _currentIndex = State(initialValue: startIndex)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    ZoomableImage(image: images[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

            Button(action: {
                onDismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}
