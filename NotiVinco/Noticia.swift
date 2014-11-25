//
//  Noticia.swift
//  NotiVinco
//
//  Created by F J Castaneda Ramos on 11/11/14.
//  Copyright (c) 2014 VincoOrbis. All rights reserved.
//

import Foundation
import MapKit

class Noticia: NSObject {
    let titleNoticia: String
    let id: String
    let location: CLLocationCoordinate2D
    let urlString: String
    let content: String
    let date: String
    
    init(titleNoticia: String, id: String, location:CLLocationCoordinate2D, urlString:String, content:String, date:String) {
        self.titleNoticia = titleNoticia
        self.id = id
        self.location = location
        self.urlString = urlString
        self.content = content
        self.date = date
    }
    
    class func fromJSON(json: [String:JSONValue]) -> Noticia? {
        var location:CLLocationCoordinate2D
        let id = json["id"]?.string
        let newsTitle = json["title"]?.string
        let latitude = json["lat"]?.string
        let doubleLat = (latitude! as NSString).doubleValue
        let longitude = json["long"]?.string
        let doubleLong = (longitude! as NSString).doubleValue
        let urlString = json["image"]?.string
        let date  = json["date"]?.string
        let content  = json["content"]?.string
        location = CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLong)
        return Noticia(titleNoticia: newsTitle!, id: id!, location: location, urlString: urlString!, content: content!, date: date!)
    }
}
extension Noticia:MKAnnotation{
    var title: String!{
        return titleNoticia
    }
    var coordinate: CLLocationCoordinate2D{
        return location
    }
}
