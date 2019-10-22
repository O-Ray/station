//
//  MapViewController.swift
//  station
//
//  Created by 大塚嶺 on 2019/10/22.
//  Copyright © 2019 大塚嶺. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var googleMap : GMSMapView!

    //緯度経度 -> 金沢駅
    let latitude: CLLocationDegrees = 36.5780574
    let longitude: CLLocationDegrees = 136.6486596


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // ズームレベル.
        let zoom: Float = 15

        // カメラを生成.
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude,longitude: longitude, zoom: zoom)

        // MapViewを生成.
        googleMap = GMSMapView(frame: CGRect(x : 0, y : 0, width : UIScreen.main.bounds.size.width, height : UIScreen.main.bounds.size.height))
        
        // MapViewにカメラを追加.
        googleMap.camera = camera

        //マーカーの作成
        let marker: GMSMarker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.map = googleMap


        //viewにMapViewを追加.
        self.view.addSubview(googleMap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
