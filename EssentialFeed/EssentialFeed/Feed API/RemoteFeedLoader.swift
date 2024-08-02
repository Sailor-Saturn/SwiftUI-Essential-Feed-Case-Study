import Foundation

public typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public typealias RemoteFeedLoaderResult = Result<([FeedItem]), RemoteFeedLoader.Error>
public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping(RemoteFeedLoaderResult) -> Void) {
        client.get(from: url) { result in
            switch result{
            case let .success(data, response):
                    if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
                        completion(.success(root.items))
                    } else {
                        completion(.failure(.invalidData))
                    }
            case .failure:
                    completion(.failure(.connectivity))
            }
        }
    }
}

private struct Root: Decodable {
    let items: [FeedItem]
}

