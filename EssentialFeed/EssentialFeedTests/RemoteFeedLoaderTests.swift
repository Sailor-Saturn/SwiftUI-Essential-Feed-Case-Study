//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Vera Dias on 05/07/2024.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertEqual(client.requestedURL, nil)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://www.any.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestedURL, url)
    }

    private func makeSUT(
        url: URL = URL(string: "https://www.any.com")!
    ) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFeedLoader(url: url, client: client), client: client)
    }

    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?

        func get(from url: URL) {
            requestedURL = url
        }
    }
}
