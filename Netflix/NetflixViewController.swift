//
//  NetflixViewController.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/09.
//

import UIKit

import Kingfisher

class NetflixViewController: UIViewController {    

    @IBOutlet weak var mainTableView: UITableView!
    
    //2. 배열 생성
    var imageList: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        mainTableView.backgroundColor = .black
        
        //delegate, datasource 연결
        mainTableView.delegate = self
        mainTableView.dataSource = self
    
        //네비게이션바가 스크롤 될때 백그라운드 색상을 유지하고 싶다면 네비게이션바에 빈 이미지를 추가해주면 색상이 유지됨
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .white
        
        //1. 네트워크 통신
        TMDBAPIManager.shared.requestPoster { value in
//            dump(value)
            
            //3. 배열에 담기
            self.imageList = value
            
            //4. 뷰에 표현
            self.mainTableView.reloadData()
        }
    }

}

extension NetflixViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return imageList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NetflixTableViewCell", for: indexPath) as? NetflixTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .black
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.register(UINib(nibName: "ContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ContentCollectionViewCell")
        cell.contentCollectionView.tag = indexPath.section
        cell.titleLabel.text = "\(TMDBAPIManager.shared.movieList[indexPath.section].0)과 비슷한 콘텐츠"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
}

extension NetflixViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else { return UICollectionViewCell() }
        
        let url = URL(string: "\(TMDBAPIManager.shared.imageURL)\(imageList[collectionView.tag][indexPath.item])")
        cell.cardView.posterImageView.kf.setImage(with: url)
        
        return cell
    }
    
}
