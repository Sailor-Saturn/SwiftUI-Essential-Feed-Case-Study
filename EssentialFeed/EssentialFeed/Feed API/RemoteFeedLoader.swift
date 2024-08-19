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
        client.get(from: url) { result in
            switch result{
                case let .success((data, response)):
                    do {
                        let items = try FeedItemsMapper.map(data, response)
                        completion(.success(items))
                    } catch {
                        completion(.failure(.invalidData))
                    }
                case .failure:
                    completion(.failure(.connectivity))
            }
        }
    }
}

