//
//  ViewController.swift
//  mapApp
//
//  Created by 藤川 文汰 on 2017/03/07.
//  Copyright © 2017年 藤川 文汰. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()

        // アプリを開いたら新宿駅が中心になるように設定
        let center = CLLocationCoordinate2DMake(35.690553, 139.699579)
        
        // 表示範囲
        let span = MKCoordinateSpanMake(0.01, 0.01)
        
        // 中心座標と表示範囲をマップに登録する
        let region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard CLLocationManager.locationServicesEnabled() == true else {
            alertMessage(message: "位置情報サービスがONになっていないため利用できません。「設定」⇒「プライバシー」⇒「位置情報サービス」")
            return;
        }
        
        switch CLLocationManager.authorizationStatus() {
        
        // 未設定の場合
        case CLAuthorizationStatus.notDetermined:
            locationManager.requestWhenInUseAuthorization()
        
        // 機能制限されている場合
        case CLAuthorizationStatus.restricted:
            alertMessage(message: "位置情報サービスの利用が制限されている利用できません。「設定」⇒「一般」⇒「機能制限」")
            
        // 許可しないに設定されている場合
        case CLAuthorizationStatus.denied:
            alertMessage(message: "位置情報の利用が許可されていないため利用できません。「設定」⇒「プライバシー」⇒「位置情報サービス」⇒「アプリ名」")
        
        // このAppの使用中のみ許可に設定されている場合
        case CLAuthorizationStatus.authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        // 常に許可に設定されている場合
        case CLAuthorizationStatus.authorizedAlways:
            locationManager.startUpdatingLocation()
        }
    }
    
    func alertMessage(message: String) {
        let alertController = UIAlertController(title: "注意", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func pressMap(_ sender: UILongPressGestureRecognizer) {
        // タップした位置を取得する
        let location:CGPoint = sender.location(in: mapView)
        
        guard sender.state == UIGestureRecognizerState.ended else { return }
        
        // 取得した位置を座標に変換
        let mapPoint:CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        
        // todo メソッドを使用する
        addPin(title: "タイトル", subtitle: "サブタイトル", mapPoint: mapPoint)
    }
    
    func addPin(title: String, subtitle: String, mapPoint: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapPoint
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView:MKPinAnnotationView!
        
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "testPin")
        
        // 吹き出しを表示可能にする
        pinView.canShowCallout = true
        pinView.animatesDrop = true
        
        return pinView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         // キーボードを閉じる
        searchBar.resignFirstResponder()
        
        // 検索条件
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        
        request.region = mapView.region
        
        // 検索の実行
        let localSearch: MKLocalSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler: {(result, error) in
            for placemark in (result?.mapItems)! {
                guard error == nil else { return }
                let mapPoint = CLLocationCoordinate2DMake(placemark.placemark.coordinate.latitude, placemark.placemark.coordinate.longitude)
                self.addPin(title: placemark.placemark.name!, subtitle: placemark.placemark.title!, mapPoint: mapPoint)
            }
        })
    }
    
    @IBAction func tapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // 位置情報を取得する
    // 現在地を表示できる、グーグルのAPIを使用して広範囲の検索ができる
    // http://hajihaji-lemon.com/smartphone/swift/cllocationmanager/
    // http://hajihaji-lemon.com/smartphone/swift/cllocationmanager_pin/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
