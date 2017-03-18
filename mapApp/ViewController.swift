//
//  ViewController.swift
//  mapApp
//
//  Created by 藤川 文汰 on 2017/03/07.
//  Copyright © 2017年 藤川 文汰. All rights reserved.
//

// TODO: 早めにファイル分割をしないとできなくなりそう
import UIKit
import MapKit
import GoogleMaps

class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
  
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var searchBar: UISearchBar!
  var locationManager: CLLocationManager = CLLocationManager()
  var currentPlace: MKPointAnnotation!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // ユーザーの向いている方向を表示させたい
    mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
    
    // 位置情報の取得を開始する
    locationManager.startUpdatingLocation()
    
    // 位置情報の利用許可を変更する画面をポップアップ表示する
    locationManager.requestWhenInUseAuthorization()
    
    mapView.delegate = self
    searchBar.delegate = self
    locationManager.delegate = self
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
    // 現在地のみピンにさせない
    if annotation is MKUserLocation {
      return nil
    }
    
    var pinView:MKPinAnnotationView!
    
    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "testPin")
    
    // 吹き出しを表示可能にする
    pinView.canShowCallout = true
    pinView.animatesDrop = true
    
    return pinView
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    // ここにgoogleのapiを使用したものを書きたい
  }
  
//  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//    // キーボードを閉じる
//    searchBar.resignFirstResponder()
//    
//    // 検索条件
//    let request = MKLocalSearchRequest()
//    request.naturalLanguageQuery = searchBar.text
//    
//    request.region = mapView.region
//    
//    // 検索の実行
//    let localSearch: MKLocalSearch = MKLocalSearch(request: request)
//    localSearch.start(completionHandler: {(result, error) in
//      for placemark in (result?.mapItems)! {
//        guard error == nil else { return }
//        let mapPoint = CLLocationCoordinate2DMake(placemark.placemark.coordinate.latitude, placemark.placemark.coordinate.longitude)
//        self.addPin(title: placemark.placemark.name!, subtitle: placemark.placemark.title!, mapPoint: mapPoint)
//      }
//    })
//  }
  
  @IBAction func tapScreen(_ sender: Any) {
    self.view.endEditing(true)
  }
  
  // 位置情報取得時の呼び出しメソッド
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for location in locations {
      let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
      let span = MKCoordinateSpanMake(0.01, 0.01)
      let region = MKCoordinateRegionMake(center, span)
      mapView.setRegion(region, animated: true)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("位置情報取得失敗")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
