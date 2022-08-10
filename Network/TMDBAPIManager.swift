//
//  TMDBAPIManager.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON

class TMDBAPIManager {
    
    static let shared = TMDBAPIManager()
    
    private init() {}
    
    let movieList = [
        ("그레이 맨", 725201),
        ("놉", 762504),
        ("토르: 러브 앤 썬더", 616037),
        ("쥬라기 월드: 도미니언", 507086),
        ("버즈 라이트이어", 718789),
        ("퍼플 하트", 762975),
        ("탑건: 매버릭", 361743),
        ("씨 비스트", 560057)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"
    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> () ) {
        
        let url = "https://api.themoviedb.org/3/movie/\(query)/recommendations?api_key=\(APIKey.tmdb)&language=ko-KR"
                
        //Alamofire -> URLSession Framework -> 비동기로 Request (따로 코드를 처리해주지 않아도 됨 Request 안쪽에 처리 되어 있음)
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
                //성공케이스에 대한 설정
            case .success(let value):
                
                let json = JSON(value)
                
                let value = json["results"].arrayValue[0...7].map { $0["poster_path"].stringValue }
                
//                dump(value)
                
                completionHandler(value)
                
                //실패케이스에 대한 설정
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    func requestPoster(completionHandler: @escaping ([[String]]) -> ()) {
        
        var posterList: [[String]] = []
        
        TMDBAPIManager.shared.callRequest(query: movieList[0].1) { value in
            posterList.append(value)

            TMDBAPIManager.shared.callRequest(query: self.movieList[1].1) { value in
                posterList.append(value)

                TMDBAPIManager.shared.callRequest(query: self.movieList[2].1) { value in
                    posterList.append(value)
                   
                    TMDBAPIManager.shared.callRequest(query: self.movieList[3].1) { value in
                        posterList.append(value)
                     
                        TMDBAPIManager.shared.callRequest(query: self.movieList[4].1) { value in
                            posterList.append(value)
                           
                            TMDBAPIManager.shared.callRequest(query: self.movieList[5].1) { value in
                                posterList.append(value)
                                
                                TMDBAPIManager.shared.callRequest(query: self.movieList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMDBAPIManager.shared.callRequest(query: self.movieList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
}
