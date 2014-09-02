﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.34014
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// 
// This source code was auto-generated by Microsoft.VSDesigner, Version 4.0.30319.34014.
// 
#pragma warning disable 1591

namespace USPS_ACS_Library.gov.usps.epf {
    using System;
    using System.Web.Services;
    using System.Diagnostics;
    using System.Web.Services.Protocols;
    using System.Xml.Serialization;
    using System.ComponentModel;
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Web.Services.WebServiceBindingAttribute(Name="filedownload.cfcSoapBinding", Namespace="http://epf.usps.com")]
    public partial class filedownload : System.Web.Services.Protocols.SoapHttpClientProtocol {
        
        private System.Threading.SendOrPostCallback getFileOperationCompleted;
        
        private System.Threading.SendOrPostCallback setStatusOperationCompleted;
        
        private System.Threading.SendOrPostCallback loginOperationCompleted;
        
        private System.Threading.SendOrPostCallback getListOperationCompleted;
        
        private System.Threading.SendOrPostCallback getEpfVersionOperationCompleted;
        
        private bool useDefaultCredentialsSetExplicitly;
        
        /// <remarks/>
        public filedownload() {
            this.Url = global::USPS_ACS_Library.Properties.Settings.Default.USPS_ACS_Library_gov_usps_epf_filedownload;
            if ((this.IsLocalFileSystemWebService(this.Url) == true)) {
                this.UseDefaultCredentials = true;
                this.useDefaultCredentialsSetExplicitly = false;
            }
            else {
                this.useDefaultCredentialsSetExplicitly = true;
            }
        }
        
        public new string Url {
            get {
                return base.Url;
            }
            set {
                if ((((this.IsLocalFileSystemWebService(base.Url) == true) 
                            && (this.useDefaultCredentialsSetExplicitly == false)) 
                            && (this.IsLocalFileSystemWebService(value) == false))) {
                    base.UseDefaultCredentials = false;
                }
                base.Url = value;
            }
        }
        
        public new bool UseDefaultCredentials {
            get {
                return base.UseDefaultCredentials;
            }
            set {
                base.UseDefaultCredentials = value;
                this.useDefaultCredentialsSetExplicitly = true;
            }
        }
        
        /// <remarks/>
        public event getFileCompletedEventHandler getFileCompleted;
        
        /// <remarks/>
        public event setStatusCompletedEventHandler setStatusCompleted;
        
        /// <remarks/>
        public event loginCompletedEventHandler loginCompleted;
        
        /// <remarks/>
        public event getListCompletedEventHandler getListCompleted;
        
        /// <remarks/>
        public event getEpfVersionCompletedEventHandler getEpfVersionCompleted;
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapRpcMethodAttribute("", RequestNamespace="http://epf.usps.com", ResponseNamespace="http://epf.usps.com")]
        [return: System.Xml.Serialization.SoapElementAttribute("getFileReturn")]
        public string getFile(string authToken, string product_key, string file_id) {
            object[] results = this.Invoke("getFile", new object[] {
                        authToken,
                        product_key,
                        file_id});
            return ((string)(results[0]));
        }
        
        /// <remarks/>
        public void getFileAsync(string authToken, string product_key, string file_id) {
            this.getFileAsync(authToken, product_key, file_id, null);
        }
        
        /// <remarks/>
        public void getFileAsync(string authToken, string product_key, string file_id, object userState) {
            if ((this.getFileOperationCompleted == null)) {
                this.getFileOperationCompleted = new System.Threading.SendOrPostCallback(this.OngetFileOperationCompleted);
            }
            this.InvokeAsync("getFile", new object[] {
                        authToken,
                        product_key,
                        file_id}, this.getFileOperationCompleted, userState);
        }
        
        private void OngetFileOperationCompleted(object arg) {
            if ((this.getFileCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.getFileCompleted(this, new getFileCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapRpcMethodAttribute("", RequestNamespace="http://epf.usps.com", ResponseNamespace="http://epf.usps.com")]
        [return: System.Xml.Serialization.SoapElementAttribute("setStatusReturn")]
        public string setStatus(string authToken, string product_key, string status, string file_id) {
            object[] results = this.Invoke("setStatus", new object[] {
                        authToken,
                        product_key,
                        status,
                        file_id});
            return ((string)(results[0]));
        }
        
        /// <remarks/>
        public void setStatusAsync(string authToken, string product_key, string status, string file_id) {
            this.setStatusAsync(authToken, product_key, status, file_id, null);
        }
        
        /// <remarks/>
        public void setStatusAsync(string authToken, string product_key, string status, string file_id, object userState) {
            if ((this.setStatusOperationCompleted == null)) {
                this.setStatusOperationCompleted = new System.Threading.SendOrPostCallback(this.OnsetStatusOperationCompleted);
            }
            this.InvokeAsync("setStatus", new object[] {
                        authToken,
                        product_key,
                        status,
                        file_id}, this.setStatusOperationCompleted, userState);
        }
        
        private void OnsetStatusOperationCompleted(object arg) {
            if ((this.setStatusCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.setStatusCompleted(this, new setStatusCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapRpcMethodAttribute("", RequestNamespace="http://epf.usps.com", ResponseNamespace="http://epf.usps.com")]
        [return: System.Xml.Serialization.SoapElementAttribute("loginReturn")]
        public string login(string username, string password) {
            object[] results = this.Invoke("login", new object[] {
                        username,
                        password});
            return ((string)(results[0]));
        }
        
        /// <remarks/>
        public void loginAsync(string username, string password) {
            this.loginAsync(username, password, null);
        }
        
        /// <remarks/>
        public void loginAsync(string username, string password, object userState) {
            if ((this.loginOperationCompleted == null)) {
                this.loginOperationCompleted = new System.Threading.SendOrPostCallback(this.OnloginOperationCompleted);
            }
            this.InvokeAsync("login", new object[] {
                        username,
                        password}, this.loginOperationCompleted, userState);
        }
        
        private void OnloginOperationCompleted(object arg) {
            if ((this.loginCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.loginCompleted(this, new loginCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapRpcMethodAttribute("", RequestNamespace="http://epf.usps.com", ResponseNamespace="http://epf.usps.com")]
        [return: System.Xml.Serialization.SoapElementAttribute("getListReturn")]
        public string getList(string authToken, string view_all) {
            object[] results = this.Invoke("getList", new object[] {
                        authToken,
                        view_all});
            return ((string)(results[0]));
        }
        
        /// <remarks/>
        public void getListAsync(string authToken, string view_all) {
            this.getListAsync(authToken, view_all, null);
        }
        
        /// <remarks/>
        public void getListAsync(string authToken, string view_all, object userState) {
            if ((this.getListOperationCompleted == null)) {
                this.getListOperationCompleted = new System.Threading.SendOrPostCallback(this.OngetListOperationCompleted);
            }
            this.InvokeAsync("getList", new object[] {
                        authToken,
                        view_all}, this.getListOperationCompleted, userState);
        }
        
        private void OngetListOperationCompleted(object arg) {
            if ((this.getListCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.getListCompleted(this, new getListCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapRpcMethodAttribute("", RequestNamespace="http://epf.usps.com", ResponseNamespace="http://epf.usps.com")]
        [return: System.Xml.Serialization.SoapElementAttribute("getEpfVersionReturn")]
        public string getEpfVersion() {
            object[] results = this.Invoke("getEpfVersion", new object[0]);
            return ((string)(results[0]));
        }
        
        /// <remarks/>
        public void getEpfVersionAsync() {
            this.getEpfVersionAsync(null);
        }
        
        /// <remarks/>
        public void getEpfVersionAsync(object userState) {
            if ((this.getEpfVersionOperationCompleted == null)) {
                this.getEpfVersionOperationCompleted = new System.Threading.SendOrPostCallback(this.OngetEpfVersionOperationCompleted);
            }
            this.InvokeAsync("getEpfVersion", new object[0], this.getEpfVersionOperationCompleted, userState);
        }
        
        private void OngetEpfVersionOperationCompleted(object arg) {
            if ((this.getEpfVersionCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.getEpfVersionCompleted(this, new getEpfVersionCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        public new void CancelAsync(object userState) {
            base.CancelAsync(userState);
        }
        
        private bool IsLocalFileSystemWebService(string url) {
            if (((url == null) 
                        || (url == string.Empty))) {
                return false;
            }
            System.Uri wsUri = new System.Uri(url);
            if (((wsUri.Port >= 1024) 
                        && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) {
                return true;
            }
            return false;
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    public delegate void getFileCompletedEventHandler(object sender, getFileCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class getFileCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal getFileCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public string Result {
            get {
                this.RaiseExceptionIfNecessary();
                return ((string)(this.results[0]));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    public delegate void setStatusCompletedEventHandler(object sender, setStatusCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class setStatusCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal setStatusCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public string Result {
            get {
                this.RaiseExceptionIfNecessary();
                return ((string)(this.results[0]));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    public delegate void loginCompletedEventHandler(object sender, loginCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class loginCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal loginCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public string Result {
            get {
                this.RaiseExceptionIfNecessary();
                return ((string)(this.results[0]));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    public delegate void getListCompletedEventHandler(object sender, getListCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class getListCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal getListCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public string Result {
            get {
                this.RaiseExceptionIfNecessary();
                return ((string)(this.results[0]));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    public delegate void getEpfVersionCompletedEventHandler(object sender, getEpfVersionCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class getEpfVersionCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal getEpfVersionCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public string Result {
            get {
                this.RaiseExceptionIfNecessary();
                return ((string)(this.results[0]));
            }
        }
    }
}

#pragma warning restore 1591