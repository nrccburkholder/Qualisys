using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using Newtonsoft.Json;

namespace NRC.Common.Web
{
    /// <summary>
    /// This is a convenient base class for writing a client that sends REST-like requests (possibly with a file attachment) 
    /// and receives JSON in return. The class is threadsafe; to abort all current requests, call Abort().
    /// 
    /// Intended usage is that derived classes will have methods like this:
    /// 
    /// public bool Ping(string clientID, string clientKey, string clientAgent)
    /// {
    ///     Dictionary<string, string> args = new Dictionary<string, string>();
    ///     args["clientID"] = clientID;
    ///     args["clientKey"] = clientKey;
    ///     args["clientAgent"] = clientAgent;
    ///     return CallService<bool>("Ping", "POST", args);
    /// }
    /// </summary>
    abstract public class RESTClient
    {
        protected const int DATA_CHUNK_SIZE = 25000;
        protected const int DEFAULT_TIMEOUT = 30;
        protected object _lock = new object();
        protected Dictionary<Thread, HttpWebRequest> _activeRequests = new Dictionary<Thread, HttpWebRequest>();
        protected bool _aborted = false;

        public RESTClient(string baseUrl)
        {
            this.Url = baseUrl;
            this.TimeoutSecs = DEFAULT_TIMEOUT;
            this.Proxy = WebRequest.DefaultWebProxy;
        }

        public string Url { get; protected set; }
        public int TimeoutSecs { get; set; }
        public IWebProxy Proxy { get; set; }

        // http://stackoverflow.com/questions/566462/upload-files-with-httpwebrequest-multipart-form-data
        // the T generic here is the expected type
        protected T CallService<T>(string serviceMethod, string httpMethod, Dictionary<string, string> args)
        {
            HttpWebResponse response = SendRequestSimple(serviceMethod, httpMethod, args);
            return HandleResponse<T>(response);
        }

        protected T CallServiceWithFile<T>(string serviceMethod, string httpMethod, Dictionary<string, string> args, string fileParam, FileInfo file)
        {
            using (FileStream fileStream = file.OpenRead())
            {
                HttpWebResponse response = SendRequestWithStream(serviceMethod, httpMethod, args, fileParam, file.Name, fileStream);
                return HandleResponse<T>(response);
            }
        }

        protected T CallServiceWithStream<T>(string serviceMethod, string httpMethod, Dictionary<string, string> args, string streamParam, Stream stream)
        {
            HttpWebResponse response = SendRequestWithStream(serviceMethod, httpMethod, args, streamParam, "streamthrough", stream);
            return HandleResponse<T>(response);
        }

        protected T CallServiceWithObject<T>(string serviceMethod, string httpMethod, object value)
        {
            HttpWebResponse response = SendRequestJSON(serviceMethod, httpMethod, value);
            return HandleResponse<T>(response);
        }

        protected HttpWebRequest CreateBasicRequest(string serviceMethod, string httpMethod)
        {
            HttpWebRequest ret = (HttpWebRequest)WebRequest.Create(Url + "/" + serviceMethod);

            lock (_lock)
            {
                if (_aborted)
                {
                    Thread.CurrentThread.Abort();
                }
                _activeRequests[Thread.CurrentThread] = ret;
            }

            ret.Method = httpMethod;
            ret.UserAgent = "NRC API Client/1.0";
            ret.AllowWriteStreamBuffering = false;
            ret.Timeout = this.TimeoutSecs * 1000;
            ret.ReadWriteTimeout = this.TimeoutSecs * 1000;
            ret.Proxy = this.Proxy;
            ret.ServicePoint.Expect100Continue = false;

            return ret;
        }

        protected HttpWebResponse SendRequestSimple(string serviceMethod, string httpMethod, Dictionary<string, string> args)
        {
            HttpWebRequest request = CreateBasicRequest(serviceMethod, httpMethod);

            request.ContentType = "application/x-www-form-urlencoded; charset: UTF-8";

            string data = String.Join("&", args.Select(a => Uri.EscapeDataString(a.Key ?? "") + "=" + Uri.EscapeDataString(a.Value ?? "")).ToArray());
            byte[] buffered = Encoding.UTF8.GetBytes(data);
            request.ContentLength = buffered.Length;
            using (Stream requestStream = request.GetRequestStream())
            {
                requestStream.Write(buffered, 0, buffered.Length);
            }

            return (HttpWebResponse)request.GetResponse();
        }

        protected HttpWebResponse SendRequestJSON(string serviceMethod, string httpMethod, object value)
        {
            HttpWebRequest request = CreateBasicRequest(serviceMethod, httpMethod);

            request.ContentType = "application/json; charset: UTF-8";

            string data = JsonConvert.SerializeObject(value);
            byte[] buffered = Encoding.UTF8.GetBytes(data);
            request.ContentLength = buffered.Length;
            using (Stream requestStream = request.GetRequestStream())
            {
                requestStream.Write(buffered, 0, buffered.Length);
            }

            return (HttpWebResponse)request.GetResponse();
        }

