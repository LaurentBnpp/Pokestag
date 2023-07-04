//
//  ContentView.swift
//  PokeStag
//
//  Created by Laurent Jeanjean on 04/07/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pokemonAPI: PokemonAPI
    @State var error: Error?

    /// The current pagedObject returned from the paginated web service call.
    @State var pagedObject: PKMPagedObject<PKMPokemon>?
    @State var pageIndex = 0

    var body: some View {
        VStack {
            if let pagedObject = pagedObject,
               let pokemonResults = pagedObject.results as? [PKMNamedAPIResource] {
                List {
                    ForEach(pokemonResults, id: \.url) { pokemon in
                        Text(pokemon.name ?? "Unknown Pokemon")
                    }
                }
                .listStyle(.plain)
            }
        }
        .padding()
        .task {
            await fetchPokemon()
        }
    }

    // MARK: - Data
    func fetchPokemon(paginationState: PaginationState<PKMPokemon> = .initial(pageLimit: 20)) async {
        do {
            pagedObject = try await pokemonAPI.pokemonService.fetchPokemonList(paginationState: paginationState)
            pageIndex = pagedObject?.currentPage ?? 0
        }
        catch {
            self.error = error
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
