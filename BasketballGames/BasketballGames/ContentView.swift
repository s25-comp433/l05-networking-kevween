//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Result: Codable {
    var id: Int
    var team: String
    var opponent: String
    var date: String
    var isHomeGame: Bool
    var score: Score
}

struct Score: Codable {
    var opponent: Int
    var unc: Int
}

struct Response: Codable {
    var results: [Result]
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.id) { game in
            VStack(alignment: .leading) {
                HStack {
                    Text("\(game.team == "Men" ? "Men's" : "Women's") vs. \(game.opponent)")
                        .font(.headline)
                    Spacer()
                    Text("\(game.score.unc) - \(game.score.opponent)")
                        .foregroundStyle(game.score.unc > game.score.opponent ? .green : .red)
                        .fontWeight(.semibold)
                }
                HStack {
                    Text(game.date)
                    Spacer()
                    Text(game.isHomeGame ? "Home" : "Away")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            .fontDesign(.rounded)
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                results = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
