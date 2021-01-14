//
// Created by Marco on 1/14/21.
// Copyright (c) 2021 Breinify. All rights reserved.
//

import Foundation
import CommonCrypto

open class BreinCrypto {

    public enum Algorithm {
        /// Message Digest 5
        case md5,
            /// Secure Hash Algorithm 1
             sha1,
            /// Secure Hash Algorithm 2 224-bit
             sha224,
            /// Secure Hash Algorithm 2 256-bit
             sha256,
            /// Secure Hash Algorithm 2 384-bit
             sha384,
            /// Secure Hash Algorithm 2 512-bit
             sha512

        static let fromNative: [CCHmacAlgorithm: Algorithm] = [
            CCHmacAlgorithm(kCCHmacAlgSHA1): .sha1,
            CCHmacAlgorithm(kCCHmacAlgSHA1): .md5,
            CCHmacAlgorithm(kCCHmacAlgSHA256): .sha256,
            CCHmacAlgorithm(kCCHmacAlgSHA384): .sha384,
            CCHmacAlgorithm(kCCHmacAlgSHA512): .sha512,
            CCHmacAlgorithm(kCCHmacAlgSHA224): .sha224]

        func nativeValue() -> CCHmacAlgorithm {
            switch self {
            case .sha1:
                return CCHmacAlgorithm(kCCHmacAlgSHA1)
            case .md5:
                return CCHmacAlgorithm(kCCHmacAlgMD5)
            case .sha224:
                return CCHmacAlgorithm(kCCHmacAlgSHA224)
            case .sha256:
                return CCHmacAlgorithm(kCCHmacAlgSHA256)
            case .sha384:
                return CCHmacAlgorithm(kCCHmacAlgSHA384)
            case .sha512:
                return CCHmacAlgorithm(kCCHmacAlgSHA512)
            }
        }

        static func fromNativeValue(nativeAlg: CCHmacAlgorithm) -> Algorithm? {
            fromNative[nativeAlg]
        }
        
        public func digestLength() -> Int {
            switch self {
            case .sha1:
                return Int(CC_SHA1_DIGEST_LENGTH)
            case .md5:
                return Int(CC_MD5_DIGEST_LENGTH)
            case .sha224:
                return Int(CC_SHA224_DIGEST_LENGTH)
            case .sha256:
                return Int(CC_SHA256_DIGEST_LENGTH)
            case .sha384:
                return Int(CC_SHA384_DIGEST_LENGTH)
            case .sha512:
                return Int(CC_SHA512_DIGEST_LENGTH)
            }
        }
    }

    typealias Context = UnsafeMutablePointer<CCHmacContext>

    let context = Context.allocate(capacity: 1)
    var algorithm: Algorithm

    public init(algorithm: Algorithm, key: String) {
        self.algorithm = algorithm
        CCHmacInit(context, algorithm.nativeValue(), key, size_t(key.lengthOfBytes(using: String.Encoding.utf8)))
    }

    open func update(buffer: UnsafeRawPointer, byteCount: size_t) -> Self? {
        CCHmacUpdate(context, buffer, byteCount)
        return self
    }

    open func final() -> [UInt8] {
        var hmac = Array<UInt8>(repeating: 0, count: algorithm.digestLength())
        CCHmacFinal(context, &hmac)
        return hmac
    }

    deinit {
        context.deallocate()
    }

}