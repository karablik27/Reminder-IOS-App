import SwiftUI

// MARK: - ImagePickerView
struct ImagePickerView: UIViewControllerRepresentable {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedImage: UIImage?
    var useCamera: Bool = false

    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        if useCamera, UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // MARK: - Properties
        let parent: ImagePickerView

        // MARK: - Init
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        // MARK: - Delegate Methods
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
