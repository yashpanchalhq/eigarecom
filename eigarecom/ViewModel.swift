import Foundation

@Observable
class ViewModel {
    enum fetchStatus {
        case notStarted
        case fetching
        case success
        case failure(underlyingError : Error)
    }
    
    private(set) var homeStatus: fetchStatus = .notStarted
    private let dataFetcher = DataFetcher()
    
    var trendingMovies: [Title] = []
    var trendingTV: [Title] = []
    var topRatedMovies: [Title] = []
    var topRatedTV: [Title] = []
    var herotitle = Title.previewTitles[0]
    
    func getTitles() async {
        homeStatus = .fetching
        if trendingMovies.isEmpty{
            
            do{
                async let tMovies =  dataFetcher
                    .fetchTitles(for: "movie", by: "trending")
                async let tTVShows = dataFetcher
                    .fetchTitles(for: "tv", by: "trending")
                async let top_ratedMovie = dataFetcher
                    .fetchTitles(for: "movie", by: "top_rated")
                async let top_ratedTV = dataFetcher
                    .fetchTitles(for: "tv", by: "top_rated")
                
                trendingMovies = try await tMovies
                trendingTV = try await tTVShows
                topRatedMovies = try await top_ratedMovie
                topRatedTV = try await top_ratedTV
                
                if let title = trendingMovies.randomElement() {
                    herotitle = title 
                }
                homeStatus = .fetching
            }catch{
                print(error)
                homeStatus = .failure(underlyingError: error)
            }
        }else{
            homeStatus = .success
        }
    }
    
}
