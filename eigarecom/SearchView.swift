import SwiftUI

struct SearchView: View {
    @State private var searchByMovies = true
    @State private var searchText = ""
    @State private var searchViewModel = SearchViewModel()
    @State private var navigationPath = NavigationPath()

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let error = searchViewModel.errorMessage {
                        Text(error)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(searchViewModel.searchTitles) { title in
                            AsyncImage(url: URL(string: title.posterPath ?? "")) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                case .failure:
                                    Color(.secondarySystemBackground)
                                        .overlay {
                                            Image(systemName: "film")
                                                .foregroundStyle(.secondary)
                                        }
                                case .empty:
                                    Color(.secondarySystemBackground)
                                        .overlay {
                                            ProgressView()
                                        }
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .aspectRatio(2 / 3, contentMode: .fit)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .onTapGesture {
                                navigationPath.append(title)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .navigationTitle(
                searchByMovies ? Constants.MovieSearchString : Constants.TVSearchString
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        searchByMovies.toggle()
                        Task {
                            await searchViewModel.getSearchTitles(
                                by: searchByMovies ? "movie" : "tv",
                                for: searchText
                            )
                        }
                    } label: {
                        Image(
                            systemName: searchByMovies
                                ? Constants.movieIcongString
                                : Constants.tvIcongString
                        )
                    }
                }
            }
            .searchable(
                text: $searchText,
                prompt: searchByMovies
                    ? Constants.moviePlaceholderString
                    : Constants.tvPlaceholderString
            )
            .task(id: searchText) {
                try? await Task.sleep(for: .milliseconds(500))
                if Task.isCancelled { return }

                await searchViewModel.getSearchTitles(
                    by: searchByMovies ? "movie" : "tv",
                    for: searchText
                )
            }
            .navigationDestination(for: Title.self) { title in
                TitleDetailView(title: title) 
            }
        }
    }
}

#Preview {
    SearchView()
}
