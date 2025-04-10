import SwiftUI

struct PhotoGridSectionView: View {
    let photos: [UIImage]
    let isSelectionMode: Bool
    let selectedForDeletion: Set<Int>
    let photoMaxCountBeforeExpand: Int
    let toggleSelectionMode: () -> Void
    let showPhotoPicker: () -> Void
    let toggleSelection: (Int) -> Void
    let onPreviewPhoto: (Int) -> Void
    let deleteSelectedPhotos: () -> Void
    @Binding var isPhotoGridExpanded: Bool
    
    private let gridColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        VStack(alignment: .leading, spacing: EventInformationUI.sectionStackSpacing) {
            HStack {
                Text("Photos".localized)
                    .font(.headline)
                Spacer()
                Button(isSelectionMode ? "Cancel" : "Select") {
                    withAnimation {
                        toggleSelectionMode()
                    }
                }
                .foregroundColor(.black)
            }
            .padding(.horizontal, EventInformationUI.horizontalPadding)
            
            // Сетка фото
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: EventInformationUI.gridSpacing) {
                    if !isSelectionMode {
                        Button(action: {
                            showPhotoPicker()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: EventInformationUI.cornerRadius)
                                    .stroke(Color.primary, lineWidth: EventInformationUI.plusButtonStrokeWidth)
                                    .frame(width: EventInformationUI.photoSize, height: EventInformationUI.photoSize)
                                    .background(Color.white)
                                
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: EventInformationUI.plusIconSize, height: EventInformationUI.plusIconSize)
                                    .foregroundColor(Colors.mainGreen)
                            }
                        }
                    }
                    
                    ForEach(photos.indices, id: \.self) { index in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: photos[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: EventInformationUI.photoSize, height: EventInformationUI.photoSize)
                                .clipped()
                                .overlay(
                                    RoundedRectangle(cornerRadius: EventInformationUI.cornerRadius)
                                        .stroke(selectedForDeletion.contains(index) ? Color.red : Color.primary,
                                                lineWidth: EventInformationUI.imageWidth)
                                )
                                .cornerRadius(EventInformationUI.cornerRadius)
                                .onTapGesture {
                                    if isSelectionMode {
                                        toggleSelection(index)
                                    } else {
                                        onPreviewPhoto(index)
                                    }
                                }
                            
                            if isSelectionMode && selectedForDeletion.contains(index) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.red)
                                    .background(Color.white.clipShape(Circle()))
                                    .offset(x: EventInformationUI.checkmarkOffsetX, y: EventInformationUI.checkmarkOffsetY)
                            }
                        }
                    }
                }
                .padding(.horizontal, EventInformationUI.horizontalPadding)
                .padding(.top, EventInformationUI.photoGridTopPadding)
            }
            .frame(height: isPhotoGridExpanded ? nil : EventInformationUI.photoGridCollapsedHeight)
            
            if isSelectionMode && !selectedForDeletion.isEmpty {
                Button("Delete Selected ".localized + "(\(selectedForDeletion.count))") {
                    withAnimation {
                        deleteSelectedPhotos()
                    }
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(EventInformationUI.deleteButtonCornerRadius)
                .padding(.horizontal, EventInformationUI.horizontalPadding)
            }
            
            if photos.count > photoMaxCountBeforeExpand && !isSelectionMode {
                Button(isPhotoGridExpanded ? "Show Less" : "Show More") {
                    withAnimation {
                        isPhotoGridExpanded.toggle()
                    }
                }
                .foregroundColor(.black)
                .padding(.horizontal, EventInformationUI.horizontalPadding)
            }
        }
    }
}
