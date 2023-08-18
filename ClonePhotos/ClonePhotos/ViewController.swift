//
//  ViewController.swift
//  ClonePhotos
//
//  Created by 한승우 on 2023/03/01.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var numberOfCell: Int = 2
    let cellIdentifier: String = "cell"
    var array = [#imageLiteral(resourceName: "IMG_9016"), #imageLiteral(resourceName: "IMG_0493")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = -0.1
        layout.minimumInteritemSpacing = -0.1
        collectionView.setCollectionViewLayout(layout, animated: true)
    }


}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // create and configure the cells to be displayed in the collection view
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! MyCollectionViewCell
        // configure the cell with data
        // ...
        cell.imageView.image = array[indexPath.row]
        return cell
    }
}

