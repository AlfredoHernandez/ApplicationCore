//
//  Copyright © 2021 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ApplicationCore
import XCTest

class LocalLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedFiles.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let fileName = "any"
        let (sut, client) = makeSUT(fileName: fileName)

        _ = try? sut.load()

        XCTAssertEqual(client.requestedFiles, [fileName])
    }

    func test_loadTwice_requestsLinesDataFromURLTwice() {
        let fileName = "any"
        let (sut, client) = makeSUT(fileName: fileName)

        _ = try? sut.load()
        _ = try? sut.load()

        XCTAssertEqual(client.requestedFiles, [fileName, fileName])
    }

    func test_load_deliversDecodingErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.decodingError), when: {
            client.complete(with: anyNSError())
        })
    }

    func test_deliversDecodingErrorOnMapperError() {
        let mappingError = anyNSError()
        let (sut, client) = makeSUT(mapper: { _ in
            throw mappingError
        })

        expect(sut, toCompleteWith: failure(.decodingError), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(with: invalidJSON)
        })
    }

    func test_load_deliversMappedResource() {
        let resource = "a resource"
        let (sut, client) = makeSUT(mapper: { data in
            String(data: data, encoding: .utf8)!
        })

        expect(sut, toCompleteWith: .success(resource), when: {
            let data = Data(resource.utf8)
            client.complete(with: data)
        })
    }

    // MARK: - Helpers

    private func makeSUT(
        fileName: String = "any-filename",
        mapper: @escaping LocalLoader<String>.Mapper = { _ in "any" },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocalLoader<String>, client: LocalDataClientSpy) {
        let client = LocalDataClientSpy()
        let sut = LocalLoader<String>(client: client, fileName: fileName, mapper: mapper)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }

    private func failure(_ error: LocalLoader<String>.Error) -> Result<String, Error> {
        .failure(error)
    }

    private func expect(
        _ sut: LocalLoader<String>,
        toCompleteWith expectedResult: Result<String, Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()

        let receivedResult = Result<String, Error> { try sut.load() }

        switch (receivedResult, expectedResult) {
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        case let (.success(receivedItems), .success(expectedItems)):
            XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
        default:
            XCTFail("Expected \(expectedResult), but got \(receivedResult) instead.", file: file, line: line)
        }
    }
}
