//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Vera Dias on 05/07/2024.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func load() {
        client.get(from: URL(string: "https://www.any.com")!)
    }
}
protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?

    func get(from url: URL) {
        requestedURL = url
    }
}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client)

        XCTAssertEqual(client.requestedURL, nil)
    }

    func test_load_requestsDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }
}
