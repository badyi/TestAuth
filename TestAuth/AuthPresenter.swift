//
//  AuthPresenter.swift
//  TestAuth
//
//  Created by и on 18.04.2020.
//  Copyright © 2020 badyi. All rights reserved.
//

import Foundation

protocol AuthPresenterViewDelegate: NSObjectProtocol {
    func setupViews()
    func pages(pages: [String: String])
}

protocol AuthPresenterProtocol {
    func setShortLivedToken(url: URL, completionBlock: @escaping () -> ())
    func setLongLivedToken(completionBlock: @escaping () -> ())
}

class AuthPresenter: AuthPresenterProtocol {
    
    private let authService: AuthService = AuthService()
    weak private var view: AuthPresenterViewDelegate!
    private var credentials: Credentials?
    
    init(view: AuthPresenterViewDelegate) {
        self.view = view
    }
    
    func setCred(_ credentials: Credentials?) {
        self.credentials = credentials
    }
    
    var pages : [String:String]? {
        didSet {
            view?.pages(pages: self.pages!)
        }
    }
    
    func getPAGES() {
        authService.getUserPages(credentials!) { result in
            switch result {
            case let .success(pages):
                self.pages = pages
            case let .failure(error):
                print (error)
            }
        }
    }
    
    func requestToGetCode() -> URL? {
        guard var urlComponents = URLComponents(string: "https://www.facebook.com/v6.0/dialog/oauth") else {
            return nil
        }
        //instagram_manage_insights,instagram_manage_comments,instagram_basic,business_management,
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: credentials?.clientId),
            URLQueryItem(name: "redirect_uri", value: self.credentials?.redirectUri),
            URLQueryItem(name: "scope", value: "manage_pages,email,instagram_manage_insights,instagram_manage_comments,instagram_basic,business_management"),
            URLQueryItem(name: "state", value: "1")
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        return url
        //return URLRequest(url: url)
    }
    
    func setShortLivedToken(url: URL, completionBlock: @escaping () -> ()) {
        guard var credentials = self.credentials else {
            return
        }
        authService.setShortLivedToken(&credentials, url) {
            completionBlock()
        }
    }
    
    func setLongLivedToken(completionBlock: @escaping () -> ()) {
        guard var credentials = credentials else {
            return
        }
        authService.setLongLivedToken(&credentials) {
            completionBlock()
        }
    }
}
