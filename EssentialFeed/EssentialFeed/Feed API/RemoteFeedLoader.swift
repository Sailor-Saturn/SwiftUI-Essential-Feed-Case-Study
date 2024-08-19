import Foundation

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
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result{
                case let .success((data, response)):
                    completion(FeedItemsMapper.map(data, from: response))
                case .failure:
                    completion(.failure(.connectivity))
            }
        }
    }
}

