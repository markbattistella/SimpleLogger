//
// Project: 
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import UniformTypeIdentifiers

internal final class LogFileDocument: FileDocument {

    static let readableContentTypes: [UTType] = [.log]

    public let file: URL

    init(file: URL) {
        self.file = file
    }

    required init(configuration: ReadConfiguration) throws {
        fatalError("Initialization from configuration not implemented.")
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return try FileWrapper(url: self.file)
    }
}
