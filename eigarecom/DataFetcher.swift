import Foundation

struct DataFetcher {
    let tmdbBaseURL = APIConfig.shared?.tmdbBaseURL
    let tmdbAPIKey = APIConfig.shared?.tmdbAPIKey
    let youtubeSearchURL = APIConfig.shared?.youtubeSearchURL
    let youtubeAPIKey = APIConfig.shared?.youtubeAPIKey
    
    func fetchTitles(for media: String, by type: String, with title:String? = nil) async throws -> [Title] {
        let fetchTitlesURL = try buildURL(
            media: media,
            type: type,
            searchPhrase: title
        )
        
        guard let fetchTitlesURL = fetchTitlesURL else {
            throw NetworkError.URLBuildFailed
        }
        print(fetchTitlesURL)
        var titles = try await fetchAndDecode(url: fetchTitlesURL, type: TMDBAPIObject.self).results
        Constants.addPosterPath(to: &titles)
        return titles
    }
    
    func fetchVideoID(for title: String) async throws -> String {
        guard let baseSearchURL = youtubeSearchURL else {
            throw NetworkError.missingConfiguration
        }
        
        guard let searchAPIKey = youtubeAPIKey else {
            throw NetworkError.missingConfiguration
        }
        
        let trailerSearch = title + YoutubeURLStrings.space.rawValue + YoutubeURLStrings.trailer.rawValue
        
        guard let fetchVideoURL = URL(string: baseSearchURL)?.appending(queryItems: [
            URLQueryItem(name: YoutubeURLStrings.queryShorten.rawValue, value: trailerSearch),
            URLQueryItem(name: YoutubeURLStrings.key.rawValue, value: searchAPIKey),
            URLQueryItem(name: "part", value: "snippet"),
                URLQueryItem(name: "type", value: "video"),
                URLQueryItem(name: "q", value: trailerSearch),
                URLQueryItem(name: "key", value: searchAPIKey)
        ]) else {
            throw NetworkError.URLBuildFailed
        }
        print("YouTube Search URL:", fetchVideoURL.absoluteString)
        let response = try await fetchAndDecode(
                url: fetchVideoURL,
                type: YoutubeSearchResponse.self
            )

            guard let videoID = response.items?.first?.id?.videoId,
                  !videoID.isEmpty else {
                throw NetworkError.URLBuildFailed
            }
            return videoID
    }
    
    private func fetchAndDecode<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError
                .badURLResponse(
                    underlyingError: NSError(
                        domain: "DataFetcher",
                        code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
                        userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"]))
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
    
    private func buildURL(media: String, type: String, searchPhrase:String? = nil) throws -> URL? {
        guard let baseURL = tmdbBaseURL else {
            throw NetworkError.missingConfiguration
        }
        guard let apiKey = tmdbAPIKey else {
            throw NetworkError.missingConfiguration
        }
        
        var path: String
        
        if type == "trending" {
            path = "3/\(type)/\(media)/day"
        } else if type == "top_rated" || type == "upcoming" {
            path = "3/\(media)/\(type)"
        }else if type == "search" {
            path = "3/\(type)/\(media)"
        }else {
            throw NetworkError.URLBuildFailed
        }
        
        var urlQueryItems = [
                    URLQueryItem(name: "api_key", value: apiKey)
                ]
                
                if let searchPhrase {
                    urlQueryItems.append(URLQueryItem(name: "query", value: searchPhrase))
                }
        
        guard let URL = URL(string: baseURL)?
            .appending(path: path)
            .appending(queryItems: urlQueryItems) else {
            throw NetworkError.URLBuildFailed
        }
        
        return URL
    }
}