        protected HttpWebResponse SendRequestWithStream(string serviceMethod, string httpMethod, Dictionary<string, string> args, 
            string streamParam, string fileName, Stream stream)
        {
            HttpWebRequest request = CreateBasicRequest(serviceMethod, httpMethod);

            string boundary = "---------------------------" + DateTime.Now.Ticks.ToString("x");
            request.ContentType = "multipart/form-data; boundary=" + boundary;

            byte[] boundaryBytes = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "\r\n");

            MemoryStream bytes = new MemoryStream();
            WriteNormalParameters(args, boundaryBytes, bytes);
            WriteFileHeader(streamParam, fileName, bytes);
            byte[] buffered = bytes.ToArray();
            byte[] footerBytes = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "--\r\n");

            // we now have enough information to calculate the content-length, so we can stop buffering and start writing out for real
            // we assume the stream is one that supports .Length, which I guess might not be true, but in practice it should be
            request.ContentLength = buffered.Length + stream.Length + footerBytes.Length;

            using (Stream requestStream = request.GetRequestStream())
            {
                requestStream.Write(buffered, 0, buffered.Length);
                requestStream.Flush();
                WriteChunked(stream, requestStream);
                requestStream.Write(footerBytes, 0, footerBytes.Length);
            }

            return (HttpWebResponse)request.GetResponse();
        }

        protected void WriteNormalParameters(Dictionary<string, string> args, byte[] boundary, Stream stream)
        {
            string paramTemplate = "Content-Disposition: form-data; name=\"{0}\"\r\n\r\n{1}";
            foreach (KeyValuePair<string, string> arg in args)
            {
                stream.Write(boundary, 0, boundary.Length);
                string encodedParam = string.Format(paramTemplate, arg.Key, arg.Value);
                byte[] encodedParamBytes = System.Text.Encoding.UTF8.GetBytes(encodedParam);
                stream.Write(encodedParamBytes, 0, encodedParamBytes.Length);
            }
            stream.Write(boundary, 0, boundary.Length);
        }

        protected void WriteFileHeader(string argname, string filename, Stream stream)
        {
            string headerTemplate = "Content-Disposition: form-data; name=\"{0}\"; filename=\"{1}\"\r\nContent-Type: {2}\r\n\r\n";
            string header = string.Format(headerTemplate, argname, filename, "application/octet-stream");
            byte[] headerBytes = System.Text.Encoding.UTF8.GetBytes(header);
            stream.Write(headerBytes, 0, headerBytes.Length);
        }

        protected void WriteChunked(Stream sourceStream, Stream destStream)
        {
            byte[] buffer = new byte[DATA_CHUNK_SIZE];
            int bytesRead = 0;
            while ((bytesRead = sourceStream.Read(buffer, 0, buffer.Length)) != 0)
            {
                destStream.Write(buffer, 0, bytesRead);
                destStream.Flush();
            }
        }

        protected T HandleResponse<T>(HttpWebResponse response)
        {
            try
            {
                return ParseResponse<T>(response);
            }
            finally
            {
                lock (_lock)
                {
                    _activeRequests.Remove(Thread.CurrentThread);
                }
            }
        }

        protected T ParseResponse<T>(HttpWebResponse response)
        {
            if (response.StatusCode != HttpStatusCode.OK)
            {
                throw new Exception("Unexpected status code in response: " + response.StatusCode.ToString());
            }

            using (Stream responseStream = response.GetResponseStream())
            {
                Encoding encoding = Encoding.UTF8;
                if (!String.IsNullOrEmpty(response.CharacterSet))
                {
                    encoding = Encoding.GetEncoding(response.CharacterSet);
                }
                StreamReader reader = new StreamReader(responseStream, encoding);
                string txt = reader.ReadToEnd();

                try
                {
                    return JsonConvert.DeserializeObject<T>(txt, new JsonSerializerSettings { MissingMemberHandling = MissingMemberHandling.Error });
                }
                catch (Exception ex)
                {
                    Failure failure;
                    try
                    {
                        failure = JsonConvert.DeserializeObject<Failure>(txt, new JsonSerializerSettings { MissingMemberHandling = MissingMemberHandling.Error });
                    }
                    catch (Exception)
                    {
                        throw new Exception(String.Format("Unable to deserialize response from server ({0}): {1}", ex.Message, txt));
                    }
                    throw (failure.Type == FailureType.External) ? new UserException(failure.Message) : new Exception(failure.Message);
                }
            }
        }

        public void Abort()
        {
            var requests = _activeRequests.ToList(); // aborting may modify this, so make a copy and iterate over that
            foreach (var t in requests)
            {
                t.Value.Abort();
                t.Key.Abort();
            }
        }
    }
}
