//
//  GitHubAPIManager.swift
//  Giit
//
//  Created by Dagmawi Nadew-Assefa on 5/26/18.
//  Copyright © 2018 Sason. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GitHubAPIManager {
    
    private static let instance = GitHubAPIManager()
    private init() {}
    static var sharedInstance: GitHubAPIManager {
        return instance
    }
    
    func fetchPublicGists(completion: @escaping(Result<[Gists]>) -> ()) {
        Alamofire.request(GistRouter.getPublicGists).responseJSON { (response) in
            let result = self.gistsArrayFrom(response: response)
            completion(result)
        }
    }
    
    private enum GistRouter: URLRequestConvertible {
        
        static let baseURL = "https://api.github.com"
        
        case getPublicGists
        
        func asURLRequest() throws -> URLRequest {
            
            var method: HTTPMethod {
                switch self {
                case .getPublicGists: return .get
                }
            }
            
            let result: (path: String, parameters: [String: Any]?)={
                switch self {
                case .getPublicGists: return ("/gists/public", nil)
                }
            }()
            
            var url = URL(string: GistRouter.baseURL)!
            url = url.appendingPathComponent(result.path)
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            
            return try JSONEncoding.default.encode(urlRequest, with: result.parameters)
        }
    }
    
    private enum GitHubAPIManagerError: Error {
        case networkError(error: Error)
        case apiProvidedError(reason: String)
        case authCouldNot(reason: String)
        case authLost(reason: String)
        case objectSerialization(reason: String)
    }
    
    private func gistsArrayFrom(response: DataResponse<Any>) -> Result<[Gists]> {
        guard response.result.error == nil else {
            return .failure(GitHubAPIManagerError.networkError(error: response.result.error!))
        }
        
        guard let jsonArray = response.result.value as? [[String: Any]] else {
            return .failure(GitHubAPIManagerError.objectSerialization(reason: "Did not get a JSON object"))
        }
        
        if let jsonDictionary = response.result.value as? [String:Any], let errorMessage = jsonDictionary["message"] as? String {
            return .failure(GitHubAPIManagerError.apiProvidedError(reason: errorMessage))
        }
        
        var gists = [Gists]()
        for item in jsonArray{
            if let gist = Gists(json: item){
                gists.append(gist)
            }
        }
        
        return .success(gists)
    }
}



