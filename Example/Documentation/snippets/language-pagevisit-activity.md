<blockquote class="lang-specific ios">
<p>When calling the activity endpoint, it is assumed that it is a 'fire and forget' call, i.e., the endpoint is just informed
that the activity happened, but the returned information is ignored. Thus, the implementation of 
<code class="prettyprint">Breinify.activity(...)</code> does not return any information.</p>
</blockquote>

>
```swift
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

<blockquote class="lang-specific ios">
<p>Nevertheless, sometimes (e.g., for logging or debugging purposes) it may be of benefit to see the
returned value. The returned value can be read by utilizing a callback function, i.e., 
</blockquote>

>
```swift
/*
 * This example uses the success and failure callbacks.
 */
let breinUser = BreinUser(email: "max@sample.com")
breinUser.setSessionId("966542c6-2399-11e7-93ae-92361f002671")
>            
// invoke activity call
do {
   try Breinify.activity(breinUser, activityType: "pageVisit",
       {
          // success block
          (result: BreinResult) -> Void in
          print("Api Success : result is:\n \(result)")
       },
       {
          // failure block
          (error: NSDictionary) -> Void in
          print("Api Failure : error is:\n \(error)")
       })
   } catch {
     print("Error is: \(error)")
   }
```