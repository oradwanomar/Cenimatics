//
//  MovieDetailsViewModel.swift
//  Cenimatics
//
//  Created by Omar Radwan on 13/08/2023.
//

import Foundation
import Combine

class MovieDetailsViewModel: ObservableObject {
    
    let movie: Movie
//    private var cancellable = Set<AnyCancellable>()
    @Published var data: (credits: [MovieCastMember], reviews: [MovieReview]) = ([], [])
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func fetchData() {
        let creditsPublisher = fetchCredits(for: movie).map(\.cast).replaceError(with: [])
        let reviewsPublisher = fetchReviews(for: movie).map(\.results).replaceError(with: [])
        
        Publishers.Zip(creditsPublisher, reviewsPublisher)
            .receive(on: DispatchQueue.main)
            .map { (credits: $0.0, reviews: $0.1) }
            .assign(to: &$data)
//            .sink { [weak self] data in
//                self?.data = data
//            }
//            .store(in: &cancellables)
    }
}
