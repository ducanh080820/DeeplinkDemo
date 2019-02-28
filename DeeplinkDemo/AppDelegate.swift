//
//  AppDelegate.swift
//  DeeplinkDemo
//
//  Created by Duc Anh on 2/28/19.
//  Copyright © 2019 Duc Anh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let client_id = "511b620e9dd88d2483fc"
    let clientSecret = "a6cf32be2b388d834494fd792ef46ff810e76738"
    let redirect_uri = "deeplinkdemo://callback"
    
    static var shared = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    var window: UIWindow?
    var accessCode: String?
    var accessToken: AccessToken?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        accessCode = url["code"]
         loginGithub()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func loginGithub() {
        guard let accessCode = AppDelegate.shared.accessCode else { return}
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "github.com"
        urlComponents.path = "/login/oauth/access_token"
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = makeDataRequest()
        
        let task = URLSession.shared.dataTask(with: request) { data , response , error in
            guard error == nil else {return}
            guard let data = data else {return}
            guard let httpResponse =  response as? HTTPURLResponse else {return}
            if httpResponse.statusCode == 200 {
//                let data = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Dictionary<String, Any>
//                print(data)
                self.accessToken = try? JSONDecoder().decode(AccessToken.self, from: data)
                print(self.accessToken?.access_token)
            }
        }
        task.resume()
    }
    
    func makeDataRequest() -> Data? {
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: client_id),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "code", value: AppDelegate.shared.accessCode!),
        ]
        
        let urlString = urlComponents.url?.absoluteString ?? ""
        let bodyurlString = urlString.dropFirst()
        return bodyurlString.data(using: .utf8)
    }

}

struct AccessToken: Codable {
    var access_token: String?
    var token_type: String?
}

