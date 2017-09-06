<blockquote class="lang-specific ios">
<p>With the iOS library it is really simple to resolve temporal information
based on a client's ip-address. The endpoint utilizes the requesting ip-address to
determine, which information to return. Thus, the call does not need any additional 
data.</p>
</blockquote>

>
```ios
do {
     try Breinify.temporalData()
   } catch {
     print("Error is: \(error)")
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
     try Breinify.temporalData(ip)
   } catch {
     print("Error is: \(error)")
   }
```
