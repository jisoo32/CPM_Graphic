//
//  CPM_Graphic.swift
//  CPM_Graphic
//
//  Created by 김형관 on 4/2/24.
//
// 2024 4월 21일



import SwiftUI

@main
struct CPM_Graphic: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Activity.self)
    }
}
