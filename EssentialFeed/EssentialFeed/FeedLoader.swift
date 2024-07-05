//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Vera Dias on 03/06/2024.
//

import Foundation

protocol FeedLoader {
	typealias Result = Swift.Result<[FeedItem], Error>
	func load(completion: @escaping (Result) -> Void)
}
