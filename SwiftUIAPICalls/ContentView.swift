//
//  ContentView.swift
//  SwiftUIAPICalls
//
//  Created by Shomil Singh on 06/12/23.
//

import SwiftUI



struct ContentView: View {
    @State private var user : User?
    var body: some View {
//        @StateObject var viewmodel = ViewModel()
//        VStack {
//            NavigationView{
//                List{
//                    ForEach(viewmodel.courses, id : \.self) {course in
//                        HStack{
//                            Image("")
//                                .frame(width: 100 , height: 100)
//                                .background(Color.gray)
//                            Text(course.name)
//                                .bold()
//                        }
//                        
//                    }
//                }
//                .navigationTitle("Courses")
//                .onAppear{
//                    viewmodel.fetch()
//                }
//            }
//        }
        VStack{
            AsyncImage(url: URL(string: user?.message ?? "")){ image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            } placeholder: {
                Circle()
                    .foregroundStyle(Color.gray)
            }
            .frame(width: 200 , height: 200)
            Text(user?.status ?? "status")
            
                
                
//                .padding()
//            Text(user?.login ?? "Username")
//                .bold()
//                .font(.title3)
//                .padding()
//            Text(user?.bio ?? "Bio comes here")
//                .italic()
//                .font(.title2)
//                .padding()
            Spacer()
//            Text(user?.login ?? "")
            
            
            
        }
        .padding()
        .task {
            do{
                user = try await getUser()
            }catch GHError.invalidURL{
                print("invalid Url")
            } catch GHError.invalidRESPONSE{
                print("invalid response")
            } catch GHError.invalidDATA{
                print("invalid data")
            } catch {
                print("Unexpected error")
            }
        }
    }
    func getUser() async throws -> User{
        let endpoint = "https://api.github.com/users/octocat"
        let endpoint2 = "https://dog.ceo/api/breeds/image/random"
        guard let url = URL(string: endpoint2) else{
            throw GHError.invalidURL
        }
        let (data , response) = try await URLSession.shared.data(from: url)
        print(String(data: data, encoding: .utf8) ?? "Invalid data")

        
        guard let response = response as? HTTPURLResponse , response.statusCode == 200 else{
            throw GHError.invalidRESPONSE
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(User.self, from: data)
        }catch{
            throw GHError.invalidDATA
        }
      

        
    }
}




#Preview {
    ContentView()
        
}
//struct User : Codable{
//    let login : String
//    let bio : String
//    let avatarUrl : String
//}
struct User : Codable{
    let message : String
    let status : String
}
//struct User : Codable{
//    let ip : String
//    let city : String
//    let region : String
//    let country : String
//    let loc: String
//    let org: String
//    let postal: String
//    let timezone : String
//    let readme: String
//    
//}
enum GHError : Error {
    case invalidURL
    case invalidRESPONSE
    case invalidDATA
}

