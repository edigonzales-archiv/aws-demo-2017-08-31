@Grapes([
        @Grab(group='commons-net', module='commons-net', version='3.6'),
        @Grab(group='commons-io', module='commons-io', version='2.5'),
        @Grab(group='org.apache.httpcomponents', module='httpclient', version='4.5.3'),
        @Grab(group='org.apache.httpcomponents', module='httpmime', version='4.5.3'),
        @Grab(group='org.apache.httpcomponents', module='httpcore', version='4.4.6'),
        @Grab(group='org.apache.httpcomponents', module='httpasyncclient', version='4.1.3'),
        @Grab(group='org.asynchttpclient', module='async-http-client', version='2.0.34')

])


import java.nio.file.Files
import groovy.io.FileType
import org.apache.http.impl.client.CloseableHttpClient
import org.apache.http.impl.client.HttpClientBuilder
import org.apache.http.client.methods.HttpPost
import org.apache.http.client.methods.HttpGet
import org.apache.http.entity.mime.MultipartEntityBuilder
import org.apache.http.entity.mime.HttpMultipartMode
import org.apache.http.entity.ContentType
import org.apache.http.HttpEntity
import org.apache.http.HttpResponse
import org.apache.http.util.EntityUtils
import groovyx.gpars.GParsPool
import org.apache.http.impl.nio.client.HttpAsyncClients
import org.apache.http.impl.nio.client.CloseableHttpAsyncClient
import java.util.concurrent.Future
import org.apache.http.entity.BufferedHttpEntity
import org.apache.http.entity.mime.MultipartEntity
import org.apache.http.entity.mime.MultipartFormEntity
import org.apache.http.entity.mime.content.ByteArrayBody
import java.io.ByteArrayOutputStream
import org.apache.http.nio.entity.NByteArrayEntity
import org.apache.commons.io.FileUtils
import java.util.UUID

// Validator URL
//def validatorUrl = "https://interlis2.ch/ilivalidator/"
def validatorUrl = "http://localhost:8888/ilivalidator/"

// File download
//def fosnrs = [2401,2402,2403,2404,2405,2406,2407,2408,2421,2422,2423,2424,2425,2426,2427,2428,2429,2445,2455,2456,2457,2461,2463,2464,2465,2471,2472,2473,2474,2475,2476,2477,2478,2479,2480,2481,2491,2492,2493,2495,2497,2498,2499,2500,2501,2502,2503,2511,2513,2514,2516,2517,2518,2519,2520,2523,2524,2525,2526,2527,2528,2529,2530,2532,2534,2535,2541,2542,2543,2544,2545,2546,2547,2548,2549,2550,2551,2553,2554,2555,2556,2571,2572,2573,2574,2575,2576,2578,2579,2580,2581,2582,2583,2584,2585,2586,2601,2611,2612,2613,2614,2615,2616,2617,2618,2619,2620,2621,2622]
//def fosnrs = [2549]
//def fosnrs = [2549, 2524]
//def fosnrs = [2401,2402,2403]
def fosnrs = [2401,2402,2403,2404,2405,2406,2407,2408,2421]
def baseUrl = "https://geoweb.so.ch/av_datenabgabe/av_daten/itf_so/"
def downloadDir = System.getProperty("java.io.tmpdir") + File.separator
def download = true

// Start
println("START at: " + new Date())

// 1. Download files from AGI webpage
if (download) {
    fosnrs.each { fosnr ->
        
        def url = baseUrl + fosnr + "00.zip"
        println "Downloading: " + url
        
        def file = new File(downloadDir + fosnr + "00.zip").newOutputStream()  
        file << new URL(url).openStream()  
        file.close()  
    }
}

// 2. Unzip files
def list = []

def ant = new AntBuilder()
def dir = new File(downloadDir)

if (download) {
    dir.traverse(type: FileType.FILES, nameFilter: ~/.*\.(?i)zip$/, maxDepth: 0) { file ->
        println "Unzipping: " + file.getAbsolutePath()
        ant.unzip(
                src: file,
                dest: dir,
                overwrite: "true"
        )
        //file.delete()
    }
}

dir.traverse(type: FileType.FILES, nameFilter: ~/^(1|2)[a-zA-Z]?.*\.(?i)itf$/) { file ->
    list << file
}

// 3. Validate INTERLIS transfer files
println "------------ Start PARALLEL validating ------------"
println new Date()

import org.asynchttpclient.AsyncHttpClient
import org.asynchttpclient.DefaultAsyncHttpClient
import org.asynchttpclient.Response
import org.asynchttpclient.AsyncCompletionHandler
import org.asynchttpclient.RequestBuilder
import org.asynchttpclient.request.body.multipart.FilePart
import org.asynchttpclient.Request
import org.asynchttpclient.request.body.multipart.FilePart
import org.asynchttpclient.AsyncHandler


AsyncHttpClient client = new DefaultAsyncHttpClient();

list.each { file ->
    RequestBuilder builder = new RequestBuilder("POST")
    Request request = builder.setUrl(validatorUrl).setBodyParts([new FilePart("file", file, "application/octet-stream")]).build()

    Future<Response> f = client.execute(request, new AsyncCompletionHandler<Response>() {

        @Override
        public Response onCompleted(Response response) throws Exception{
            // Do something with the Response
            // ...
            println response.getResponseBody()
            return response
        }
        
        @Override
        public void onThrowable(Throwable t){
            // Something wrong happened.
        }
    })
}

println "fubar*****"

// Stop
println("STOP at: " + new Date())