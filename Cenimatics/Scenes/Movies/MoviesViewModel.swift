//
//  MoviesViewModel.swift
//  Cenimatics
//
//  Created by Omar Radwan on 29/07/2023.
//

import Foundation
import Combine

final class MoviesViewModel: ObservableObject {
    @Published var upcomingMovies: [Movie] = []
    @Published var searchQuery: String = ""
    @Published var searchResults: [Movie] = []
    
    var movies: [Movie] {
        return searchResults.isEmpty ? upcomingMovies : searchResults
    }
    
    var anyCancellable = Set<AnyCancellable>()
    
    
    init() {
        $searchQuery
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
        /// flatMap is a way to lose dimension
        /// Here, the publisher of publisher with flatMap will return a one Publisher
//            .flatMap { query in
//                searchMovies(for: query)
//                    .replaceError(with: MovieResponse(results: []))
//            }
            .map { query in
                searchMovies(for: query)
                    .replaceError(with: MovieResponse(results: []))
            }
        /// Spilt the two publishers and take the last one
            .switchToLatest()
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchResults)
    }
    
    func loadMovies() {
        fetchMovies()
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: &$upcomingMovies)
//            .assign(to: \.movies, on: self)
//            .sink { complition in
//                switch complition {
//                case .finished: ()
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] movies in
//                self?.movies = movies
//            }
//            .store(in: &anyCancellable)

    }
}
