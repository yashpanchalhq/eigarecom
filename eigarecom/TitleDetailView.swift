import SwiftUI
import SwiftData
struct TitleDetailView: View {
    let title: Title
    var titleName: String {
        return (title.name ?? title.title) ?? ""
    }
    
    let viewModel = ViewModel()
    @Environment(\.modelContext) var modelContext

    private var displayTitle: String {
        (title.name ?? title.title) ?? "Untitled"
    }

    var body: some View {
        GeometryReader { geometry in
            switch viewModel.videoIdStatus {
            case .notStarted:
                EmptyView()
            case .fetching:
                ProgressView()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
            case .success:
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        YoutubePlayer(videoId: viewModel.videoId)
                            .aspectRatio(1.3, contentMode: .fit)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height * 0.72
                        )
                        .clipped()

                        VStack(alignment: .leading, spacing: 12) {
                            Text(displayTitle)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .fixedSize(horizontal: false, vertical: true)

                            if let overview = title.overview, !overview.isEmpty {
                                Text("Synopsis")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                    .padding(.top, 4)

                                Text(overview)
                                    .font(.body)
                                    .foregroundStyle(.primary.opacity(0.9))
                                    .lineSpacing(5)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Button{
                                    let saveTitle = title
                                    saveTitle.title = titleName
                                    modelContext.insert(saveTitle)
                                    try? modelContext.save()
                                }label: {
                                    Text(Constants.downloadString)
                                        .secondaryActionButton()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 32)
                    }
                }
                .background(Color(.systemBackground))
                .ignoresSafeArea(edges: .top)
            case .failure(let underlyingError):
                Text(underlyingError.localizedDescription)
            }
        }
        .task {
            await viewModel.getVideoId(for: titleName) 
        }
    }
}

#Preview {
    TitleDetailView(title: Title.previewTitles[0])
}
