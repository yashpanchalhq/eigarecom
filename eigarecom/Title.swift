import Foundation

struct APIObject: Decodable {
    var results: [Title] = []
}


struct Title: Decodable, Identifiable, Hashable {
    var id: Int?
    var title: String?
    var name: String?
    var overview: String?
    var posterPath: String?
    
    static var previewTitles = [
            Title(id: 1, title: "Avengers DoomsDay", name: "Avengers DoomsDay", overview: "When Victor von Doom unleashes a multiversal crisis, Earth's Mightiest Heroes, the Fantastic Four, and the X-Men must unite across realities to prevent total collapse.", posterPath: Constants.testTitleURL),
            Title(id: 2, title: "Pulp Fiction", name: "Pulp Fiction", overview: "A movie about Pulp Fiction", posterPath: Constants.testTitleURL2),
            Title(id: 3, title: "The Dark Knight", name: "The Dark Knight", overview: "A movie about the Dark Knight", posterPath: Constants.testTitleURL3)
        ]
}
