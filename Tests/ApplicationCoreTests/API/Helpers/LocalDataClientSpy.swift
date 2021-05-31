//
//  Copyright © 2021 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation
import ApplicationCore

class LocalDataClientSpy: LocalDataClient {
    var messages = [String]()
    private var result: Result<Data, Error>? = .failure(anyNSError())

    init() {}

    var requestedFiles: [String] { messages }

    func load(fileName: String) throws -> Data {
        messages.append(fileName)
        return try result!.get()
    }

    func complete(with data: Data, at _: Int = 0) {
        result = .success(data)
    }

    func complete(with error: Error, at _: Int = 0) {
        result = .failure(error)
    }
}
