>
```ios
do {
   let breinTemporalData = BreinTemporalData()
                    .setLatitude(37.7609295)
                    .setLongitude(-122.4194155)
                    .addShapeTypes(["CITY", "NEIGHBORHOOD"])
>
   try Breinify.temporalData(breinTemporalData,
      {
      // success
      (result: BreinResult) -> Void in
      print("Api Success : result is:\n \(result)")
      })
   } catch {
     print("Error")
   }
```

<blockquote class="lang-specific ios">
<p>The returned <code class="prettyprint">GeoJson</code> instances can be read and used via
<code class="prettyprint">result.getLocation().getGeoJson("CITY")</code>. If a shape is not
available, the <code class="prettyprint">getGeoJson(...)</code> method returns 
<code class="prettyprint">nil</code>.</p>
</blockquote>
