import SwiftUI
import SwiftData

struct EditEventView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var mainViewModel: EventsViewModel
    @StateObject var viewModel: EditEventViewModel

    // MARK: UI State
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
                // MARK: Navigation Bar
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: CommonConstants.navBarIconSize, weight: .bold))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal, CommonConstants.horizontalPadding)
                .padding(.vertical, CommonConstants.verticalPadding)
                
                // MARK: Scrollable Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: CommonConstants.sectionSpacing) {
                        IconAndTitleSection(userSelectedImage: userSelectedImage,
                                              eventType: viewModel.eventType,
                                              defaultIcon: viewModel.defaultIcon(for:),
                                              displayedTitle: viewModel.displayedTitle,
                                              onIconTap: { showIconActionSheet = true })
                        FieldNameSection(label: "Name",
                                         placeholder: "Event title",
                                         text: $viewModel.title)
                        LabeledButtonSection(label: "Date",
                                             text: viewModel.eventDate.formatted(date: .numeric, time: .omitted),
                                             icon: "calendar",
                                             action: { showCalendarSheet = true })
                        LabeledButtonSection(label: "Time",
                                             text: viewModel.eventTime.formatted(date: .omitted, time: .shortened),
                                             icon: "clock",
                                             action: { showTimePicker = true })
                        LabeledButtonSection(label: "Type",
                                             text: viewModel.eventType.displayName,
                                             icon: isTypeExpanded ? "chevron.up" : "chevron.down",
                                             action: { isTypeExpanded.toggle(); showTypeMenu = true })
                        LabeledButtonSection(label: "First Remind",
                                             text: viewModel.firstRemind.displayName,
                                             icon: isRemindExpanded ? "chevron.up" : "chevron.down",
                                             action: { isRemindExpanded.toggle(); showRemindMenu = true })
                        LabeledButtonSection(label: "Reminder Frequency",
                                             text: viewModel.howOften.displayName,
                                             icon: isHowOftenExpanded ? "chevron.up" : "chevron.down",
                                             action: { isHowOftenExpanded.toggle(); showHowOftenMenu = true })
                        LabeledNavigationLinkSection(label: "Information",
                                                     text: "Information".localized,
                                                     icon: "chevron.right",
                                                     destination: { EventInformationEditView(viewModel: viewModel) } )
                        actionButtons
                        Spacer(minLength: CommonConstants.bottomSpacerMinLength)
                    }
                    .padding(.bottom, CommonConstants.sectionSpacing)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        // MARK: Sheets
        .sheet(isPresented: $showCalendarSheet) {
            CustomCalendarView(selectedDate: $viewModel.eventDate)
                .presentationDetents([.height(CommonConstants.calendarSheetHeight), .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(CommonConstants.presentationCornerRadius)
        }
        .sheet(isPresented: $showTypeMenu, onDismiss: {
            isTypeExpanded = false
            viewModel.updateIcon()
        }) {
            CustomTypeSelectionMenuAddEvent(isPresented: $showTypeMenu,
                                            selectedType: $viewModel.eventType)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(selectedImage: $userSelectedImage, useCamera: showCamera)
        }
        .sheet(isPresented: $showRemindMenu, onDismiss: { isRemindExpanded = false }) {
            CustomFirstRemindSelectionMenuAddEvent(isPresented: $showRemindMenu,
                                                   selectedRemind: $viewModel.firstRemind)
        }
        .sheet(isPresented: $showHowOftenMenu, onDismiss: { isHowOftenExpanded = false }) {
            CustomHowOftenSelectionMenuAddEvent(isPresented: $showHowOftenMenu,
                                                selectedHowOften: $viewModel.howOften)
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
                viewModel.iconData = newImage.jpegData(compressionQuality: CommonConstants.imageCompressionQuality)
            } else {
                viewModel.iconData = nil
            }
        }
    }
}

extension EditEventView {
    // Блок с кнопками действий (Delete и Save)
    private var actionButtons: some View {
        HStack(spacing: CommonConstants.sectionSpacing / 2) {
            Button {
                viewModel.deleteEvent()
                mainViewModel.loadEvents()
                dismiss()
            } label: {
                Text("Delete".localized)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: CommonConstants.createButtonMinHeight)
                    .background(Color.red)
                    .cornerRadius(CommonConstants.cornerRadius)
            }
            
            Button {
                if let userImage = userSelectedImage {
                    viewModel.iconData = userImage.jpegData(compressionQuality: CommonConstants.imageCompressionQuality)
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
                    .frame(maxWidth: .infinity, minHeight: CommonConstants.createButtonMinHeight)
                    .background(Colors.buttonGreen)
                    .cornerRadius(CommonConstants.cornerRadius)
            }
        }
        .padding(.horizontal, CommonConstants.horizontalPadding)
        .padding(.vertical, CommonConstants.sectionSpacing)
    }
}
