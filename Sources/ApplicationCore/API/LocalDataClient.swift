//
//  Copyright © 2021 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public protocol LocalDataClient {
    func load(fileName: String) throws -> Data
}
