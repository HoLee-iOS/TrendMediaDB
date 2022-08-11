//
//  MapViewController.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/11.
//

import UIKit
import MapKit

import CoreLocation

class MapViewController: UIViewController, ReusableViewProtocol {
    
    static var resuseIdentifier: String = "MapViewController"
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    let theaters = TheaterList().mapAnnotations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "mappin"), style: .plain, target: self, action: #selector(showTheaterBrand))
        
        //기본 좌표를 영등포 캠퍼스로 설정하여 위치 정보 권한 거부한 경우 기본 좌표인 영등포 캠퍼스로 이동
        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        setRegionAndAnnotation(center: center)
        
    }
    
    @objc func showTheaterBrand() {
        
        let showAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let myLocation = UIAlertAction(title: "내 위치", style: .destructive) { _ in
            self.removeAnnotations()
            
            if let coordinate = self.locationManager.location?.coordinate {
                self.setRegionAndAnnotation(center: coordinate)
            }
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
        
        let megabox = UIAlertAction(title: "메가박스", style: .default) { _ in
            self.removeAnnotations()
            self.addAnnotaions(brand: "메가박스")
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
        let lotte = UIAlertAction(title: "롯데시네마", style: .default) { _ in
            self.removeAnnotations()
            self.addAnnotaions(brand: "롯데시네마")
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
        let cgv = UIAlertAction(title: "CGV", style: .default) { _ in
            self.removeAnnotations()
            self.addAnnotaions(brand: "CGV")
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
        let showAll = UIAlertAction(title: "전체보기", style: .default) { _ in
            self.removeAnnotations()
            self.addAnnotaions(brand: "메가박스")
            self.addAnnotaions(brand: "롯데시네마")
            self.addAnnotaions(brand: "CGV")
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert.addAction(myLocation)
        showAlert.addAction(megabox)
        showAlert.addAction(lotte)
        showAlert.addAction(cgv)
        showAlert.addAction(showAll)
        showAlert.addAction(cancel)
        
        self.present(showAlert, animated: true, completion: nil)
        
    }
    
    func removeAnnotations() {
        mapView.annotations.forEach { (annotation) in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    
    func addAnnotaions(brand: String) {
        
        for location in theaters {
            if location.type == brand {
                let annotation = MKPointAnnotation()
                annotation.title = location.location
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                mapView.addAnnotation(annotation)
            }
        }
        
    }
    
    //기본 좌표 설정
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        
        //맵뷰가 갖고 있는 모든 어노테이션들을 한눈에 보이게 해줌
        for annotaion in mapView.annotations {
            mapView.selectAnnotation(annotaion, animated: true)
        }
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 19000, longitudinalMeters: 19000)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = center
        annotation.title = "새싹 캠퍼스다"
        
        mapView.addAnnotation(annotation)
        
    }
    
    
    //위치 권한 요청
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치서비스가 꺼져있음")
        }
        
    }
    
    //CLAuthorizationStatus 개발자 문서 보기
    //권한 상태에 따른 코드 구현
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined:
            print("notDetermined")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("denied")
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            print("WhenInUse")
            locationManager.startUpdatingLocation()
        default: print("이제부터 계속 위치 정보를 받아옵니다!")
        }
        
    }
    
    
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            
            //설정까지 이동하거나 설정 세부화면까지 이동하거나
            //한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나 - 설정
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
            
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 가져오기 실패..")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("권한 상태 변경")
        checkUserDeviceLocationServiceAuthorization()
    }
    
}

