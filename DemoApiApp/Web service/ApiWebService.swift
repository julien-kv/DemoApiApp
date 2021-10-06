//
//  ApiWebService.swift
//  DemoApiApp
//
//  Created by Julien on 01/10/21.
//

import Foundation
import Alamofire

class ApiService{
    func fetchFilms(from:String,completion : @escaping (Welcome)-> Void) {
        let urlString="https://api.unsplash.com/search/photos?page=1&per_page=15&query=\(from)&client_id=ARCJGWPx6viI4sCU0if89JhqLYp-LxqyMoRcLt6ZfDI"
        AF.request(urlString)
            .response { response in
                if let data = response.data{
                    do{
                        let userResponse = try JSONDecoder().decode(Welcome.self, from: data)
                        print(userResponse)
                        completion(userResponse) 
                    }
                    catch let err{
                        print(err.localizedDescription)
                    }
                }
            }
        
    }
}
