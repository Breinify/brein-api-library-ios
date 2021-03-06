<blockquote class="lang-specific swift">
<p>The iOS library offers several overloaded versions
of the <code class="prettyprint">Breinify.temporalData(...)</code> method.

In addition, it is also possible to split the configuration of the temporalData
object and the execution of the request. In this case create an instance of
class BreinTemporalData and use this as a parameter later in class Breinify.

</p>
</blockquote>

<blockquote class="lang-specific swift">
<p>If a simple request is fired, the endpoint uses the client's information (attached to the request, e.g., 
the <code class="prettyprint">ipAddress</code>) to determine the different temporal information.</p>
</blockquote>

>
```swift
do {          
     try Breinify.temporalData()
   } catch {
     print("Error is: \(error)")
}
```

<blockquote class="lang-specific swift">
<p>Another possibility is to provide specific data. This is typically done, if
some specific temporal data should be resolved, e.g., a location based on a free text, 
a pair of coordinates (latitude/longitude), or a specific ip-address. Have a look at the
<a href="#example-use-cases">further use cases</a> to see other examples.</p>
</blockquote>

>
```swift
do {
      let breinTemporalData = BreinTemporalData()
      breinTemporalData.setLookUpIpAddress("204.28.127.66")
>           
      try Breinify.temporalData(breinTemporalData)
    } catch {
      print("Error is: \(error)")
    }    
```

<blockquote class="lang-specific swift">
<p>The library provides several setter methods to simplify the usage (e.g., the already
used <code class="prettyprint">setLookUpIpAddress</code>).
</blockquote>

>
