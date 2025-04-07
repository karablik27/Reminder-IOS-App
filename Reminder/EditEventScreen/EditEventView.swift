import SwiftUI
import SwiftData

// MARK: - Constants
private enum Constants {
    static let topPadding: CGFloat = 8
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 8
    static let sectionSpacing: CGFloat = 16
    static let fieldSpacing: CGFloat = 8
    static let buttonSpacing: CGFloat = 8
    static let bottomSpacer: CGFloat = 40
    static let iconSize: CGFloat = 80
    static let iconBorderWidth: CGFloat = 2
    static let cameraIconSize: CGFloat = 40
    static let calendarSheetHeight: CGFloat = 656
    static let cornerRadius: CGFloat = 8
    static let sheetCornerRadius: CGFloat = 25
    static let buttonHeight: CGFloat = 50
    static let deleteButtonCornerRadius: CGFloat = 16
    static let saveButtonCornerRadius: CGFloat = 16
    static let iconCompressionQuality: CGFloat = 1.0
}

struct EditEventView: View {
    @Environment(\..dismiss) private var dismiss
    @EnvironmentObject var mainViewModel: MainViewModel

    @StateObject var viewModel: EditEventViewModel

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

            VStack(spacing: .zero) {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, Constants.verticalPadding)

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
                        actionButtons
                        Spacer(minLength: Constants.bottomSpacer)
                    }
                    .padding(.bottom, Constants.fieldSpacing)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showCalendarSheet) {
            CustomCalendarView(selectedDate: $viewModel.eventDate)
                .presentationDetents([.height(Constants.calendarSheetHeight), .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(Constants.sheetCornerRadius)
        }
        .sheet(isPresented: $showTypeMenu, onDismiss: {
            isTypeExpanded = false
            viewModel.updateIcon()
        }) {
            CustomTypeSelectionMenuAddEvent(isPresented: $showTypeMenu, selectedType: $viewModel.eventType)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(selectedImage: $userSelectedImage, useCamera: showCamera)
        }
        .sheet(isPresented: $showRemindMenu, onDismiss: { isRemindExpanded = false }) {
            CustomFirstRemindSelectionMenuAddEvent(isPresented: $showRemindMenu, selectedRemind: $viewModel.firstRemind)
        }
        .sheet(isPresented: $showHowOftenMenu, onDismiss: { isHowOftenExpanded = false }) {
            CustomHowOftenSelectionMenuAddEvent(isPresented: $showHowOftenMenu, selectedHowOften: $viewModel.howOften)
        }
        .sheet(isPresented: $showTimePicker) {
            CustomTimePickerView(selectedTime: $viewModel.eventTime)
        }
        .onAppear {
            if let image = viewModel.eventImage {
                userSelectedImage = image
            }
        }
        .onChange(of: userSelectedImage) { newImage, _ in
            if let newImage = newImage {
                viewModel.iconData = newImage.jpegData(compressionQuality: Constants.iconCompressionQuality)
            } else {
                viewModel.iconData = nil
            }
        }
    }
}

// MARK: - Constants
private enum EditEventConstants {
    static let iconBorderWidth: CGFloat = 2
    static let iconSize: CGFloat = 80
    static let cameraIconSize: CGFloat = 40
    static let titleFontSize: CGFloat = 24
    static let titleSpacing: CGFloat = 16
    static let sectionPaddingHorizontal: CGFloat = 16
    static let sectionSpacing: CGFloat = 8
    static let calendarSheetHeight: CGFloat = 656
    static let calendarCornerRadius: CGFloat = 25
    static let buttonPadding: CGFloat = 12
    static let buttonCornerRadius: CGFloat = 8
    static let overlayStrokeOpacity: Double = 0.4
    static let overlayStrokeWidth: CGFloat = 1
    static let bottomSpacerMinLength: CGFloat = 40
    static let actionButtonSpacing: CGFloat = 8
    static let actionButtonHeight: CGFloat = 50
    static let actionButtonCornerRadius: CGFloat = 16
    static let iconCompressionQuality: CGFloat = 1.0
}

// MARK: - Subviews
extension EditEventView {

