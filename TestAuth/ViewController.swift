//
//  ViewController.swift
//  TestAuth
//
//  Created by и on 18.04.2020.
//  Copyright © 2020 badyi. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController {
    private var authPresenter: AuthPresenter!
    private var credentials: Credentials = Credentials()
    var flag = false {
        didSet {
            authPresenter.getPAGES()
        }
    }
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        authPresenter = AuthPresenter(view: self)
    }
    
    
    func auth() {
        
        authPresenter.setCred(credentials)
        
        guard let url = authPresenter.requestToGetCode() else {
            return
        }
        setupViews()
        let request = URLRequest(url: url)
        webView.load(request)
        webView.navigationDelegate = self
    }

    @IBAction func login(_ sender: Any) {
        auth()
    }
}

extension ViewController: AuthPresenterViewDelegate {
    func pages(pages: [String : String]) {
        let pageMenu = UIAlertController(title: nil, message: "PAges", preferredStyle: .alert)
        for i in pages {
            pageMenu.addAction(UIAlertAction(title: i.value, style: .default, handler: nil))
        }
        pageMenu.addAction(UIAlertAction(title: "done", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(pageMenu, animated: true, completion: nil)
        }
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated {
            let alert = UIAlertController(title: "Error", message: "Smth went wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            decisionHandler(WKNavigationActionPolicy.cancel)
        } else {
            if let url = navigationAction.request.url {
                print(url);
                
                guard let host = url.host else {
                    return
                }
                
                if host == "badyi.github.io" {
                    authPresenter.setShortLivedToken(url: url) {
                        self.authPresenter.setLongLivedToken() {
                            if self.credentials.longAccessToken != nil {
                               self.flag = true
                                
                                //self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
}
