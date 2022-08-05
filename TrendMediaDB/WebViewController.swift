//
//  WebViewController.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/05.
//

import UIKit
import WebKit

class WebViewController: UIViewController, ReusableViewProtocol {
    
    static var resuseIdentifier: String = "WebViewController"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    
    var destinationURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        openWebPage(url: EndPoint.videoURL + destinationURL)
        
    }
    
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    

}
