//
//  Copyright © 2021 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ApplicationCore
import XCTest

final class BundleDataClientTests: XCTestCase {
    func test_load_deliversErrorOnInvalidBundle() {
        let sut = makeSUT(bundle: Bundle(for: BundleDataClient.self))

        expect(sut, toCompleteWith: .failure(anyNSError()))
    }

    func test_load_deliversDataOnLoadingFromBundle() {
        let sut = makeSUT()

        expect(sut, toCompleteWith: .success(anyData()))
    }

    // MARK: - Helpers

    private func makeSUT(
        bundle: Bundle = .module,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> BundleDataClient {
        let sut = BundleDataClient(bundle: bundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut)
    }

    private func expect(_ sut: BundleDataClient, toCompleteWith expectedResult: Result<Data, Error>) {
        let receivedResult = Result { try sut.load(fileName: "any") }
        switch (receivedResult, expectedResult) {
        case let (.success(receivedData), .success):
            XCTAssertNotNil(receivedData)
        case (.failure, .failure):
            break
        default:
            XCTFail("Expected success, but got \(receivedResult) instead")
        }
    }
}
