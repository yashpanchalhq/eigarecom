//
//  eigarecomApp.swift
//  eigarecom
//
//  Created by Yash on 22/11/26.
//

import SwiftUI
import SwiftData

@main
struct eigarecomApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for:Title.self)
    }
}
