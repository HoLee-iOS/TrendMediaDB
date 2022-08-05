//
//  DetailTableViewController.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/04.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class DetailTableViewController: UITableViewController, ReusableViewProtocol {
    
    static var resuseIdentifier: String = "DetailTableViewController"

    @IBOutlet weak var detailHeaderImage: UIImageView!
    @IBOutlet weak var detailPosterImage: UIImageView!
    @IBOutlet weak var detailHeaderName: UILabel!
    
    var detailTitle: String = ""
    var detailPoster: URL?
    var detailHeader: URL?
    
    var detailOverViews: [String] = []
    
    var detailActors: [String] = []
    var detailProfiles: [URL] = []
    var detailCharacters: [String] = []
    
    var detailCrews: [String] = []
    var detailFaces: [URL] = []
    var detailJobs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //헤더뷰 값 전달 받기
        detailHeaderName.text = detailTitle
        detailHeaderName.textColor = .white
        detailHeaderName.font = .systemFont(ofSize: 20, weight: .heavy)
        detailPosterImage.kf.setImage(with: detailPoster)
        detailHeaderImage.kf.setImage(with: detailHeader)
        
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "출연/제작"
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return detailActors.count
        } else {
            return detailCrews.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.resuseIdentifier, for: indexPath) as! OverViewTableViewCell
            
            cell.overViewLabel.text = detailOverViews[indexPath.row]
            cell.overViewLabel.numberOfLines = 2
            cell.overViewButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            cell.overViewButton.tintColor = .black
            return cell
            
        } else if indexPath.section == 1  {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.resuseIdentifier, for: indexPath) as! CastTableViewCell
            
            cell.castName.text = detailActors[indexPath.row]
            cell.castName.font = .systemFont(ofSize: 14)
            
            cell.castProfile.kf.setImage(with: detailProfiles[indexPath.row])
            cell.castProfile.layer.cornerRadius = 10
            
            cell.castCharacter.text = detailCharacters[indexPath.row]
            cell.castCharacter.textColor = .lightGray
            cell.castCharacter.font = .systemFont(ofSize: 14)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.resuseIdentifier, for: indexPath) as! CastTableViewCell
            
            cell.castName.text = detailCrews[indexPath.row]
            cell.castName.font = .systemFont(ofSize: 14)
            
            cell.castProfile.kf.setImage(with: detailFaces[indexPath.row])
            cell.castProfile.layer.cornerRadius = 10
            
            cell.castCharacter.text = detailJobs[indexPath.row]
            cell.castCharacter.textColor = .lightGray
            cell.castCharacter.font = .systemFont(ofSize: 14)
            
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "OverView"
        } else if section == 1 {
            return "Cast"
        } else {
            return "Crew"
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection
                                section: Int) -> String? {
       return ""
    }
    
    
}

