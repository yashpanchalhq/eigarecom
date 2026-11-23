//
//  Constants.swift
//  eigarecom
//
//  Created by Yash on 22/11/26.
//

import Foundation
import SwiftUI

struct Constants {
    static let homeString = "Home"
    static let upcomingString = "Upcoming"
    static let searchString = "Search"
    static let downloadString = "Download"
    static let playString = "Play"
    static let trendingMovieString = "Trending Movies"
    static let trendingTVString = "Trending TV Shows"
    static let topRatedMovieString = "Top Rated Movies"
    static let topRatedTVString = "Top TV Rated TV Show"
    static let MovieSearchString = "Movie Search"
    static let TVSearchString = "TV Show Search"
    static let moviePlaceholderString = "Search for a Movie"
    static let tvPlaceholderString = "Search for a TV Show"
    
    static let homeIconString = "house"
    static let upcomingIconString = "play"
    static let searchIconString = "magnifyingglass"
    static let downloadIconString = "arrow.down.to.line"
    static let movieIcongString = "movieclapper"
    static let tvIcongString = "tv"
    
    static let testTitleURL = "https://image.tmdb.org/t/p/original/1zqWkLwC1zLBBBtIWzmkmWeMWnT.jpg"
    static let testTitleURL2 = "https://image.tmdb.org/t/p/original/wuUe5BjmS0nJnw1n6pBbTtYFXCZ.jpg"
    static let testTitleURL3 = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTt1VRuvcJKPrDbwXeZxV-m9o8njrZBJ-XJcgtHQMEXc3PyWc9ygJtqPeA&s=10"
    
    static let posterURLStart = "https://image.tmdb.org/t/p/original"
    
    static func addPosterPath(to titles: inout[Title]) {
        for index in titles.indices {
            if let path = titles[index].posterPath {
                titles[index].posterPath = Constants.posterURLStart + path
            }
        }
    }
}

enum YoutubeURLStrings: String {
    case trailer = "trailer"
    case queryShorten = "q"
    case space = " "
    case key = "key"
}

extension Text{
    func ghostButton() -> some View{
        self
            .frame(width: 100, height: 50)
            .foregroundStyle(.buttonText)
            .bold()
            .background {
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
                .stroke(.buttonBorder,lineWidth: 1)
            }
    }
}
extension View {
    func primaryActionButton() -> some View {
        self
            .font(.headline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .foregroundStyle(.black)
            .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    func secondaryActionButton() -> some View {
        self
            .font(.headline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .foregroundStyle(.primary)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.primary.opacity(0.14), lineWidth: 0.75)
            }
    }
}
