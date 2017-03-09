//
//  ViewController.swift
//  mapApp
//
//  Created by 藤川 文汰 on 2017/03/07.
//  Copyright © 2017年 藤川 文汰. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アプリを開いたら新宿駅が中心になるように設定
        let center = CLLocationCoordinate2DMake(35.690553, 139.699579)
        
        // 表示範囲
        let span = MKCoordinateSpanMake(0.01, 0.01)
        
        // 中心座標と表示範囲をマップに登録する
        let region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
