//
//  ViewController.swift
//  DemoApiApp
//
//  Created by Julien on 29/09/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var DemoCollectionView: UICollectionView!
    
    var searchText:String?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let messageFrame = UIView()
    var viewModel=ViewModel()
    let notFoundFrame=UIView()
    let strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 50))
    
    override func viewDidLoad() {
        self.viewModel.vc=self
        super.viewDidLoad()
        DemoCollectionView.delegate=self
        DemoCollectionView.dataSource=self
        DemoCollectionView.collectionViewLayout=UICollectionViewFlowLayout()
        DemoCollectionView.register(UINib(nibName: "DemoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        self.messageFrame.frame = CGRect(x: view.frame.midX - 50, y: view.frame.midY , width: 160, height: 100)
        self.displayActivityIndicator()
        searchText=searchTextField.text!
        print(searchText!)
        searchTextField.text=""
        
        self.viewModel.getImages(of: searchText!)
    }
    
    func fetchPhotos(for search:String){
        self.viewModel.getImages(of: search)
    }
    
    
    func displayActivityIndicator() {
        self.notFoundFrame.removeFromSuperview()
        messageFrame.layer.cornerRadius = 15
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        view.addSubview(messageFrame)
    }
    func notFound() {
        self.notFoundFrame.frame = CGRect(x: self.view.frame.midX-140, y: self.view.frame.midY-50, width: 250, height: 50)
        strLabel.text = "Not Found Any Results"
        strLabel.textColor = .red
        notFoundFrame.layer.cornerRadius = 15
        notFoundFrame.backgroundColor = UIColor.white
        notFoundFrame.addSubview(strLabel)
        view.addSubview(notFoundFrame)
    }
    
    
    //MARK->: Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!DemoCollectionViewCell
        
        let imageUrl=viewModel.imageArray[indexPath.row].urls.small       // print(imageUrl)
        
        if let data=try? Data(contentsOf: imageUrl){
            cell.CollectionCellImage.image=UIImage(data: data)
            cell.CollectionCellImage.contentMode = .scaleAspectFill
        }
        return cell
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
