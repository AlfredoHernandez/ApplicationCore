//
//  Copyright © 2021 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public class BundleDataClient: LocalDataClient {
    private let bundle: Bundle

    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    public enum Error: Swift.Error {
        case invalidPath
    }

    public func load(fileName: String) throws -> Data {
        if let path = bundle.url(forResource: fileName, withExtension: "json") {
            return try Data(contentsOf: path)
        }
        throw Error.invalidPath
    }
}
