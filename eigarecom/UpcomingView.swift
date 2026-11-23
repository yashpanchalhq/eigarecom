//
//  UpcomingView.swift
//  eigarecom
//
//  Created by Yash on 23/11/26.
//

import SwiftUI

struct UpcomingView: View {
    let viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader
            { geo in
                switch viewModel.upcomingStatus {
                case .notStarted:
                    EmptyView()
                case .fetching:
                    ProgressView()
                        .frame(width: geo.size.width, height: geo.size.height)
                case .success:
                    VerticalListView(
                        titles: viewModel.upcomingMovies,
                        canDelete: true
                    )
                case .failure(let underlyingError):
                    Text(underlyingError.localizedDescription)
                }
            }}
        .task {
            await viewModel.getUpcomingMovies()
        }
    }
}
#Preview {
    UpcomingView()
}
