/*
 * Copyright (c) 2015-2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

protocol Connectable {
    func makeConnection(resource: Resource, completion: Result<NSData, Error> -> Void)
}

final class Connection {
    private let session: NSURLSession
    private let baseURL: NSURL
    
    init(baseURL: NSURL, session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())) {
        self.baseURL = baseURL
        self.session = session
    }
}

extension Connection: Connectable {
    
    func makeConnection(resource: Resource, completion: Result<NSData, Error> -> Void) {
        
        let request = resource.toRequest(baseURL)
        
        session.dataTaskWithRequest(request) { (data, response, error) in
            switch (data, error) {
            case(let data?, _): completion(.Success(data))
            case(_, let error?): completion(.Failure(.Network(error.description)))
            default: break
            }
        }.resume()
    }
}
