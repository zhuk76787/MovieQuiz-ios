//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Жуков on 2/13/24.
//

import Foundation


protocol NetworkRoutingProtocol{
    func fetch(url: URL, handler: @escaping (Result <Data, Error>)-> Void)
}
