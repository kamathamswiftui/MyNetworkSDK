// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

@available(iOS 13.0.0, *)
public struct User: Codable {
    public var id: Int
    public var name: String
    public var email: String
    
    public init(id: Int, name: String, email: String)  {
        self.id = id
        self.name = name
        self.email = email
    }
}

@available(iOS 13.0.0, *)
public protocol MyNetworkProtocol {
    func fetchUsers() async throws -> [User]
}

@available(iOS 13.0.0, *)
public class MyNetwork: MyNetworkProtocol {
    
    private let baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func fetchUsers() async throws -> [User] {
        
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let users : [User] = try JSONDecoder().decode([User].self, from: data)
        return users
        
    }
}
