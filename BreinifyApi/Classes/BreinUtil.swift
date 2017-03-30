//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation
import IDZSwiftCommonCrypto


public class BreinUtil {

    /**
       generate the signature

       - parameter: message contains the message that needs to be encrypted
       - parameter: secret contains the secret

       - returns: encrypted message based on HMac256 algorithmn
    */
    static public func generateSignature(_ message: String!, secret: String!) throws -> String {

        if message == nil || secret == nil {
            throw BreinError.BreinRuntimeError("Illegal value for message or secret in method generateSignature")
        }
       return message.digestHMac256(secret)
    }

    // should check if an url is valid
    // for the time being we assume that this is the case
    static public func isUrlValid(_ url: String!) -> Bool {
        return true;
    }


    /*
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return addresses
    }
    */
    
    
    
    /*
    
    public func interfaceAddress(forInterfaceWithName interfaceName: String) throws -> sockaddr_in {
        
        guard let cString = interfaceName.cString(using: String.Encoding.ascii) else {
            throw "Error"
        }
        
        let addressPtr = UnsafeMutablePointer<sockaddr>.allocate(capacity: 1)
        let ioctl_res = _interfaceAddressForName(strdup(cString), addressPtr)
        let address = addressPtr.move()
        addressPtr.deallocate(capacity: 1)
        
        if ioctl_res < 0 {
            throw "Failed"
        } else {
            return unsafeBitCast(address, to: sockaddr_in.self)
        }
    }

 */
}
