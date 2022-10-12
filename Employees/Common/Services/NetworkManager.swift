//
//  NetworkManager.swift
//  Employees
//
//  Created by Александра Широкова on 08.08.2022.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

enum API: String {
    case employeeURL = "https://stoplight.io/mocks/kode-education/trainee-test/25143926/users"
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private var imageCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func fetch<T: Decodable>(dataType: T.Type, url: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let type = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(type))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    return completion(.failure(.noData))
                }
            }
            
        }.resume()
    }
    
    func fetchImage(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completion(UIImage(named: "Goose"))
            return
        }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(UIImage(named: "Goose"))
                }
                return
            }
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
