//
//  Netwroking.swift
//  Cenimatics
//
//  Created by Omar Radwan on 29/07/2023.
//

import Foundation
import Combine


func fetchMovies() -> some Publisher<MovieResponse,Error> {
    let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)")!
    return URLSession
        .shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: MovieResponse.self, decoder: jsonDecoder)
}

func searchMovies(for query: String) -> some Publisher<MovieResponse,Error> {
    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(encodedQuery!)")!
    
    return URLSession
        .shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: MovieResponse.self, decoder: jsonDecoder)
}
