//
//  ViewModel.swift
//  DemoApiApp
//
//  Created by Julien on 04/10/21.
//

import Foundation
import Alamofire

class ViewModel{
    private var apiService:ApiService!
    var imageArray=[Result]()
    var vc:ViewController?
    init(){
        self.apiService=ApiService()
    }
    
    func getImages(of query: String){
        apiService.fetchFilms(from: query){data in
            print(data.results)
           
            self.imageArray = data.results
            DispatchQueue.main.async{
                self.vc?.activityIndicator.stopAnimating()
                self.vc?.messageFrame.removeFromSuperview()
                self.vc?.DemoCollectionView.reloadData()
                if(self.imageArray.count==0){
                    self.vc?.view.backgroundColor=UIColor.white
                    self.vc?.notFound()
                }
            }
        }

    }
    
}
