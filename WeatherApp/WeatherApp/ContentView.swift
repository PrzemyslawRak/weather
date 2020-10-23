//
//  ContentView.swift
//  WeatherApp
//
//  Created by tooploox on 06/10/2020.
//

import SwiftUI

struct Location : Decodable {
let name : String?
let region : String?
let country : String?
let localtime : String?
}


struct Current : Decodable {
let last_updated : String?
let temp_c : Double?
let wind_kph : Double?
let wind_dir : String?
let pressure_mb : Double?
let precip_mm : Double?
let humidity : Int?
let cloud : Int?
let feelslike_c : Double?
let vis_km : Double?
let uv: Double?
let condition: Condition
//let condition : [String?]
}

struct Condition: Decodable {
    let text: String?
    let icon: String?
    let code: Int
}

struct Weather : Decodable {
let location : Location?
let current : Current?
let condition : Condition?
}


struct ContentView: View {
    @State var city = "Los_Angeles"
    @State var url = "https://api.weatherapi.com/v1/current.json?key=c87b24d88b154db3a1f104416200610&q="
    @State var temperature = 0.0
    @State var description = ""
    @State var getTemp = false
    @State var localtime = ""
    @State var windspeed = 0.0
    @State var visibility = 0.0
    @State var uv = 0.0
    @State var humidity = 0
    @State var pressure = 0.0
    @State var precip = 0.0
    @State var cloud = 0
    @State var windDir = ""
    @State var feelsLike = 0.0
    @State var condition = ""
    @State var text = ""
    
    func getWeatherData() {
        let link = "\(self.url)"+"\(city)"
        let jsonURLString = "\(link)"
    // make URL
    guard let url = URL(string: jsonURLString) else { return }
    // create a session
    URLSession.shared.dataTask(with: url) { (data, response, error) in
    // check for error
    if error != nil {
    print(error!.localizedDescription)
    }
    // check for 200 OK status
    guard let data = data else { return }
    do {
    let weather = try JSONDecoder().decode(Weather.self, from: data)
      //  self.updater.city = weather.location?.name ?? ""
        self.temperature = (weather.current?.temp_c) ?? 0.0
        self.localtime = weather.location?.localtime ?? "Unable to get local time"
        self.windspeed = weather.current?.wind_kph ?? 0.0
        self.visibility = weather.current?.vis_km ?? 0.0
        self.uv = weather.current?.uv ?? 0.0
        self.humidity = weather.current?.humidity ?? 0
        self.pressure = weather.current?.pressure_mb ?? 0
        self.precip = weather.current?.precip_mm ?? 0
        self.cloud = weather.current?.cloud ?? 0
        self.windDir = weather.current?.wind_dir ?? ""
        self.feelsLike = weather.current?.feelslike_c ?? 0.0
        self.condition = weather.current?.condition.text ?? "test"
        self.getTemp.toggle()
    } catch let err {
    print ("Json Err", err)
    }
    // start the session
    }.resume()
    }
    
    var body: some View {
        ZStack {
            Color("appBlue")
                .edgesIgnoringSafeArea(.vertical)
        VStack {
            
  //      Text("\(self.localtime)")
  //          .padding(.bottom)
                TextField("Enter city", text: $city,
                          onEditingChanged: { edit in
                            self.getWeatherData()
                },
                          onCommit: {
                            self.getWeatherData()
                          }).padding(.top, 100)
            if getTemp {
                Text("\(self.city)")
                .opacity(0.6)
  //      .foregroundColor(Color.black)
        Text("\(self.temperature, specifier: "%.0f")°C")
            .font(.system(size: 50, design: .rounded))
            .foregroundColor(Color.white)
            .padding(.bottom, -10)
            Image(self.condition)
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.bottom, -10)
            Text(self.condition)
            .opacity(0.6)
            .padding(.bottom, 200)
            
            VStack{
                Text("Weather details")
                    .font(.headline)
                    .padding(.bottom)
                    .opacity(0.6)
                HStack {
                    Text("Wind speed")
                        .frame(width: 70)
                    Text("Visbility")
                        .frame(width: 60)
                    Text("Rain")
                        .frame(width: 60)
                    Text("Clouds")
                        .frame(width: 60)
                        
                } //.opacity(0.4)
                .font(.system(size: 11))
                .padding(.bottom, 2)
                HStack {
                    Text("\(self.windspeed, specifier: "%.0f") km/h")
                        .frame(width: 70)
                    Text("\(self.visibility, specifier: "%.0f") km")
                        .frame(width: 60)
                    Text("\(self.precip, specifier: "%.0f") mm")
                        .frame(width: 60)
                    Text("\(self.cloud)%")
                        .frame(width: 60)
                } //.opacity(0.6)
                .padding(.bottom, 2)
                
                HStack {
                    Image(systemName: "wind")
                        .frame(width: 70)
                    Image(systemName: "eyeglasses")
                        .frame(width: 60)
                    Image(systemName: "cloud.heavyrain")
                        .frame(width: 60)
                    Image(systemName: "cloud")
                        .frame(width: 60)
                } //.opacity(0.4)
    //    Text("UV index: \(self.uv, specifier: "%.1f")")
   //     Text("Humidity: \(self.humidity)%")
   //     Text("Pressure: \(self.pressure, specifier: "%.0f")")
  //      Text("Wind directory: \(self.windDir)")
  //      Text("Feels like: \(self.feelsLike, specifier: "%.2f") °C")
                
               
                
            } .frame(width: 350, height: 150)
            .background(Color("lightBlue"))
            .cornerRadius(25)
            
            
        }
        }.edgesIgnoringSafeArea(.all)
        .onAppear() {
        
        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

