//
//  NetworkManager.swift
//  FoodyCookFood
//
//  Created by MeTaLlOiD on 15/02/21.
//

import Foundation

typealias NetworkComplitionHandler<T> = ( _ result: Result<T, Error>) -> ()

typealias Parameters = [String: Any]

struct NetworkManager {
    private var url: NetworkURLs
    private var parameters: Parameters?

    init(url: NetworkURLs, parameters: Parameters?) {
        self.url = url
        self.parameters = parameters
    }
    
    func fetchData<T: Decodable>(completionHandler: @escaping NetworkComplitionHandler<T>) {
        var httpMethod = "get"
        var urlString = ""
        switch url {
        
        case .RandomMeals(url: let url, method: let method):
            httpMethod = method
            urlString = url
        case .MealCategories(url: let url, method: let method):
            httpMethod = method
            urlString = url
        case .SearchByName(url: let url, method: let method):
            httpMethod = method
            urlString = url
        }
        
        let fetcher = Fetcher(urlString: urlString, parameters: parameters, method: httpMethod)
        fetcher.fetchResponse { (result) in
            completionHandler(result)
        }
        
        
    }
}

fileprivate struct Fetcher {
    
    private var urlString: String
    private var parameters: Parameters?
    private var method: String
    
    init(urlString: String, parameters: Parameters?, method: String) {
        self.urlString = urlString
        if let parameters = parameters {
            self.parameters = parameters
        }
        self.method = method
    }
    
    private func getHttpBody(parameters: Parameters?) -> Data? {
        if let parameters = parameters {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
                return data
            } catch let exception {
                print(exception)
            }
        }
        return nil
    }
    func fetchResponse<T: Decodable>( complitionHandler: @escaping NetworkComplitionHandler<T>) {
        
        let urlSession = URLSession.shared
        
        var urlRequest = URLRequest(url: URL(string: self.urlString)!)
        urlRequest.httpMethod = method
        urlRequest.httpBody = getHttpBody(parameters: self.parameters)
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                complitionHandler(.failure(error))
            }
            
            do {
                if let data = data {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    print(object)
                    complitionHandler(.success(object))
                } else {
                    let error = NSError(domain: "Foody", code: -1, userInfo: [NSLocalizedDescriptionKey: "Response Data is nill"]) as Error
                    complitionHandler(.failure(error))
                }
                
            } catch let exception {
                complitionHandler(.failure(exception))
            }
        }.resume()
    }
}
