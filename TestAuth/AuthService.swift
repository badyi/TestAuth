//
//  AuthService.swift
//  TestAuth
//
//  Created by и on 18.04.2020.
//  Copyright © 2020 badyi. All rights reserved.
//

import Foundation
import ResourceNetworking
struct CategoryList: Codable {
    let id: String
    let name: String
}

struct Cursors: Codable {
    let before: String
    let after: String
}

struct Paging: Codable {
    let cursors: Cursors
}

fileprivate struct Data: Codable {
    let access_token: String
    let category: String
    let category_list: [CategoryList]
    let name: String
    let id: String
    let tasks: [String]
}

struct usersPagesResponse: Codable {
    fileprivate let data: [Data]
    let paging: Paging
}

fileprivate struct InstBusinessAccountResponse: Codable {
    let instagram_business_account: InstagramBusinessAccount
    let category: String?
    let link: String?
    let website: String?
    let id: String
}

fileprivate struct InstagramBusinessAccount: Codable {
    let id: String
}

fileprivate struct NameResponse: Codable {
    let name: String
    let id: String
}
class Credentials {
    let clientId = "710146879787686"
    let clientSecret = "ae002996e5c88b7de0c9281a57c338af"
    let redirectUri = "https://badyi.github.io/"
    var userId: UInt64? = nil
    var shortAccessToken: String?
    var longAccessToken: String?
    var token_type: String?
    var expires_in: UInt64?
}

struct LongLivedTokenResponse: Codable {
    let access_token: String
    let token_type: String
    let expires_in: UInt64?
}

struct ShortLivedTokenResponse: Codable {
    let access_token: String
     let token_type: String
     let expires_in: UInt64?
}

class FakeReachability: ReachabilityProtocol {
    var isReachable: Bool

    
    init(isReachable: Bool) {
        self.isReachable = isReachable
    }
}

class AuthService {
    let networkHelper = NetworkHelper(reachability: FakeReachability(isReachable: true))
    
    func createUserPagesResource(with credentials: Credentials) -> Resource<usersPagesResponse>? {
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/v6.0/me/accounts/") else {
            print("Wrong url. couldnt create user page resource")
            return nil
        }
        urlComponents.queryItems = [ URLQueryItem(name: "access_token", value: credentials.longAccessToken) ]
        guard let url = urlComponents.url else {
            print("Wrong url. couldnt create correct user page resource")
            return nil
        }
        return Resource(url: url, headers: nil)
    }
    
    func getUserPages(_ credentials: Credentials, completionBlock: @escaping(OperationCompletion<[String:String]>) -> ()) {
        guard let resource = createUserPagesResource(with: credentials) else {
            let error = Error.self
            completionBlock(.failure(error as! Error))
            return
        }
        _ = networkHelper.load(resource: resource) { result in
            switch result {
            case let .success(pages):
                let pagesResponse: usersPagesResponse = pages
                let pages: [String:String] = pagesResponse.data.reduce([String: String]()) { (dict, item) -> [String: String] in
                    var dict = dict
                    dict[item.id] = item.name
                    return dict
                }
                completionBlock(.success(pages))
            case let .failure(error):
                completionBlock(.failure(error))
            }
        }
    }
    func setShortLivedToken(_ credentials: inout Credentials, _ url: URL, completionBlock: @escaping() -> ()) {
        let urlString = url.absoluteString
        guard let components = URLComponents(string: urlString) else { return  }
        
        guard let code = components.queryItems?.first(where: {$0.name == "code"})?.value else { return }
        
        let requestHeaders: [String:String] = ["Authorization": credentials.clientSecret,
                                               "Content-Type": "application/x-www-form-urlencoded"]
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "client_id", value: credentials.clientId),
                                            URLQueryItem(name: "redirect_uri", value: credentials.redirectUri),
                                            URLQueryItem(name: "client_secret", value: credentials.clientSecret),
                                            URLQueryItem(name: "code", value: code)]
        
        var request = URLRequest(url: URL(string: "https://graph.facebook.com/v6.0/oauth/access_token")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { [weak credentials] (data, response, error) in
            if let response = response {
                print(response)
            }
            guard let data = data else {
                return
            }
            
            do {
                let jsonResponse = try JSONDecoder().decode(ShortLivedTokenResponse.self, from: data)
                guard let credentials = credentials else { return }
                credentials.shortAccessToken = jsonResponse.access_token
                //credentials.userId = jsonResponse.user_id
                completionBlock()
            } catch {
                print(error)
            }
        }).resume()
}
    
    func setLongLivedToken(_ credentials: inout Credentials, completionBlock: @escaping() -> ()) {
        guard let shortAccessToken = credentials.shortAccessToken else { return }
        
        guard var urlComponents = URLComponents(string: "https://graph.facebook.com/v6.0/oauth/access_token") else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "fb_exchange_token"),
            URLQueryItem(name: "client_id", value: credentials.clientId),
            URLQueryItem(name: "client_secret", value: credentials.clientSecret),
            URLQueryItem(name: "fb_exchange_token", value: shortAccessToken)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url){ [weak credentials] (data, response, error) in
            if error != nil {
                return
            }
            
            guard response != nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                guard let credentials = credentials else { return }
                let jsonResponse = try JSONDecoder().decode(LongLivedTokenResponse.self, from: data)
                credentials.longAccessToken = jsonResponse.access_token
                credentials.expires_in = jsonResponse.expires_in
                credentials.token_type = jsonResponse.token_type
                completionBlock()
            } catch {
                print(error)
            }
        }.resume()
    }
}
