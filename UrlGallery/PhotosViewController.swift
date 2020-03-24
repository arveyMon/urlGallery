//
//  PhotosViewController.swift
//  UrlGallery
//
//  Created by Agasthyam on 24/03/20.
//  Copyright © 2020 Agasthyam. All rights reserved.
//

import UIKit
import Photos

// MARK: - Cache Extension
let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    
    func imageURLLoad(url: URL) {
        
        DispatchQueue.global().async { [weak self] in
            func setImage(image:UIImage?) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
            let urlToString = url.absoluteString as NSString
            if let cachedImage = imageCache.object(forKey: urlToString) {
                setImage(image: cachedImage)
            } else if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageCache.setObject(image, forKey: urlToString)
                    setImage(image: image)
                }
            }else {
                setImage(image: nil)
            }
        }
    }
}

// MARK: - Data Model
struct Response: Codable {
    let format:String
    let width:Int
    let height:Int
    let filename:String
    let id:Int
    let author:String
    let author_url:String
    let post_url:String
}

class PhotosViewController: UIViewController {
    
    // MARK: - Global properties
    var apiRes = [Response]()
    
    // MARK: - Outelts
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPhotData(urlString: "https://picsum.photos/list")
        self.prepareCollectionView()
    }
    
    // MARK: - Private methods
    public func getPhotData(urlString: String){
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        self.apiRes = try JSONDecoder().decode([Response].self, from: data)
                        print(self.apiRes.count)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    } catch let error {
                        print(error)
                    }
                    
                }
                }.resume()
        }
    }
    
    private func prepareCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "PhoteoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhoteoCollectionViewCell")
    }
    
}

// MARK: - Exteinsions
// MARK: - UICollectionViewDataSource

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiRes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhoteoCollectionViewCell", for: indexPath) as? PhoteoCollectionViewCell
        cell?.photoImageView.imageURLLoad(url: URL(string: "https://picsum.photos/200/300?image=\(apiRes[indexPath.row].id)")!)
        return cell!
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var divider = Int()
        if UIApplication.shared.statusBarOrientation.isLandscape {
            divider = 7
        } else {
           divider = 4
        }
        let width = (Int(UIScreen.main.bounds.size.width) - (divider - 1) * 6 - 40) / divider
        return CGSize(width: width, height: width)
    }
    
}

