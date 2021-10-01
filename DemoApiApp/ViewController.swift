//
//  ViewController.swift
//  DemoApiApp
//
//  Created by Julien on 29/09/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    var searchText:String?
    @IBOutlet var searchTextField: UITextField!
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        searchText=searchTextField.text!
        print(searchText!)
        searchTextField.text=""
        fetchPhotos(for: searchText!)
        self.messageFrame.frame = CGRect(x: view.frame.midX - 50, y: view.frame.midY , width: 160, height: 100)
        displayActivityIndicator()
    }
    var ImageArray=[Result]()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let messageFrame = UIView()
    
    func displayActivityIndicator() {
        self.notFoundFrame.removeFromSuperview()
        messageFrame.layer.cornerRadius = 15
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        view.addSubview(messageFrame)
    }
    @IBOutlet var DemoCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DemoCollectionView.delegate=self
        DemoCollectionView.dataSource=self
        self.searchTextField.delegate=self
        DemoCollectionView.collectionViewLayout=UICollectionViewFlowLayout()
        DemoCollectionView.register(UINib(nibName: "DemoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!DemoCollectionViewCell
        
        let imageUrl=ImageArray[indexPath.row].urls.small       // print(imageUrl)
        
        if let data=try? Data(contentsOf: imageUrl){
            cell.CollectionCellImage.image=UIImage(data: data)
            cell.CollectionCellImage.contentMode = .scaleAspectFill
        }
        return cell
    }
    
    func fetchPhotos(for search:String){
        let url="https://api.unsplash.com/search/photos?page=1&per_page=15&query=\(search)&client_id=ARCJGWPx6viI4sCU0if89JhqLYp-LxqyMoRcLt6ZfDI"
        guard let url=URL(string: url) else{
            return
        }
        let task=URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data=data,error == nil else{
                return
            }
            do{
                let jsonResult = try JSONDecoder().decode(Welcome.self, from: data)
                DispatchQueue.main.async {
                    self.ImageArray=jsonResult.results
                    self.activityIndicator.stopAnimating()
                    self.messageFrame.removeFromSuperview()
                    
                    self.DemoCollectionView.reloadData()
                    if(self.ImageArray.count==0){
                        self.notFoundFrame.frame = CGRect(x: self.view.frame.midX-140, y: self.view.frame.midY-50, width: 250, height: 50)
                        self.notFound()
                    }
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
        
    }
    let notFoundFrame=UIView()
    let strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 50))
    func notFound() {
        strLabel.text = "Not Found Any Results"
        strLabel.textColor = .red
        notFoundFrame.layer.cornerRadius = 15
        notFoundFrame.backgroundColor = UIColor.white
        notFoundFrame.addSubview(strLabel)
        view.addSubview(notFoundFrame)
    }
}
extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size=getItemSize(collectionView: collectionView, collectionViewLayout: collectionViewLayout)
        return CGSize(width: size, height: size)
    }
}
func getItemSize(collectionView:UICollectionView, collectionViewLayout:UICollectionViewLayout) -> Int {
    let nbCol = 2
    let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    let totalSpace = flowLayout.sectionInset.left
    + flowLayout.sectionInset.right
    + (flowLayout.minimumInteritemSpacing * CGFloat(nbCol - 1))
    let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(nbCol))
    return size
}
extension ViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.ImageArray.removeAll()
        self.DemoCollectionView.reloadData()
    }
}
