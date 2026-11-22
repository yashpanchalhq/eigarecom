//
//  TitleDetailView.swift
//  eigarecom
//
//  Created by Yash on 22/11/26.
//

import SwiftUI

struct TitleDetailView: View {
    let title: Title
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(alignment: .leading) {
                    AsyncImage(
                        url: URL(string: title.posterPath ?? "")
                    ) { image in image
                            .resizable()
                            .scaledToFill()
                    
                    }placeholder: {
                        ProgressView()
                    }
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 0.85
                    )
                    Text((title.name ?? title.title) ?? "")
                        .font(.title )
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Text((title.overview ?? ""))
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .lineLimit(nil)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}

#Preview {
    TitleDetailView(title: Title.previewTitles[0])
}
