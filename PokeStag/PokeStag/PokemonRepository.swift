//
//  PokemonRepository.swift
//  PokeStag
//
//  Created by Laurent JEANJEAN on 04/07/2023.
//

import Foundation

struct Pokemon: Codable {
    let name: String
}

struct PokemonResponse: Codable {
    let results: [Pokemon]
}

struct PokemonDetails: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let abilities: [Ability]

    enum PokemonType: String, Codable {
        case normal = "normal"
        case fighting = "fighting"
        case flying = "flying"
        case poison = "poison"
        case ground = "ground"
        case rock = "rock"
        case bug = "bug"
        case ghost = "ghost"
        case steel = "steel"
        case fire = "fire"
        case water = "water"
        case grass = "grass"
        case electric = "electric"
        case psychic = "psychic"
        case ice = "ice"
        case dragon = "dragon"
        case dark = "dark"
        case fairy = "fairy"
        case unknown = "unknown"
        case shadow = "shadow"
    }
    
    struct Ability: Codable {
        let name: String
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
}

class PokemonRepository {
    func fetchPokemons() async throws -> PokemonResponse {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let pokemonResponse = try decoder.decode(PokemonResponse.self, from: data)
            return pokemonResponse
        } catch {
            throw APIError.invalidResponse
        }
    }
    
    func fetchPokemonDetail(urlPath: String) async throws -> PokemonDetails {
            let url = URL(string: urlPath)!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let pokemon = try decoder.decode(PokemonDetails.self, from: data)
                return pokemon
            } catch {
                throw APIError.invalidResponse
            }
        }
}
