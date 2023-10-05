import SwiftUI
import Firebase
//----------------------------------------------------------------------------------------
class AppViewModel: ObservableObject {
    let auth = Auth.auth()
    @Published var signedIn = true
//    var isSignedIn = true
    var isSignedIn : Bool{
        return auth.currentUser != nil
    }
    
    func signUp(email: String, password: String){
        auth.createUser(withEmail: email, password: password) {
            [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    

    func signIn (email: String, password: String){
        auth.signIn(withEmail: email, password: password) {
            [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signOut (){
        try? auth.signOut()
        self.signedIn = false
    }
}
//-------------------------------------------------------------------------------------------

 
struct ContentView: View {
    @EnvironmentObject var viewModel : AppViewModel
    
    var body: some View {
        NavigationView{
            if viewModel.signedIn {
                   
                ListView()
            }
            else {
                SignInView()
            }
        }
        .onAppear{
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

//-------------------------------------------------------------------------------------------------------------
struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel : AppViewModel
    var body: some View {
        ZStack{
        
            Color.black
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.linearGradient(colors: [.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height:400)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
            
            
            VStack(spacing: 20){
                Spacer()
                Text("NewsApp")
                    .foregroundColor(.white)
                    .font(.system(size:40, weight: .bold, design:.rounded))
//                    .offset(x: -80, y: 60)
            
                TextField("Email", text: $email)
//                    .offset(y: 100)
//                    .foregroundColor(.black)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .accentColor(.blue)
//                    .placeholder(when: email.isEmpty){
//                        Text("Email")
//                            .foregroundColor(.white)
//                            .bold()
//                    }
//                Rectangle()
//                    .frame(width: 350, height:1)
//                    .foregroundColor(.white)
                
                SecureField("Password", text: $password)
//                    .offset(y: 150)
//                    .foregroundColor(.black)
                    .textFieldStyle(.roundedBorder)
                    .padding()
//                    .placeholder(when: password.isEmpty){
//                        Text("Password")
//                            .foregroundColor(.white)
//                            .bold()
//                    }
//                Rectangle()
//                    .frame(width: 350, height:1)
//                    .foregroundColor(.white)

                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    viewModel.signIn(email: email, password: password)
                },
                       label: {
                    Text("Sign In")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors:[.gray, .black], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                })
                .offset(y:-10)
                NavigationLink("Create Account", destination: SignUpView())
                .padding(.top)
                .offset(y: 40)
                Spacer()
            }
        }
                .ignoresSafeArea()
    }
}
//----------------------------------------------------------------------------------------------------------------------

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel : AppViewModel
    var body: some View {
        ZStack{
            Color.black
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.linearGradient(colors: [.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height:400)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
            VStack(spacing: 20){
                Spacer()
                Text("NewsApp")
                    .foregroundColor(.white)
                    .font(.system(size:40, weight: .bold, design:.rounded))
//                    .foregroundColor(.white)
//                    .font(.system(size:40, weight: .bold, design:.rounded))
//                    .offset(x: -80, y: -100)
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .accentColor(.yellow)
//                    .placeholder(when: email.isEmpty){
//                        Text("Email")
//                            .foregroundColor(.white)
//                            .bold()
//                    }
//                Rectangle()
//                    .frame(width: 200, height:1)
////                    .foregroundColor(.white)
                
                SecureField("Password", text: $password)
//                    .offset(y: 150)
//                    .foregroundColor(.black)
                    .textFieldStyle(.roundedBorder)
                    .padding()
//                    .placeholder(when: password.isEmpty){
//                        Text("Password")
//                            .foregroundColor(.blue)
//                            .bold()
//                    }
//                Rectangle()
//                    .frame(width: 350, height:1)
//                    .foregroundColor(.white)

       
                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    viewModel.signUp(email: email, password: password)
                },
                       label: {
                    Text("Create Account")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors:[.black, .white], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                })
                .padding(.top)
                .offset(y: 40)
                Spacer()
            }
                    }
                .ignoresSafeArea()
    }
}


//----------------------------------------------------------------------------------------------------------------------
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
 
//----------------------------------------------------------------------------------------------------------------------
    extension View {
        func placeholder<Content: View>(
            when shouldShow: Bool,
            alignment: Alignment = .leading,
            @ViewBuilder placeholder: () -> Content) -> some View {

                ZStack(alignment: alignment) {
                    placeholder().opacity(shouldShow ? 1 : 0)
                    self
                }
            }
    }
//--------------------------------------------------------------------------------------------------------------------------
 
