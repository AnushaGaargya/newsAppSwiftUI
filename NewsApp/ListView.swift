//
//  ListView.swift
//  NewsApp
//
//  Created by Anusha S on 04/10/23.
//init commit
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI


struct ListView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

struct dataType: Identifiable {
    var id: String
    var title: String
    var desc: String
    var url: String
    var image: String
}

class getData: ObservableObject {
    @Published var datas = [dataType]()
    init() {
        let source = "https://newsapi.org/v2/top-headlines?country=us&apiKey=1d233c9f461a4f2e97497de7d452222b"
        
        let url = URL(string: source)!
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) {
            (data, _, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            let json = try! JSON(data: data!)
            
            for i in json["articles"]{
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url  = i.1["url"].stringValue
                let image = i.1["urlToImage"].stringValue
                let id = i.1["publishedAt"].stringValue
                
                self.datas.append(dataType(id: id, title:title, desc: description, url: url, image: image))
            }
        }
    }
}
//GENERATE API KEY in NEWSAPI

