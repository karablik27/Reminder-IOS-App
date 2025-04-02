import SwiftUI
import SwiftData

struct EditEventView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var mainViewModel: MainViewModel
    
    /// ВАЖНО: используем @StateObject, чтобы viewModel не сбрасывался
    @StateObject var viewModel: EditEventViewModel
    
    // MARK: - Local states for image picking
    @State private var showIconActionSheet = false
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var userSelectedImage: UIImage? = nil
    
    // MARK: - States for calendar / time / type
    @State private var showCalendarSheet = false
    @State private var showTimePicker = false
    @State private var showTypeMenu = false
    @State private var isTypeExpanded = false
    
    // MARK: - States for FirstRemind
    @State private var showRemindMenu = false
    @State private var isRemindExpanded = false
    
    // MARK: - States for HowOften
    @State private var showHowOftenMenu = false
    @State private var isHowOftenExpanded = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Top bar (only "Back" button)
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // MARK: - Scrollable content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        iconAndTitleSection
                        
                        // NAME
                        fieldNameSection
                        
                        // DATE
                        dateSection
                        
                        timeSection
                        
                        // TYPE
                        typeSection
                        
                        // INFORMATION
                        informationSection
                        
                        // FIRST REMIND
                        firstRemindButtonSection
                        
                        // HOW OFTEN
                        howOftenButtonSection
                        
                        // DELETE & SAVE buttons (внизу)
                        actionButtons
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
        // MARK: - Sheets
        .sheet(isPresented: $showCalendarSheet) {
            CustomCalendarView(selectedDate: $viewModel.eventDate)
                .presentationDetents([.height(520), .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(25)
        }
        .sheet(isPresented: $showTypeMenu, onDismiss: {
            isTypeExpanded = false
            viewModel.updateIcon()
        }) {
            CustomTypeSelectionMenuAddEvent(
                isPresented: $showTypeMenu,
                selectedType: $viewModel.eventType
            )
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(
                selectedImage: $userSelectedImage,
                useCamera: showCamera
            )
        }
        .sheet(isPresented: $showRemindMenu, onDismiss: {
            isRemindExpanded = false
        }) {
            CustomFirstRemindSelectionMenuAddEvent(
                isPresented: $showRemindMenu,
                selectedRemind: $viewModel.firstRemind
            )
        }
        .sheet(isPresented: $showHowOftenMenu, onDismiss: {
            isHowOftenExpanded = false
        }) {
            CustomHowOftenSelectionMenuAddEvent(
                isPresented: $showHowOftenMenu,
                selectedHowOften: $viewModel.howOften
            )
        }
        .sheet(isPresented: $showTimePicker) {
            CustomTimePickerView(selectedTime: $viewModel.eventTime)
        }
        
        // MARK: - onAppear
        .onAppear {
            // If the event has an existing image, load it
            if let image = viewModel.eventImage {
                userSelectedImage = image
            }
        }
        // MARK: - Sync local image -> viewModel.iconData
        .onChange(of: userSelectedImage) { newImage, oldImage in
            if let newImage = newImage {
                viewModel.iconData = newImage.jpegData(compressionQuality: 1.0)
            } else {
                viewModel.iconData = nil
            }
        }
    }
}

// MARK: - Subviews
extension EditEventView {
    
    // 1) Icon + Title
    private var iconAndTitleSection: some View {
        HStack {
            Spacer()
            HStack(spacing: 16) {
                Button {
                    showIconActionSheet = true
                } label: {
                    ZStack {
                        Circle()
                            .stroke(Color.black, lineWidth: 2)
                            .frame(width: 80, height: 80)
                        
                        if let userImage = userSelectedImage {
                            Image(uiImage: userImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else if viewModel.eventType != .none {
                            Image(viewModel.defaultIcon(for: viewModel.eventType))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .actionSheet(isPresented: $showIconActionSheet) {
                    ActionSheet(
                        title: Text("Choose icon"),
                        buttons: [
                            .default(Text("Take Photo"), action: {
                                showCamera = true
                                showImagePicker = true
                            }),
                            .default(Text("Choose from Gallery"), action: {
                                showCamera = false
                                showImagePicker = true
                            }),
                            .default(Text("Use default icon"), action: {
                                userSelectedImage = nil
                            }),
                            .cancel()
                        ]
                    )
                }
                
                Text(viewModel.displayedTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
    }
    
    // 2) NAME
    private var fieldNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NAME")
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            TextField("Event title", text: $viewModel.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal, 16)
    }
    
    // 3) DATE
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DATE")
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Button {
                showCalendarSheet = true
            } label: {
                HStack {
                    Text(viewModel.eventDate.formatted(date: .numeric, time: .omitted))
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 16)
    }
    
    // 4) TIME
    private var timeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TIME")
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Button {
                showTimePicker = true
            } label: {
                HStack {
                    Text(viewModel.eventTime, format: .dateTime.hour().minute())
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "clock")
                        .foregroundColor(.black)
                }
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 16)
    }
    
    // 5) TYPE
    private var typeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TYPE")
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Button {
                isTypeExpanded.toggle()
                showTypeMenu = true
            } label: {
                HStack {
                    Text(viewModel.eventType.rawValue)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isTypeExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 16)
    }
    
    // 6) INFORMATION
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("INFORMATION")
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            TextField("Add information", text: $viewModel.information)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal, 16)
    }
    
    // 7) FIRST REMIND
    private var firstRemindButtonSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("FIRST REMIND")
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Button {
                isRemindExpanded.toggle()
                showRemindMenu = true
            } label: {
                HStack {
                    Text(viewModel.firstRemind.rawValue)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isRemindExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 16)
    }
    
    // 8) HOW OFTEN
    private var howOftenButtonSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("HOW OFTEN")
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Button {
                isHowOftenExpanded.toggle()
                showHowOftenMenu = true
            } label: {
                HStack {
                    Text(viewModel.howOften.rawValue)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isHowOftenExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 16)
    }
    
    // 9) DELETE & SAVE buttons at the bottom
    private var actionButtons: some View {
        HStack(spacing: 8) {
            // DELETE (red)
            Button {
                viewModel.deleteEvent()
                mainViewModel.loadEvents()
                dismiss()
            } label: {
                Text("DELETE")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .buttonStyle(.plain)
                    .background(Color.red)
                    .cornerRadius(16)
            }
            
            // SAVE (green)
            Button {
                // If user picked a new image
                if let userImage = userSelectedImage {
                    viewModel.iconData = userImage.jpegData(compressionQuality: 1.0)
                } else {
                    viewModel.iconData = nil
                }
                // Save changes
                viewModel.saveChanges()
                mainViewModel.loadEvents()
                dismiss()
            } label: {
                Text("SAVE")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .buttonStyle(.plain)
                    .background(Color.green)
                    .cornerRadius(16)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
