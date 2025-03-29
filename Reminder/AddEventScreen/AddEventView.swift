import SwiftUI
import SwiftData

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var mainViewModel: MainViewModel
    @ObservedObject var viewModel: AddEventViewModel
    
    // Состояния для выбора иконки
    @State private var showIconActionSheet = false
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var userSelectedImage: UIImage? = nil
    
    // Состояния для календаря / выбора типа
    @State private var showCalendarSheet = false
    @State private var showTimePicker = false
    @State private var showTypeMenu = false
    @State private var isTypeExpanded = false
    
    // Состояния для FirstRemind
    @State private var showRemindMenu = false
    @State private var isRemindExpanded = false
    
    // Состояния для HowOften
    @State private var showHowOftenMenu = false
    @State private var isHowOftenExpanded = false
    
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Кастомный верхний бар
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
                
                // MARK: - Основная прокрутка
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
                        
                        // CREATE button
                        createButton
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showCalendarSheet) {
            CustomCalendarView(selectedDate: $viewModel.newEventDate)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(25)
        }
        .sheet(isPresented: $showTypeMenu, onDismiss: {
            isTypeExpanded = false
            viewModel.updateIcon()
        }) {
            CustomTypeSelectionMenuAddEvent(
                isPresented: $showTypeMenu,
                selectedType: $viewModel.newType
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
                selectedRemind: $viewModel.newFirstRemind
            )
        }
        .sheet(isPresented: $showHowOftenMenu, onDismiss: {
            isHowOftenExpanded = false
        }) {
            // Новый список выбора HowOften
            CustomHowOftenSelectionMenuAddEvent(
                isPresented: $showHowOftenMenu,
                selectedHowOften: $viewModel.newHowOften
            )
        }
        .sheet(isPresented: $showTimePicker) {
                CustomTimePickerView(selectedTime: $viewModel.newEventTime)
            }
        .onAppear {
            viewModel.updateNextEventNumber()
        }
    }
}

// MARK: - Вспомогательные View
extension AddEventView {
    
    // 1) Иконка + Заголовок
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
            
            TextField("Event title", text: $viewModel.newTitle)
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
                    Text(viewModel.newEventDate.formatted(date: .numeric, time: .omitted))
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
    
    // MARK: - TIME SECTION
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
                    Text(viewModel.newEventTime, format: .dateTime.hour().minute())
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
    
    // 4) TYPE
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
                    Text(viewModel.newType.rawValue)
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
    
    // 5) INFORMATION
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("INFORMATION")
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            TextField("Add information", text: $viewModel.newInformation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal, 16)
    }
    
    // 6) FIRST REMIND
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
                    Text(viewModel.newFirstRemind.rawValue)
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
    
    // 7) HOW OFTEN
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
                    Text(viewModel.newHowOften.rawValue)
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
    
    // 8) CREATE button
    private var createButton: some View {
        Button {
            if let userImage = userSelectedImage {
                viewModel.newIconData = userImage.jpegData(compressionQuality: 1.0)
            } else {
                viewModel.newIconData = nil
                viewModel.newIcon = viewModel.defaultIcon(for: viewModel.newType)
            }
            viewModel.addEvent()
            mainViewModel.loadEvents()
            dismiss()
        } label: {
            Text("CREATE")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .buttonStyle(.plain)
                .background(
                    (viewModel.newTitle.isEmpty || viewModel.newType == .none)
                    ? Colors.createButtonDisabledColor
                    : Colors.mainGreen
                )
                .cornerRadius(16)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .disabled(viewModel.newTitle.isEmpty || viewModel.newType == .none)
    }
}
