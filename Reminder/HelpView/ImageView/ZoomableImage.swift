import SwiftUI

struct ZoomableImage: View {
    let image: UIImage
    @GestureState private var scale: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geo in
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale * finalScale)
                .gesture(
                    MagnificationGesture()
                        .updating($scale, body: { (value, state, _) in
                            state = value
                        })
                        .onEnded { value in
                            finalScale *= value
                        }
                )
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}
