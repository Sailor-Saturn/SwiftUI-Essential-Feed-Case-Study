//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Vera Dias on 03/06/2024.
//

import Foundation

public struct FeedItem: Equatable {
	let id: UUID
	let description: String?
	let location: String?
	let imageURL: URL
}