    // MARK: 1) Icon + Title
    private var iconAndTitleSection: some View {
        HStack {
            Spacer()
            HStack(spacing: EditEventConstants.titleSpacing) {
                Button {
                    showIconActionSheet = true
                } label: {
                    ZStack {
                        Circle()
                            .stroke(Color.black, lineWidth: EditEventConstants.iconBorderWidth)
                            .frame(width: EditEventConstants.iconSize, height: EditEventConstants.iconSize)

                        if let userImage = userSelectedImage {
                            Image(uiImage: userImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: EditEventConstants.iconSize, height: EditEventConstants.iconSize)
                                .clipShape(Circle())
                        } else if viewModel.eventType != .none {
                            Image(viewModel.defaultIcon(for: viewModel.eventType))
                                .resizable()
                                .scaledToFill()
                                .frame(width: EditEventConstants.iconSize, height: EditEventConstants.iconSize)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .frame(width: EditEventConstants.cameraIconSize, height: EditEventConstants.cameraIconSize)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .actionSheet(isPresented: $showIconActionSheet) {
                    ActionSheet(
                        title: Text("Choose icon".localized),
                        buttons: [
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
                        ]
                    )
                }

                Text(viewModel.displayedTitle.localized)
                    .font(.system(size: EditEventConstants.titleFontSize, weight: .bold))
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(.top, EditEventConstants.sectionSpacing)
        .padding(.horizontal, EditEventConstants.sectionPaddingHorizontal)
    }

    // MARK: 2) NAME
    private var fieldNameSection: some View {
        VStack(alignment: .leading, spacing: EditEventConstants.sectionSpacing) {
            Text("Name".localized)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)

            TextField("Event title".localized, text: $viewModel.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal, EditEventConstants.sectionPaddingHorizontal)
    }

    // MARK: 3) DATE
    private var dateSection: some View {
        labeledButtonSection(label: "Date", text: viewModel.eventDate.formatted(date: .numeric, time: .omitted), icon: "calendar") {
            showCalendarSheet = true
        }
    }

    // MARK: 4) TIME
    private var timeSection: some View {
        labeledButtonSection(label: "Time", text: viewModel.eventTime.formatted(date: .omitted, time: .shortened), icon: "clock") {
            showTimePicker = true
        }
    }

    // MARK: 5) TYPE
    private var typeSection: some View {
        labeledButtonSection(label: "Type", text: viewModel.eventType.displayName, icon: isTypeExpanded ? "chevron.up" : "chevron.down") {
            isTypeExpanded.toggle()
            showTypeMenu = true
        }
    }

    // MARK: 6) INFORMATION
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: EditEventConstants.sectionSpacing) {
            Text("Information".localized)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)

            TextField("Add information".localized, text: $viewModel.information)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal, EditEventConstants.sectionPaddingHorizontal)
    }

    // MARK: 7) FIRST REMIND
    private var firstRemindButtonSection: some View {
        labeledButtonSection(label: "First Remind", text: viewModel.firstRemind.displayName, icon: isRemindExpanded ? "chevron.up" : "chevron.down") {
            isRemindExpanded.toggle()
            showRemindMenu = true
        }
    }

    // MARK: 8) HOW OFTEN
    private var howOftenButtonSection: some View {
        labeledButtonSection(label: "Reminder Frequency", text: viewModel.howOften.displayName, icon: isHowOftenExpanded ? "chevron.up" : "chevron.down") {
            isHowOftenExpanded.toggle()
            showHowOftenMenu = true
        }
    }

    // MARK: 9) ACTION BUTTONS
    private var actionButtons: some View {
        HStack(spacing: EditEventConstants.actionButtonSpacing) {
            Button {
                viewModel.deleteEvent()
                mainViewModel.loadEvents()
                dismiss()
            } label: {
                Text("Delete".localized)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: EditEventConstants.actionButtonHeight)
                    .buttonStyle(.plain)
                    .background(Color.red)
                    .cornerRadius(EditEventConstants.actionButtonCornerRadius)
            }

            Button {
                if let userImage = userSelectedImage {
                    viewModel.iconData = userImage.jpegData(compressionQuality: EditEventConstants.iconCompressionQuality)
                } else {
                    viewModel.iconData = nil
                }
                viewModel.saveChanges()
                mainViewModel.loadEvents()
                dismiss()
            } label: {
                Text("Save".localized)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: EditEventConstants.actionButtonHeight)
                    .buttonStyle(.plain)
                    .background(Colors.buttonGreen)
                    .cornerRadius(EditEventConstants.actionButtonCornerRadius)
            }
        }
        .padding(.horizontal, EditEventConstants.sectionPaddingHorizontal)
        .padding(.vertical, EditEventConstants.sectionSpacing)
    }

    // MARK: - Reusable Labeled Button
    private func labeledButtonSection(label: String, text: String, icon: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: EditEventConstants.sectionSpacing) {
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
                        .foregroundColor(.gray)
                }
                .padding(EditEventConstants.buttonPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: EditEventConstants.buttonCornerRadius)
                        .stroke(Color.gray.opacity(EditEventConstants.overlayStrokeOpacity), lineWidth: EditEventConstants.overlayStrokeWidth)
                )
            }
        }
        .padding(.horizontal, EditEventConstants.sectionPaddingHorizontal)
    }
}
