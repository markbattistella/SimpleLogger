//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import zlib

extension Data {
    
    /// Appends a string to the data using the specified string encoding.
    ///
    /// If the string cannot be converted to data using the provided encoding, this method does
    /// nothing.
    ///
    /// - Parameters:
    ///   - string: The string to append.
    ///   - encoding: The string encoding to use when converting the string to data. Defaults
    ///   to UTF-8.
    internal mutating func append(_ string: String, encoding: String.Encoding = .utf8) {
        guard let data = string.data(using: encoding) else { return }
        append(data)
    }
    
    /// Returns a gzip-compressed copy of the data.
    ///
    /// This method uses zlib to compress the receiver into the gzip format. If the data is empty,
    /// an empty `Data` value is returned.
    ///
    /// - Parameters:
    ///   - level: The compression level to apply. Defaults to `.defaultCompression`.
    ///   - wBits: The window size parameter passed to zlib. The default value (`MAX_WBITS + 16`)
    ///   enables gzip header and trailer support.
    ///
    /// - Returns: A new `Data` instance containing the gzip-compressed bytes.
    ///
    /// - Throws: `GzipError` if compression fails at any stage.
    internal func gzipped(
        level: CompressionLevel = .defaultCompression,
        wBits: Int32 = MAX_WBITS + 16
    ) throws(GzipError) -> Data {
        guard !self.isEmpty else { return Data() }
        
        var stream = z_stream()
        var status: Int32 = deflateInit2_(
            &stream,
            level.rawValue,
            Z_DEFLATED,
            wBits,
            MAX_MEM_LEVEL,
            Z_DEFAULT_STRATEGY,
            ZLIB_VERSION,
            Int32(DataSize.stream)
        )
        
        guard status == Z_OK else {
            throw GzipError(code: status, msg: stream.msg)
        }
        
        var compressedData = Data(capacity: DataSize.chunk)
        
        repeat {
            if Int(stream.total_out) >= compressedData.count {
                compressedData.count += DataSize.chunk
            }
            
            let inputSize = self.count
            let outputSize = compressedData.count
            
            self.withUnsafeBytes { inputPointer in
                guard let baseInput = inputPointer
                    .bindMemory(to: Bytef.self)
                    .baseAddress else { return }
                
                stream.next_in = UnsafeMutablePointer(
                    mutating: baseInput.advanced(by: Int(stream.total_in))
                )
                stream.avail_in = uInt(inputSize) - uInt(stream.total_in)
                
                compressedData.withUnsafeMutableBytes { outputPointer in
                    guard let baseOutput = outputPointer
                        .bindMemory(to: Bytef.self)
                        .baseAddress else { return }
                    
                    stream.next_out = baseOutput.advanced(by: Int(stream.total_out))
                    stream.avail_out = uInt(outputSize) - uInt(stream.total_out)
                    
                    status = deflate(&stream, Z_FINISH)
                }
            }
        } while stream.avail_out == 0 && status != Z_STREAM_END
        
        guard deflateEnd(&stream) == Z_OK, status == Z_STREAM_END else {
            throw GzipError(code: status, msg: stream.msg)
        }
        
        compressedData.count = Int(stream.total_out)
        return compressedData
    }
}

/// Constants used to control internal buffer sizing during compression.
fileprivate enum DataSize {
    
    /// The size, in bytes, of each compression output chunk.
    ///
    /// This value is used to incrementally grow the output buffer while deflating data.
    static let chunk = 1 << 14
    
    /// The size, in bytes, of a `z_stream` structure.
    ///
    /// This is passed to `deflateInit2_` to ensure ABI compatibility with the linked version
    /// of zlib.
    static let stream = MemoryLayout<z_stream>.size
}
