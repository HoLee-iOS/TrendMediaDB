//
//  ViewController.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var infoTableView: UITableView!
    
    var titles: [String] = []
    var posters: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoTableView.register(UINib(nibName: InfoTableViewCell.resuseIdentifier, bundle: nil), forCellReuseIdentifier: InfoTableViewCell.resuseIdentifier)
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        
        
        
        
        
        
        loadMedia()
    }

    func loadMedia() {
        //쿼리는 한글이 들어가면 에러가 남, 딕셔너리처럼 순서는 상관 없음
        //한글을 사용하지 못하는 이유는 한글이 utf-8로 인코딩되지 않았기 때문
        //아래와 같은 코드로 인코딩 처리가 가능함
        
        let url = "\(EndPoint.movieURL)\(MediaType.movie)/\(TimeWindow.week)?api_key=\(APIKey.TMDB)"
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                
                for i in json["results"].arrayValue {
                    
                    let x = i["title"].stringValue
                    self.titles.append(x)
                    
                    guard let y = URL(string: EndPoint.imageURL + i["poster_path"].stringValue) else { return }
                
                    self.posters.append(y)
                    
                }
                
                self.infoTableView.reloadData()
                
            case .failure(let error):
                print(error)
                
            }
        }
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.resuseIdentifier, for: indexPath) as! InfoTableViewCell
        
        cell.mediaName.text = titles[indexPath.row]
        cell.poster.kf.setImage(with: posters[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
}

