>
```swift
let breinUser = BreinUser(email: "max@sample.com")
   .setSessionId("966542c6-2399-11e7-93ae-92361f002671")
>        
let breinActivity = BreinActivity()
   .setTag("productPrices", [134.23, 15.13, 12.99] as AnyObject)
   .setTag("productIds", ["125689", "982361", "157029"] as AnyObject)
>        
// invoke activity call
do {
     try Breinify.activity(breinActivity, user: breinUser, activityType: "checkOut")
   } catch {
     print("Error is: \(error)")
   }
```