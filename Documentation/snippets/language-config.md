<blockquote class="lang-specific ios">
<p>The iOS library is configured through a single call of <code class="prettyprint">Breinify.setConfig(...)</code>. 
The configuration can be changed at any time by calling the method. It is also recommended that the library's resources
will be released when the application shutdowns or the library is not used anymore by calling 
<code class="prettyprint">Breinify.shutdown()</code>.</p>
</blockquote>
 
<blockquote class="lang-specific ios">
<p><b>Note:</b> If working in a multi-threaded environment, it is not recommended to change the configuration within 
the different threads, otherwise it is impossible to foresee, which configuration will be used.</p>
</blockquote>

>
```ios
Breinify.setConfig("938D-3120-64DD-413F-BB55-6573-90CE-473A", 
                   secret: "utakxp7sm6weo5gvk7cytw==")
/*
 * After the configuration is set, you can use the library 
 * (multi-threading is supported). After the library is not used
 * anymore, it is recommended to release the used resources.
 */
Breinify.shutdown()
```

<blockquote class="lang-specific ios">
<p>The Alamofire library is used for any HTTP communication. </p>
</blockquote>
