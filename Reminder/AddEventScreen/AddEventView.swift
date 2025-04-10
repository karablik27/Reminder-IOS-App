import SwiftUI
import SwiftData

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AddEventViewModel

    // MARK: - UI State
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
            VStack(spacing: CommonConstants.zeroSpacing) {
                // MARK: Navigation Bar Section
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: CommonConstants.navBarIconSize, weight: .bold))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, CommonConstants.verticalPadding)
                
                // MARK: Scrollable Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: CommonConstants.sectionSpacing) {
                        IconAndTitleSection(userSelectedImage: userSelectedImage,
                                              eventType: viewModel.newType,
                                              defaultIcon: viewModel.defaultIcon(for:),
                                              displayedTitle: viewModel.displayedTitle,
                                              onIconTap: { showIconActionSheet = true })
                        FieldNameSection(label: "Name",
                                         placeholder: "Event title",
                                         text: $viewModel.newTitle)
                        LabeledButtonSection(label: "Date",
                                             text: viewModel.newEventDate.formatted(date: .numeric, time: .omitted),
                                             icon: "calendar",
                                             action: { showCalendarSheet = true })
                        LabeledButtonSection(label: "Time",
                                             text: viewModel.newEventTime.formatted(date: .omitted, time: .shortened),
                                             icon: "clock",
                                             action: { showTimePicker = true })
                        LabeledButtonSection(label: "Type",
                                             text: viewModel.newType.displayName,
                                             icon: isTypeExpanded ? "chevron.up" : "chevron.down",
                                             action: { isTypeExpanded.toggle(); showTypeMenu = true })
                        LabeledButtonSection(label: "First remind",
                                             text: viewModel.newFirstRemind.displayName,
                                             icon: isRemindExpanded ? "chevron.up" : "chevron.down",
                                             action: { isRemindExpanded.toggle(); showRemindMenu = true })
                        LabeledButtonSection(label: "Reminder Frequency",
                                             text: viewModel.newHowOften.displayName,
                                             icon: isHowOftenExpanded ? "chevron.up" : "chevron.down",
                                             action: { isHowOftenExpanded.toggle(); showHowOftenMenu = true })
                        LabeledNavigationLinkSection(label: "Information",
                                                     text: "Information".localized,
                                                     icon: "chevron.right",
                                                     destination: { EventInformationView(viewModel: viewModel) } )
                        createButton
                        Spacer(minLength: CommonConstants.bottomSpacerMinLength)
                    }
                    .padding(.bottom, CommonConstants.spacing)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .actionSheet(isPresented: $showIconActionSheet) {
            ActionSheet(title: Text("Choose icon".localized), buttons: [
                .default(Text("Take Photo".localized)) {
                    showCamera = true
                    showImagePicker = true
                },
                .default(Text("Choose from Gallery".localized)) {
                    showCamera = false
                    showImagePicker = true
                },
                .default(Text("Use default icon".localized)) {
                    userSelectedImage = nil
                },
                .cancel()
            ])
        }
        // MARK: - Sheets
        .sheet(isPresented: $showCalendarSheet) {
            CustomCalendarView(selectedDate: $viewModel.newEventDate)
                .presentationDetents([.height(CommonConstants.calendarSheetHeight), .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(CommonConstants.presentationCornerRadius)
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
        // MARK: - Lifecycle
        .onAppear {
            viewModel.updateNextEventNumber()
        }
        .onChange(of: userSelectedImage) { newImage, _ in
            if let newImage = newImage {
                viewModel.newIconData = newImage.jpegData(compressionQuality: CommonConstants.imageCompressionQuality)
            } else {
                viewModel.newIconData = nil
            }
        }
    }
}

// MARK: - AddEventView
extension AddEventView {
    private var createButton: some View {
        Button {
            if let userImage = userSelectedImage {
                viewModel.newIconData = userImage.jpegData(compressionQuality: CommonConstants.imageCompressionQuality)
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
                .frame(maxWidth: .infinity, minHeight: CommonConstants.createButtonMinHeight)
                .background((viewModel.newTitle.isEmpty || viewModel.newType == .none)
                            ? Colors.createButtonDisabledColor
                            : Colors.mainGreen)
                .cornerRadius(CommonConstants.createButtonCornerRadius)
        }
        .padding(.horizontal, CommonConstants.horizontalPadding)
        .padding(.vertical, CommonConstants.spacing)
        .disabled(viewModel.newTitle.isEmpty || viewModel.newType == .none)
    }
}
