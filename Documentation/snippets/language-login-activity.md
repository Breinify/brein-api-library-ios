>
```ios
// create a user of interest
let breinUser = BreinUser(email: "max@sample.com")
breinUser.setSessionId("966542c6-2399-11e7-93ae-92361f002671")
>     
// invoke activity call
do {
      try Breinify.activity(breinUser, activityType: "login")
    } catch {
      print("Error is: \(error)")
}
```
