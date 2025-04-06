import SwiftUI
import SwiftData

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AddEventViewModel
    

    // Состояния для выбора иконки и показа шитов
    @State private var showIconActionSheet = false
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var userSelectedImage: UIImage? = nil
    
    @State private var showCalendarSheet = false
    @State private var showTimePicker = false
    @State private var showTypeMenu = false
    @State private var isTypeExpanded = false
    
    @State private var showRemindMenu = false
    @State private var isRemindExpanded = false
    
    @State private var showHowOftenMenu = false
    @State private var isHowOftenExpanded = false
    

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 0) {
                // Верхняя панель
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Скролл-контент
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        iconAndTitleSection
                        fieldNameSection
                        dateSection
                        timeSection
                        typeSection
                        informationSection
                        firstRemindButtonSection
                        howOftenButtonSection
                        createButton
                        Spacer(minLength: 40)
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        // Шиты для выбора даты, типа, изображения и т.д.
        .sheet(isPresented: $showCalendarSheet) {
            CustomCalendarView(selectedDate: $viewModel.newEventDate)
                .presentationDetents([.height(520), .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(25)
        }
        .sheet(isPresented: $showTypeMenu, onDismiss: {
            isTypeExpanded = false
            viewModel.updateIcon()
        }) {
            CustomTypeSelectionMenuAddEvent(isPresented: $showTypeMenu,
                                            selectedType: $viewModel.newType)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(selectedImage: $userSelectedImage, useCamera: showCamera)
        }
        .sheet(isPresented: $showRemindMenu, onDismiss: {
            isRemindExpanded = false
        }) {
            CustomFirstRemindSelectionMenuAddEvent(isPresented: $showRemindMenu,
                                                   selectedRemind: $viewModel.newFirstRemind)
        }
        .sheet(isPresented: $showHowOftenMenu, onDismiss: {
            isHowOftenExpanded = false
        }) {
            CustomHowOftenSelectionMenuAddEvent(isPresented: $showHowOftenMenu,
                                                selectedHowOften: $viewModel.newHowOften)
        }
        .sheet(isPresented: $showTimePicker) {
            CustomTimePickerView(selectedTime: $viewModel.newEventTime)
        }
        .onAppear {
            viewModel.updateNextEventNumber()
        }
        .onChange(of: userSelectedImage) { newImage, _ in
            if let newImage = newImage {
                viewModel.newIconData = newImage.jpegData(compressionQuality: 1.0)
            } else {
                viewModel.newIconData = nil
            }
        }
    }
}

extension AddEventView {
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
                        } else if viewModel.newType != .none {
                            Image(viewModel.defaultIcon(for: viewModel.newType))
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
                    ActionSheet(title: Text("Choose icon".localized), buttons: [
                        .default(Text("Take Photo".localized), action: {
                            showCamera = true
                            showImagePicker = true
                        }),
                        .default(Text("Choose from Gallery".localized), action: {
                            showCamera = false
                            showImagePicker = true
                        }),
                        .default(Text("Use default icon".localized), action: {
                            userSelectedImage = nil
                        }),
                        .cancel()
                    ])
                }
                Text(viewModel.displayedTitle.localized)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
    }
    
    private var fieldNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name".localized)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            TextField("Event title".localized, text: $viewModel.newTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal, 16)
    }
    
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date".localized)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Button {
                showCalendarSheet = true
            } label: {
                HStack {
                    Text(viewModel.newEventDate.formatted(date: .numeric, time: .omitted))
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1))
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var timeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Time".localized)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Button {
                showTimePicker = true
            } label: {
                HStack {
                    Text(viewModel.newEventTime, format: .dateTime.hour().minute())
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "clock")
                        .foregroundColor(.black)
                }
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1))
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var typeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Type".localized)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Button {
                isTypeExpanded.toggle()
                showTypeMenu = true
            } label: {
                HStack {
                    Text(viewModel.newType.displayName)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isTypeExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1))
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Information".localized)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            TextField("Add information".localized, text: $viewModel.newInformation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal, 16)
    }
    
    private var firstRemindButtonSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("First remind".localized)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Button {
                isRemindExpanded.toggle()
                showRemindMenu = true
            } label: {
                HStack {
                    Text(viewModel.newFirstRemind.displayName)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isRemindExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1))
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var howOftenButtonSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reminder Frequency".localized)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Button {
                isHowOftenExpanded.toggle()
                showHowOftenMenu = true
            } label: {
                HStack {
                    Text(viewModel.newHowOften.displayName)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isHowOftenExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1))
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var createButton: some View {
        Button {
            if let userImage = userSelectedImage {
                viewModel.newIconData = userImage.jpegData(compressionQuality: 1.0)
            } else {
                viewModel.newIconData = nil
                viewModel.newIcon = viewModel.defaultIcon(for: viewModel.newType)
            }
            viewModel.addEvent()
            dismiss()
        } label: {
            Text("Create".localized)
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background((viewModel.newTitle.isEmpty || viewModel.newType == .none)
                            ? Colors.createButtonDisabledColor
                            : Colors.mainGreen)
                .cornerRadius(16)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .disabled(viewModel.newTitle.isEmpty || viewModel.newType == .none)
    }
}
