//
//  ContentView.swift
//  PokeStag
//
//  Created by Laurent Jeanjean on 04/07/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var pokemons: [Pokemon] = []
    @State private var isLoading = false
    
    var body: some View {
        List(pokemons, id: \.name) { pokemon in
            Text(pokemon.name)
        }
        .task {
            do {
                let response = try await PokemonRepository().fetchPokemons()
                pokemons = response.results
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
