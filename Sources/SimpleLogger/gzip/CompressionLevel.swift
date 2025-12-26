//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import zlib

/// A type-safe wrapper around zlib compression level constants.
///
/// `CompressionLevel` represents the level of compression to apply when performing zlib-based
/// compression operations. It wraps zlib’s integer constants in a Swift-friendly, `Sendable` type
/// to improve clarity, safety, and concurrency compatibility.
internal struct CompressionLevel: RawRepresentable, Sendable {

    /// The underlying zlib compression level value.
    ///
    /// This value corresponds directly to one of the `Z_*` compression constants defined by zlib.
    internal let rawValue: Int32

    /// Disables compression entirely.
    ///
    /// This uses `Z_NO_COMPRESSION` and is useful when compression overhead is undesirable or
    /// when data is already compressed.
    internal static let noCompression = Self(Z_NO_COMPRESSION)

    /// Optimises for fastest compression speed.
    ///
    /// This uses `Z_BEST_SPEED` and is suitable when performance is more important than
    /// compression ratio.
    internal static let bestSpeed = Self(Z_BEST_SPEED)

    /// Optimises for maximum compression ratio.
    ///
    /// This uses `Z_BEST_COMPRESSION` and is suitable when minimising output size is more
    /// important than performance.
    internal static let bestCompression = Self(Z_BEST_COMPRESSION)

    /// Uses zlib’s default compression behaviour.
    ///
    /// This uses `Z_DEFAULT_COMPRESSION`, which balances speed and compression ratio.
    internal static let defaultCompression = Self(Z_DEFAULT_COMPRESSION)

    /// Creates a compression level from a raw zlib value.
    ///
    /// - Parameter rawValue: A zlib compression constant.
    internal init(rawValue: Int32) {
        self.rawValue = rawValue
    }

    /// Creates a compression level from a raw zlib value.
    ///
    /// This initializer exists for convenience when passing zlib constants directly.
    ///
    /// - Parameter rawValue: A zlib compression constant.
    internal init(_ rawValue: Int32) {
        self.rawValue = rawValue
    }
}
