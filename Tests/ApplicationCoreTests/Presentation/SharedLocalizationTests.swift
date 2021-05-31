//
//  Copyright © 2021 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ApplicationCore
import XCTest

final class SharedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle.module
        assertLocalizedKeysAndValuesExists(in: bundle, table)
    }

    // MARK: - Helpers

    private class DummyView: ResourceView {
        func display(_: Any) {}
    }
}
