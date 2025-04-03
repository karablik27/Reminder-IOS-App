import SwiftUI
import SwiftData


struct HistorySearchScreen: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Binding var isSearchActive: Bool
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack(spacing: SearchConstants.VStackSpacing) {
                Text("History")
                    .font(.system(size: ConstantsMain.Text.titleSize, weight: .bold))
                    .foregroundColor(.primary)
                HStack(spacing: SearchConstants.HStackSpacing) {
                    Button {
                        withAnimation { isSearchActive = false }
                    } label: {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: SearchConstants.iconSize, height: SearchConstants.iconSize)
                            .foregroundColor(.black)
                    }
                    TextField("", text: $viewModel.searchText)
                        .foregroundColor(.black)
                        .disableAutocorrection(true)
                        .placeholder(when: viewModel.searchText.isEmpty) {
                            Text("Search beautiful events...")
                                .foregroundColor(.black)
                        }
                    Button {
                        withAnimation { isSearchActive = false }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: SearchConstants.iconSize, height: SearchConstants.iconSize)
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical, SearchConstants.paddingVertical)
                .padding(.horizontal)
                .background(Colors.GreenTabBar)
                .cornerRadius(SearchConstants.cornerRadius)
                .padding(.horizontal)
                
                if viewModel.searchResults.isEmpty {
                    Spacer()
                    Text("No beautiful events found")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.searchResults, id: \.id) { event in
                            eventCell(model: event)
                                .frame(height: ConstantsMain.contentSection.frameHeight)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.deleteEvent(event)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                Spacer()
            }
            .navigationBarHidden(true)
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

private extension HistorySearchScreen {
    func eventCell(model: MainModel) -> some View {
        HStack {
            Button {
                viewModel.toggleBookmark(for: model)
            } label: {
                Image(systemName: model.isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.system(size: ConstantsMain.eventCell.fontSizeIcon))
                    .foregroundColor(model.isBookmarked ? .black : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.leading, ConstantsMain.eventCell.paddingLeading)
            .padding(.trailing, ConstantsMain.eventCell.paddingTrailing)
            
            if let iconData = model.iconData, let uiImage = UIImage(data: iconData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: ConstantsMain.eventCell.iconSize, height: ConstantsMain.eventCell.iconSize)
                    .clipShape(Circle())
            } else {
                Image(model.icon)
                    .resizable()
                    .frame(width: ConstantsMain.eventCell.iconSize, height: ConstantsMain.eventCell.iconSize)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.headline)
                Text("\(model.dateFormatted) \(model.dayOfWeek)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            NavigationLink(destination: EditEventView(viewModel: EditEventViewModel(modelContext: modelContext, event: model))
                                .environmentObject(viewModel)) {
                HStack(spacing: ConstantsMain.eventCell.HStackspacing) {
                    Text(viewModel.timeLeftString(for: model))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
        .padding(.vertical, ConstantsMain.eventCell.paddingVertical)
        .background(Color.white)
        .cornerRadius(ConstantsMain.eventCell.cornerRadius)
        .shadow(radius: ConstantsMain.eventCell.shadowRadius)
    }
}


