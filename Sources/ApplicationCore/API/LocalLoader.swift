//
//  Copyright © 2021 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public final class LocalLoader<Resource> {
    private let client: LocalDataClient
    private let fileName: String
    private let mapper: Mapper

    public typealias Mapper = (Data) throws -> Resource

    public init(client: LocalDataClient, fileName: String, mapper: @escaping Mapper) {
        self.client = client
        self.fileName = fileName
        self.mapper = mapper
    }

    public enum Error: Swift.Error, Equatable {
        case decodingError
        case invalidData
    }

    public func load() throws -> Resource {
        do {
            let data = try client.load(fileName: fileName)
            return try mapper(data)
        } catch {
            throw Error.decodingError
        }
    }
}
