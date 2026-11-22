import SwiftUI

struct HomeView: View {
    let viewModel = ViewModel()
    @State private var titleDetailPath = NavigationPath()
    
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
                            
                            HStack{
                                Button{
                                    titleDetailPath.append(viewModel.herotitle)
                                }label: {
                                    Text(Constants.playString)
                                        .ghostButton()
                                }
                                
                                Button{
                                    
                                }label: {
                                    Text(Constants.downloadString)
                                        .ghostButton()
                                }
                            }
                            
                            HorizontalListView(
                                header: Constants.trendingMovieString,
                                titles: viewModel.trendingMovies
                            )
                            HorizontalListView(
                                header: Constants.trendingTVString,
                                titles: viewModel.trendingTV
                            )
                            HorizontalListView(
                                header: Constants.topRatedMovieString,
                                titles: viewModel.topRatedMovies
                            )
                            HorizontalListView(
                                header: Constants.topRatedTVString,
                                titles: viewModel.topRatedTV
                            )
                        }
                        .navigationDestination(for:Title.self) { title  in
                            TitleDetailView(title: title)
                        }
                    case .failure(let error):
                        Text(error.localizedDescription)
                    }
                }
                .ignoresSafeArea(edges: .top)
                .task {
                    await viewModel.getTitles()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
