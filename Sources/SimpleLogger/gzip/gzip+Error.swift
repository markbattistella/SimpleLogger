//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import zlib

/// An error type representing failures that occur during gzip operations.
internal struct GzipError: Error {

    /// A classification of gzip-related error conditions.
    ///
    /// This enum maps zlib error codes to strongly typed Swift cases, allowing callers to reason
    /// about failure causes without relying on raw integer values.
    internal enum Kind: Equatable {

        /// An invalid or inconsistent compression stream state.
        case stream

        /// Corrupted or invalid input data.
        case data

        /// Insufficient memory to complete the operation.
        case memory

        /// An output buffer error.
        case buffer

        /// A zlib version mismatch.
        case version

        /// An unrecognised zlib error code.
        ///
        /// - Parameter code: The raw zlib error code.
        case unknown(code: Int)

        /// Creates an error kind from a zlib error code.
        ///
        /// - Parameter code: A zlib error code returned by a compression or decompression
        /// function.
        init(code: Int32) {
            switch code {
                case Z_STREAM_ERROR:
                    self = .stream
                case Z_DATA_ERROR:
                    self = .data
                case Z_MEM_ERROR:
                    self = .memory
                case Z_BUF_ERROR:
                    self = .buffer
                case Z_VERSION_ERROR:
                    self = .version
                default:
                    self = .unknown(code: Int(code))
            }
        }
    }

    /// The categorised kind of gzip error.
    internal let kind: Kind

    /// A human-readable description of the error.
    ///
    /// This value is derived from zlib's error message when available.
    internal let message: String

    /// Creates a gzip error from a zlib error code and message.
    ///
    /// - Parameters:
    ///   - code: The zlib error code.
    ///   - msg: An optional C string describing the error.
    internal init(code: Int32, msg: UnsafePointer<CChar>?) {
        self.message = msg.flatMap(String.init(validatingCString:)) ?? "Unknown gzip error"
        self.kind = Kind(code: code)
    }

    /// A localized description of the error.
    ///
    /// This returns the underlying zlib error message.
    internal var localizedDescription: String {
        return self.message
    }
}
