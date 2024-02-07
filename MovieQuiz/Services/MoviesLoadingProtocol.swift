//
//  MoviesLoaderProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Жуков on 2/7/24.
//

import Foundation


protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping(Result <MostPopularMovies, Error>) -> Void)
}
