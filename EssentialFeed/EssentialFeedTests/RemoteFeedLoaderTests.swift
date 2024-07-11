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

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://www.any.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load{_ in}

        XCTAssertEqual(client.requestedURLs.count, 1)
    }

    func test_loadsTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://www.any.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load{_ in}
        sut.load{_ in}

        XCTAssertEqual(client.requestedURLs.count, 2)
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "test", code: 0)

        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }

        XCTAssertEqual(capturedErrors, [.connectivity])
    }

    private func makeSUT(
        url: URL = URL(string: "https://www.any.com")!
    ) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFeedLoader(url: url, client: client), client: client)
    }

    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var error: Error?
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            if let error = error {
                completion(error)
            }
            requestedURLs.append(url)
        }
    }
}
