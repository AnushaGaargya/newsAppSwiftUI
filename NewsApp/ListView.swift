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
import WebKit

struct ListView: View {
    @EnvironmentObject var viewModel : AppViewModel
    @ObservedObject var list = getData()

    init() {
        // Customize the appearance of the UIToolbar

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .black

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "RobotoSlab-Bold", size: 29) ?? UIFont.boldSystemFont(ofSize: 29)

        ]
        appearance.titleTextAttributes = titleAttributes
        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            NavigationView{
                List($list.datas){ i in
                    NavigationLink(destination:
                                    webView(url: i.url.wrappedValue).navigationBarTitle("", displayMode: .inline)){
                        if i.image.wrappedValue != ""{
                            ZStack{
                                Color.clear
                                WebImage(url: URL(string: i.image.wrappedValue), options: .highPriority, context: nil)
                                    .resizable()
                                    .cornerRadius(5)
                                    .aspectRatio(contentMode: .fit)
                                    .opacity(0.8)
                                VStack(alignment: .leading, spacing: 24){
                                    Text(i.title.wrappedValue)
                                    
                                        .font(.custom("RobotoSlab-Regular", size: 20))
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)))
                                        .lineLimit(2)
                                        .offset(y: 50)
                                    HStack(spacing: 24){
                                        Text("BBC")
                                            .font(.custom("RobotoSlab-Bold", size: 12))
                                            .fontWeight(.heavy)
                                            .foregroundColor(Color(UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.00)))
                                        Text(i.id.wrappedValue)
                                            .font(.custom("RobotoSlab-Bold", size: 12))
                                            .fontWeight(.heavy)
                                            .foregroundColor(Color(UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.00)))
                                    }.offset(y: 40)
                                }
                            }
                            .cornerRadius(10)
                        }
                    }
                                    .frame( maxWidth: .infinity)
                                    .edgesIgnoringSafeArea(.all)
                                    .listRowBackground(Color(  UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1.00)))
                                    .listStyle(PlainListStyle())
                                    .scrollContentBackground(.hidden)
                }
                .background(Color.black.ignoresSafeArea(.all))
                .navigationBarTitle("HEADLINES", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button (action: {
                            viewModel.signOut()
                        }){
                            Text("Sign Out")
                                .font(.system(size: 14))
                        }
                    }

                }
            }
        }.ignoresSafeArea()
    }
}
//-------------------------------------------------------------------------------------
    struct ListView_Previews: PreviewProvider {
        static var previews: some View {
            ListView()
        }
    }
//--------------------------------------------------------------------------------------
    struct dataType: Identifiable {
        var id: String
        var title: String
        var desc: String
        var url: String
        var image: String
    }
//-------------------------------------------------------------------------------------
    class getData: ObservableObject {
        @Published var datas = [dataType]()
        init() {
            let source = "https://newsapi.org/v2/top-headlines?country=in&apiKey=1d233c9f461a4f2e97497de7d452222b"
            
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
                    DispatchQueue.main.async {
                        self.datas.append(dataType(id: id, title:title, desc: description, url: url, image: image))
                    }
                    
                }
            }.resume()
        }
    }

//--------------------------------------------------------------------------------------
    struct webView : UIViewRepresentable {
        var url : String
        func makeUIView(context: UIViewRepresentableContext<webView>) -> WKWebView{
            let view = WKWebView()
            view.load(URLRequest(url: URL(string: url)!))
            return view
            
        }
        func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<webView>) {
            UIViewRepresentableContext<webView>.self
        }
        
    }

//GENERATE API KEY in NEWSAPI

