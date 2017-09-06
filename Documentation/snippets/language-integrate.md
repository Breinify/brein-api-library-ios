<blockquote class="lang-specific ios">
<p>The library is available on <a target="_blank" href="https://cocoapods.org/pods/BreinifyApi">Cocoapods</a>.
You can add it as a typical pod dependency like this:</p>
</blockquote>

>
```ios
target 'MyApp' do
  pod 'BreinifyApi'
end
```

<blockquote class="lang-specific ios">
<p>The library utilizes a query engine, to send requests to the API endpoint. Currently <code class="prettyprint">Alamofire</code>
is used for this. Furthermore <code class="prettyprint">IDZSwiftCommonCrypto</code> is used as a wrapper for Apple's CommonCrypto library.
Both dependencies will automatically be included.
</blockquote>
