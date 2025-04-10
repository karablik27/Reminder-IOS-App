import SwiftUI

struct EventInformationEditView: View {
    @ObservedObject var viewModel: EditEventViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var isPhotoGridExpanded: Bool = false
    @State private var isPreviewPresented = false
    @State private var previewIndex = 0

    var body: some View {
        VStack(alignment: .leading, spacing: EventInformationUI.outerStackSpacing) {
            TopHeaderView(title: "Information".localized) {
                dismiss()
            }
            
            PhotoGridSectionView(
                photos: viewModel.additionalPhotos,
                isSelectionMode: viewModel.isSelectionMode,
                selectedForDeletion: viewModel.selectedForDeletion,
                photoMaxCountBeforeExpand: EventInformationUI.photoMaxCountBeforeExpand,
                toggleSelectionMode: {
                    viewModel.isSelectionMode.toggle()
                    viewModel.selectedForDeletion.removeAll()
                },
                showPhotoPicker: {
                    showImagePicker = true
                },
                toggleSelection: { index in
                    viewModel.toggleSelection(index)
                },
                onPreviewPhoto: { index in
                    previewIndex = index
                    isPreviewPresented = true
                },
                deleteSelectedPhotos: {
                    viewModel.deleteSelectedPhotos()
                },
                isPhotoGridExpanded: $isPhotoGridExpanded
            )
            
            DetailsSectionView(detailsText: $viewModel.information)
            
            Spacer()
        }
        .navigationBarHidden(true)
        .background(Color.white)
        .sheet(isPresented: $showImagePicker, onDismiss: {
            if let image = selectedImage {
                viewModel.additionalPhotos.append(image)
            }
        }) {
            ImagePickerView(selectedImage: $selectedImage, useCamera: false)
        }
        .fullScreenCover(isPresented: $isPreviewPresented) {
            ImageGalleryPreview(images: viewModel.additionalPhotos, startIndex: previewIndex) {
                isPreviewPresented = false
            }
        }
    }
}
