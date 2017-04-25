<blockquote class="lang-specific ios">
<p>With the iOS library it is really simple to resolve temporal information
based on a client's ip-address. The endpoint utilizes the requesting ip-address to
determine, which information to return. Thus, the call does not need any additional 
data.</p>
</blockquote>

>
```ios
do {
   try Breinify.temporalData({
       // success
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
       } })
   } catch {
      print("Error")
   }

```

<blockquote class="lang-specific ios">
<p>Sometimes, it may be necessary to resolve a specific ip-address instead of the client's
one. To specify the ip-address to resolve, the library provides an overloaded version, i.e.,</p>
</blockquote>

>
```ios
do {
   let ip = "72.229.28.185"
   try Breinify.temporalData(ipAddress: ip, {
       // success
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
       } })
   } catch {
      print("Error")
   }
```