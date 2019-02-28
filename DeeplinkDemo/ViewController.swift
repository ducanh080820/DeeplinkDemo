//
//  ViewController.swift
//  DeeplinkDemo
//
//  Created by Duc Anh on 2/28/19.
//  Copyright © 2019 Duc Anh. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    let client_id = "511b620e9dd88d2483fc"
    let clientSecret = "a6cf32be2b388d834494fd792ef46ff810e76738"
    let redirect_uri = "deeplinkdemo://callback"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // login/oauth/authorize
    }
    
    @IBAction func login(_ sender: Any) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "github.com"
        urlComponents.path = "/login/oauth/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: client_id),
            URLQueryItem(name: "scope", value: "user gist"),
            URLQueryItem(name: "redirect_uri", value: redirect_uri),
        ]
        guard let url = urlComponents.url else { return }
        UIApplication.shared.open(url)
    }
    
    


}

// MARK: - <#Mark#>

extension URL {
    subscript(queryParam: String) -> String? {
        guard let urlComponents = URLComponents(string: self.absoluteString) else {return nil}
        return urlComponents.queryItems?.first(where: {$0.name == queryParam})?.value
    }
}
