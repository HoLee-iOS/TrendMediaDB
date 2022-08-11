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
    var averages: [Double] = []
    var movieIds: [Int] = []
    
    var casts: [Int : [String]] = [:]
    var characters: [Int : [String]] = [:]
    var profiles: [Int : [URL]] = [:]
    
    var crews: [Int : [String]] = [:]
    var jobs: [Int : [String]] = [:]
    var faces: [Int : [URL]] = [:]
    
    var pages = 1
    var totalCount = 0
    var backDrops: [URL] = []
    var overViews: [String] = []
    
    var videos: [Int:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoTableView.register(UINib(nibName: InfoTableViewCell.resuseIdentifier, bundle: nil), forCellReuseIdentifier: InfoTableViewCell.resuseIdentifier)
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.prefetchDataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(menuClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchClicked))
        
        loadMedia()
    }
    
    @objc func menuClicked() {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: NetflixViewController.resuseIdentifier) as! NetflixViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func searchClicked() {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: MapViewController.resuseIdentifier) as! MapViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func loadMedia() {
        
        //쿼리는 한글이 들어가면 에러가 남, 딕셔너리처럼 순서는 상관 없음
        //한글을 사용하지 못하는 이유는 한글이 utf-8로 인코딩되지 않았기 때문
        //아래와 같은 코드로 인코딩 처리가 가능함
        let url = "\(EndPoint.movieURL)\(MediaType.movie)/\(TimeWindow.week)?api_key=\(APIKey.tmdb)&page=\(pages)"
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let page = json["page"].intValue
                self.pages = page
                
                self.totalCount = json["total_results"].intValue
                
                for i in json["results"].arrayValue {
                    
                    let a = i["title"].stringValue
                    self.titles.append(a)
                    
                    guard let b = URL(string: EndPoint.imageURL + i["poster_path"].stringValue) else { return }
                    self.posters.append(b)
                    
                    let c = i["vote_average"].doubleValue
                    self.averages.append(c)
                    
                    let d = i["id"].intValue
                    self.movieIds.append(d)
                    
                    guard let e = URL(string: EndPoint.imageURL + i["backdrop_path"].stringValue) else { return }
                    self.backDrops.append(e)
                    
                    let f = i["overview"].stringValue
                    self.overViews.append(f)
                    
                    self.loadCast(id: self.movieIds[self.movieIds.count - 1])
                    self.loadVideo(id: self.movieIds[self.movieIds.count - 1])
                }
                
                self.infoTableView.reloadData()
                
            case .failure(let error):
                print(error)
                
            }
        }
        
    }
    
    func loadCast(id: Int) {
        
        var array1: [String] = []
        var array2: [URL] = []
        var array3: [String] = []
        var array4: [String] = []
        var array5: [URL] = []
        var array6: [String] = []
        
        let url = "\(EndPoint.creditURL)\(MediaType.movie)/\(id)/credits?api_key=\(APIKey.tmdb)&language=en-US"
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for i in json["cast"].arrayValue {
                    
                    let a = i["name"].stringValue
                    array1.append(a)
                    self.casts.updateValue(array1, forKey: id)
                    
                    guard let b = URL(string: EndPoint.imageURL + i["profile_path"].stringValue) else { return }
                    array2.append(b)
                    self.profiles.updateValue(array2, forKey: id)
                    
                    let c = i["character"].stringValue
                    array3.append(c)
                    self.characters.updateValue(array3, forKey: id)
                    
                }
                
                for i in json["crew"].arrayValue {
                    
                    let a = i["name"].stringValue
                    array4.append(a)
                    self.crews.updateValue(array4, forKey: id)
                    
                    guard let b = URL(string: EndPoint.imageURL + i["profile_path"].stringValue) else { return }
                    array5.append(b)
                    self.faces.updateValue(array5, forKey: id)
                    
                    let c = i["job"].stringValue
                    array6.append(c)
                    self.jobs.updateValue(array6, forKey: id)
                    
                }
                
                self.infoTableView.reloadData()
                
            case .failure(let error):
                print(error)
                
            }
        }
        
    }
    
    func loadVideo(id: Int) {
        
        let url = "\(EndPoint.creditURL)\(MediaType.movie)/\(id)/videos?api_key=\(APIKey.tmdb)&language=en-US"
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                let video = json["results"][0]["key"].stringValue
                self.videos.updateValue(video, forKey: id)
                
                self.infoTableView.reloadData()
                
            case .failure(let error):
                print(error)
                
            }
        }
        
    }
    
    @objc func linkButtonClicked(_ sender: UIButton) {
        
        let indexPathRow = sender.tag
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: WebViewController.resuseIdentifier) as! WebViewController
        
        if let i = videos[movieIds[indexPathRow]] {
            vc.destinationURL = i
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.resuseIdentifier, for: indexPath) as! InfoTableViewCell
        
        //링크버튼 속성
        cell.linkButton.imageView?.image = UIImage(systemName: "paperclip")
        cell.linkButton.imageView?.tintColor = .white
        cell.linkButton.backgroundColor = .black
        cell.linkButton.layer.cornerRadius = 15
        
        //링크버튼 클릭시 화면 이동
        cell.linkButton.tag = indexPath.row
        cell.linkButton.addTarget(self, action: #selector(linkButtonClicked(_:)), for: .touchUpInside)
        
        //미디어 이름
        cell.mediaName.text = titles[indexPath.row]
        
        //평점 스택뷰
        cell.averageLabel.text = "평점"
        cell.averageLabel.textColor = .white
        cell.averageLabel.backgroundColor = .systemIndigo
        cell.averageLabel.textAlignment = .center
        cell.averageLabel.font = .systemFont(ofSize: 14)
        
        //평점 값
        cell.averageValue.text = String(format: "%.1f", averages[indexPath.row])
        
        //포스터 이미지
        cell.poster.kf.setImage(with: posters[indexPath.row])
        
        //캐스팅 리스트 값
        cell.castList.font = .systemFont(ofSize: 13)
        cell.castList.textColor = .lightGray
        cell.castList.numberOfLines = 1
        
        
        if let actors = casts[movieIds[indexPath.row]] {
            
            cell.castList.text! = actors.joined(separator: ", ")
            
        }
        
        cell.seperateLine.backgroundColor = .black
        
        //디테일 레이블
        cell.detailLabel.text = "자세히 보기"
        cell.detailLabel.font = .systemFont(ofSize: 12)
        
        cell.detailButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        cell.detailButton.tintColor = .black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: DetailTableViewController.resuseIdentifier) as! DetailTableViewController
        
        vc.detailTitle = titles[indexPath.row]
        vc.detailPoster = posters[indexPath.row]
        vc.detailHeader = backDrops[indexPath.row]
        vc.detailOverViews.append(overViews[indexPath.row])
        
        if let i = casts[movieIds[indexPath.row]] {
            vc.detailActors = i
        }
        
        if let i = profiles[movieIds[indexPath.row]] {
            vc.detailProfiles = i
        }
        
        if let i = characters[movieIds[indexPath.row]] {
            vc.detailCharacters = i
        }
        
        if let i = crews[movieIds[indexPath.row]] {
            vc.detailCrews = i
        }
        
        if let i = faces[movieIds[indexPath.row]] {
            vc.detailFaces = i
        }
        
        if let i = jobs[movieIds[indexPath.row]] {
            vc.detailJobs = i
        }
        
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if titles.count - 1 == indexPath.row && titles.count < totalCount {
                print(indexPath.row)
                pages += 1
                loadMedia()
            }
        }
        
        //        print("===\(indexPaths)")
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        //        print("===취소: \(indexPaths)")
    }
    
}


