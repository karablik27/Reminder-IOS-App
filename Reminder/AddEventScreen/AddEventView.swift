import SwiftUI
import SwiftData

// MARK: - Constants
private struct Constants {
    static let zeroSpacing: CGFloat = 0
    static let imageCompressionQuality: CGFloat = 1.0
    static let iconSize: CGFloat = 80
    static let iconStrokeWidth: CGFloat = 2
    static let defaultCameraIconSize: CGFloat = 40

    static let titleFontSize: CGFloat = 24
    static let navBarIconSize: CGFloat = 18
    static let navBarVerticalPadding: CGFloat = 8
    static let horizontalPadding: CGFloat = 16
    static let topPadding: CGFloat = 8
    static let spacing: CGFloat = 8
    static let sectionSpacing: CGFloat = 16
    static let bottomSpacerMinLength: CGFloat = 40

    static let buttonPadding: CGFloat = 12
    static let cornerRadius: CGFloat = 8
    static let createButtonMinHeight: CGFloat = 50
    static let createButtonCornerRadius: CGFloat = 16

    static let calendarSheetHeight: CGFloat = 656

    static let borderColorOpacity: Double = 0.4
    static let borderLineWidth: CGFloat = 1
}

// MARK: - AddEventView
struct AddEventView: View {
    @Environment(\..dismiss) private var dismiss
    @ObservedObject var viewModel: AddEventViewModel

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

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: Constants.zeroSpacing) {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: Constants.navBarIconSize, weight: .bold))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, Constants.navBarVerticalPadding)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                        iconAndTitleSection
                        fieldNameSection
                        dateSection
                        timeSection
                        typeSection
                        informationSection
                        firstRemindButtonSection
                        howOftenButtonSection
                        createButton
                        Spacer(minLength: Constants.bottomSpacerMinLength)
                    }
                    .padding(.bottom, Constants.spacing)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showCalendarSheet) {
            CustomCalendarView(selectedDate: $viewModel.newEventDate)
                .presentationDetents([.height(Constants.calendarSheetHeight), .large])
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
                viewModel.newIconData = newImage.jpegData(compressionQuality: Constants.imageCompressionQuality)
            } else {
                viewModel.newIconData = nil
            }
        }
    }
}

// MARK: - UI Components
extension AddEventView {

    // MARK: - Icon and Title Section
    private var iconAndTitleSection: some View {
        HStack {
            Spacer()
            HStack(spacing: Constants.spacing * 2) {
                Button {
                    showIconActionSheet = true
                } label: {
                    ZStack {
                        Circle()
                            .stroke(Color.black, lineWidth: Constants.iconStrokeWidth)
                            .frame(width: Constants.iconSize, height: Constants.iconSize)
                        if let userImage = userSelectedImage {
                            Image(uiImage: userImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: Constants.iconSize, height: Constants.iconSize)
                                .clipShape(Circle())
                        } else if viewModel.newType != .none {
                            Image(viewModel.defaultIcon(for: viewModel.newType))
                                .resizable()
                                .scaledToFill()
                                .frame(width: Constants.iconSize, height: Constants.iconSize)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .frame(width: Constants.defaultCameraIconSize, height: Constants.defaultCameraIconSize)
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
                    .font(.system(size: Constants.titleFontSize, weight: .bold))
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(.top, Constants.topPadding)
        .padding(.horizontal, Constants.horizontalPadding)
    }

    // MARK: - Reusable Text Field
    private func labeledTextField(label: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            Text(label.localized)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            TextField(placeholder.localized, text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }

    // MARK: - Field Name Section
    private var fieldNameSection: some View {
        labeledTextField(label: "Name", text: $viewModel.newTitle, placeholder: "Event title")
    }

    // MARK: - Reusable Button Section
    private func labeledButtonSection(label: String, text: String, icon: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            Text(label.localized)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Button(action: action) {
                HStack {
                    Text(text)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: icon)
                        .foregroundColor(.black)
                }
                .padding(Constants.buttonPadding)
                .overlay(RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(Color.gray.opacity(Constants.borderColorOpacity), lineWidth: Constants.borderLineWidth))
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }

    // MARK: - Date Section
    private var dateSection: some View {
        labeledButtonSection(label: "Date", text: viewModel.newEventDate.formatted(date: .numeric, time: .omitted), icon: "calendar") {
            showCalendarSheet = true
        }
    }

    // MARK: - Time Section
    private var timeSection: some View {
        labeledButtonSection(label: "Time", text: viewModel.newEventTime.formatted(date: .omitted, time: .shortened), icon: "clock") {
            showTimePicker = true
        }
    }

    // MARK: - Type Section
    private var typeSection: some View {
        labeledButtonSection(label: "Type", text: viewModel.newType.displayName, icon: isTypeExpanded ? "chevron.up" : "chevron.down") {
            isTypeExpanded.toggle()
            showTypeMenu = true
        }
    }

    // MARK: - Information Section
    private var informationSection: some View {
        labeledTextField(label: "Information", text: $viewModel.newInformation, placeholder: "Add information")
    }

    // MARK: - First Remind Section
    private var firstRemindButtonSection: some View {
        labeledButtonSection(label: "First remind", text: viewModel.newFirstRemind.displayName, icon: isRemindExpanded ? "chevron.up" : "chevron.down") {
            isRemindExpanded.toggle()
            showRemindMenu = true
        }
    }

    // MARK: - How Often Section
    private var howOftenButtonSection: some View {
        labeledButtonSection(label: "Reminder Frequency", text: viewModel.newHowOften.displayName, icon: isHowOftenExpanded ? "chevron.up" : "chevron.down") {
            isHowOftenExpanded.toggle()
            showHowOftenMenu = true
        }
    }

    // MARK: - Create Button
    private var createButton: some View {
        Button {
            if let userImage = userSelectedImage {
                viewModel.newIconData = userImage.jpegData(compressionQuality: Constants.imageCompressionQuality)
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
                .frame(maxWidth: .infinity, minHeight: Constants.createButtonMinHeight)
                .background((viewModel.newTitle.isEmpty || viewModel.newType == .none)
                            ? Colors.createButtonDisabledColor
                            : Colors.mainGreen)
                .cornerRadius(Constants.createButtonCornerRadius)
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, Constants.spacing)
        .disabled(viewModel.newTitle.isEmpty || viewModel.newType == .none)
    }
}
