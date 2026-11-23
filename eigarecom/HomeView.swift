import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = ViewModel()
    @State private var titleDetailPath = NavigationPath()
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack(path: $titleDetailPath) {
            GeometryReader{ geo in
                ScrollView(.vertical) {
                    switch viewModel.homeStatus {
                    case .notStarted:
                        EmptyView()
                    case .fetching:
                        ProgressView()
                            .frame(
                                width: geo.size.width,
                                height: geo.size.height
                            )
                    case .success:
                        LazyVStack{
                            AsyncImage(
                                url: URL(string: viewModel.herotitle.posterPath ?? "" )
                            ){ image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .overlay {
                                        LinearGradient(
                                            stops: [Gradient.Stop(color: .clear, location: 0.8),
                                                    Gradient
                                                .Stop(color: .gradients, location: 1)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    }
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: geo.size.width, height: geo.size.height * 0.85)
                            .clipped()
                            
                            HStack(spacing: 12){
                                Button{
                                    titleDetailPath.append(viewModel.herotitle)
                                }label: {
                                    Label(
                                        Constants.playString,
                                        systemImage: "play.fill"
                                    )
                                    .primaryActionButton()
                                }
                                
                                Button{
                                    modelContext.insert(viewModel.herotitle)
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        print("Failed to save title: \(error.localizedDescription)")
                                    }
                                }label: {
                                    Label(
                                        Constants.downloadString,
                                        systemImage: "arrow.down.to.line"
                                    )
                                    .secondaryActionButton()
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 16 )
                            
                            HorizontalListView(
                                header: Constants.trendingMovieString,
                                titles: viewModel.trendingMovies
                            ){ title in
                                titleDetailPath.append(title)
                            }
                            HorizontalListView(
                                header: Constants.trendingTVString,
                                titles: viewModel.trendingTV
                            ){ title in
                                titleDetailPath.append(title)
                            }
                            HorizontalListView(
                                header: Constants.topRatedMovieString,
                                titles: viewModel.topRatedMovies
                            ){ title in
                                titleDetailPath.append(title)
                            }
                            HorizontalListView(
                                header: Constants.topRatedTVString,
                                titles: viewModel.topRatedTV
                            ){ title in
                                titleDetailPath.append(title)
                            }
                        }
                    case .failure(let error):
                        Text(error.localizedDescription)
                    }
                }
                .ignoresSafeArea(edges: .top)
                .task {
                    await viewModel.getTitles()
                }
                .navigationDestination(for:Title.self) { title  in
                    TitleDetailView(title: title)
                }
            }
        }
    }
}
#Preview {
    HomeView()
}
