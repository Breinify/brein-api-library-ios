>
```swift   
do {
   let breinTemporalData = BreinTemporalData()
       .setLocation(freeText: "NYC")
>            
   try Breinify.temporalData(breinTemporalData,
       success: {
           (result: BreinResult) -> Void in
           print("Api Success : result is:\n \(result)")
                                        
           if let holiday = result.get("holidays") {
               print("Holiday is: \(holiday)")
           }
           if let weather = result.get("weather") {
               print("Weather is: \(weather)")
           }
           if let location = result.get("location") {
              print("Location is: \(location)")
           }
           if let time = result.get("time") {
              print("Time is: \(time)")
           }
           if let events = result.get("events") {
              print("Events are: \(events)")
           }                                   
       })
   } catch {
       print("Error")
   }    
    
```