//
//  ContentView.swift
//  swiftUI_Lab4
//
//  Created by Sara on 02/08/2023.
//
import SwiftUI


enum Category {
    case cars
    case devices
    case clothes
}

struct Data: Identifiable {
    let id : UUID = UUID()
    let title : String
    let category : Category
    let imageURL : URL?
}

struct DetailsView: View {
    let data: Data
    var body: some View {
        GeometryReader {
            geometryProxy in
            ZStack {
                AsyncImage(url: data.imageURL) {
                    result in
                    if let image = result.image {
                        image
                            .resizable()
                           .scaledToFill()
                    } else{
                        ProgressView()
                    }
                }.padding(3)
                .frame(
                    width:geometryProxy.size.width,
                    height:geometryProxy.size.height
                )
                VStack {
                    Spacer()
                    Text(data.title)
                        .foregroundColor(Color.white)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(8)
            }
            .cornerRadius(16)
            .frame(
                width: geometryProxy.size.width,
                height: geometryProxy.size.height
            )
        }
    }
}

func MakeData() -> Array<Data> {
   return
       carsArray.map{
         item in
                Data(
                title : item,
                category : .cars,
                imageURL: URL (
                    string :"https://source.unsplash.com/370x700/?\(item)"
                )
                )
           
       } +
        devicesArray.map {
            item in
                 Data(
                 title : item,
                 category : .devices,
                 imageURL: URL (
                     string :"https://source.unsplash.com/370x700/?\(item)"
                 )
               )
         } +
         clothesArray.map {
             item in
                 Data(
                 title : item,
                 category : .clothes,
                 imageURL: URL (
                     string :"https://source.unsplash.com/370x700/?\(item)"
                 )
                )
           }
}


struct ContentView: View {
   var itemsCategory  = [
        "Cars",
        "Devices",
        "Clothes"
    ]
    let data : Array<Data> = MakeData()
    @State var itemsList : Array<Data> = []
    
    var carsFilter : Array<Data> {
        data.filter({
            data in data.category == .cars
        }
       )
    }
    
    var devicesFilter : Array<Data> {
        data.filter({
            data in data.category == .devices
        }
       )
    }
    
    var clothesFilter : Array<Data> {
        data.filter({
            data in data.category == .clothes
        }
       )
    }
    var body: some View {
      
         VStack{
            HStack {
             List(itemsCategory, id: \.self){ item in
                    NavigationLink(
                        destination : {
                            
                        switch item {
                            case "Cars" :
                            List(carsFilter){ item in
                                NavigationLink(
                                    destination : {
                                        DetailsView(data : item).frame(width: 370, height: 700)
                                        },
                                        label : {
                                            Text(item.title)
                                                .foregroundColor(Color.black)
                                            }
                                        )
                                     }
                            .listStyle(GroupedListStyle())
                            case "Devices" :
                                List(devicesFilter){ item in
                                    NavigationLink(
                                        destination : {
                                            DetailsView(data : item).frame(width: 370, height: 700)
                                            },
                                            label : {
                                                Text(item.title)
                                                    .foregroundColor(Color.black)
                                                }
                                            )
                                }
                                .listStyle(GroupedListStyle())
                                
                            case "Clothes":
                                List(clothesFilter){ item in
                                    NavigationLink(
                                        destination : {
                                   
                                            DetailsView(data : item).frame(width: 370, height: 700)
                                            },
                                            label : {
                                                Text(item.title)
                                                    .foregroundColor(Color.black)
                                                }
                                            )
                                         }
                                .listStyle(GroupedListStyle())
                                
                            default:
                                Text("error")
                            }
                         
                      
                            },
                            label : {
                                Text(item)
                                .listStyle(GroupedListStyle())
                             }
                           )
                            .foregroundColor(Color.blue)
                         }
               
            }//HStack
          }//VStack
    .onAppear{
          passArrayData()
         }

    }//body
    func passArrayData(){
        itemsList = data
    }
}//end

struct SignUp: View {
    @State var username : String = ""
    @State var email : String = ""
    @State var password : String = ""
    @State var showEmailAlert : Bool = false
    @State var emailAlertMessage : String = ""
    @State var showPasswordAlert : Bool = false
    @State var passwordAlertMessage : String = ""
   var body: some View {
       Form{
           Section("User name :"){
           TextField( "user", text: $username)
           }
           Section("Email :"){
           TextField( "user@example.com", text: $email)
           }
           Section("Password:"){
           SecureField( "Password", text: $password )
           }
       }// Form
       .onChange(of: email){
           value in
           validateEmail(value)
       }
       .alert(isPresented : $showEmailAlert){
           Alert(title : Text(emailAlertMessage))
       }
       .onChange( of: password){
           value in
           validatePassword(value)
       }
       .alert(isPresented : $showPasswordAlert){
           Alert(title : Text(passwordAlertMessage))
       }
   }//body
    func validateEmail( _ value : String){

        if value.isEmpty {
            showEmailAlert = true
            emailAlertMessage = "Email is required"
        }else{
            let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"  // 1
            let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)  // 2
            let result = emailValidationPredicate.evaluate(with: value)
            
            if !result {
            showEmailAlert = true
            emailAlertMessage = "The email format is incorrect"
            }
            
        }
    }
    
    func validatePassword( _ value : String){
        if value.isEmpty {
            showPasswordAlert = true
            passwordAlertMessage = "Password is required"
        }else if value.count < 8 {
            showPasswordAlert = true
            passwordAlertMessage = "The password length has to be more than 7"
        }
    }
}//end

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        TabView{
            ContentView()//.navigationTitle("Items")
                .tabItem {
                    Label( "Lists", systemImage: "doc")//icon
                }
        
              SignUp()
                .tabItem {
                    Label( "Sign Up", systemImage: "person")//icon
                }
         }
        }
    }
}




var  carsArray : Array<String> = """
SUV
Hatchback
Sedan
Coupe
Crossover
Minivan
Station Wagon
Convertible
Sports car
Grand tourer
Pony car
""".components(separatedBy: "\n")

var  devicesArray : Array<String> = """
Laptops
Desktops
medical devices
Smartphones
Tablets
Intelligent devices
Network switches
Routers
IoT
Servers
Cloud instances
""".components(separatedBy: "\n")

var  clothesArray : Array<String> = """
Sportswear
Casual Wear
Formal Attire
Outerwear
Active Wear
Sleepwear
Swimwear
Ethnic Clothing
Maternity Wear
Business Casual
Uniforms
Evening Wear
Vintage Clothing
Designer Labels
Workwear
Accessories and Footwear
""".components(separatedBy: "\n")







