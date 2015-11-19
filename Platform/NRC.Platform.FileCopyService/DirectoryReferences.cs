using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Net;
using System.Diagnostics;

using NRC.Common.Configuration;
using Tamir.SharpSsh;

namespace NRC.Platform.FileCopyService
{
    //User must specify exactly one of these options for source and destination
    //  and optionally one for backup
    //Helper function will validate that just one was chosen and return it
    public class DirectoryReferenceManager : ConfigSection
    {
        [ConfigUse("Local", IsOptional = true, Default = "null")]
        public LocalDirectory local;

        [ConfigUse("UNC", IsOptional = true, Default = "null")]
        public UNCDirectory unc;

        [ConfigUse("FTP", IsOptional = true, Default = "null")]
        public FTPDirectory ftp;

        [ConfigUse("SFTP", IsOptional = true, Default = "null")]
        public SFTPDirectory sftp;

        public IDirectoryReference Which()
        {
            //If you need to add a new implementation of IDirectoryReference, add it to 'all' here
            IDirectoryReference[] all = { local, unc, ftp, sftp };
            if (all.Where(t => t != null).Count() != 1)
            {
                throw new ConfigException("Must specify exactly 1 DirectoryReference");
            }
            return all.Where(t => t != null).First();
        }
    }

    public class LocalDirectory : ConfigSection, IDirectoryReference
    {
        [ConfigUse("Path")]
        public string Path { get; set; }

        public string FullFilename(string file)
        {
            return Path + file;
        }

        virtual public void Prepare()
        {
            Debug.WriteLine("Local Prepare");
        }

        virtual public void Unprepare()
        {
            Debug.WriteLine("Local Unprepare");
        }

        public IEnumerable<string> ListFiles()
        {
            System.IO.DirectoryInfo dir = new System.IO.DirectoryInfo(Path);

            IEnumerable<string> fullFilePaths = dir.GetFiles("*.*", System.IO.SearchOption.AllDirectories)
                .Where( t => !(t.Attributes & FileAttributes.System).Equals(FileAttributes.System))
                .Select(t => t.FullName);

            //Let's verify for which of these files we can get an exclusive read/write lock on
            //if we can't it's possible they're still being written and not ready to be moved
            //This is an enhancement over the prior logic of looking at the last write time + 5 minutes.
            //The list of failedToLockFilePaths is being left here mainly for debugging purposes and causes minimal overhead
            List<string> lockableRelativeFilePaths = new List<string>();

            foreach (string fullFilePath in fullFilePaths)
            {
                //I found this method was returning a list of files with relative paths within the directory
                //including a trailing slash. Continuing to return the same as the business logic works with it.
                string relativeFilePath = fullFilePath.Remove(0, Path.Length);

                try
                {
                    //string filepath = Path.Combine(path, relFilename);
                    using (FileStream fs = new FileStream(fullFilePath, FileMode.Open, FileAccess.ReadWrite, FileShare.None))
                    {
                        lockableRelativeFilePaths.Add(relativeFilePath);
                        Debug.WriteLine("Able to lock file: " + relativeFilePath);
                    }
                }
                catch
                {
                    //We're unable to get a lock on this file
                    Debug.WriteLine("NOT able to lock file: " + relativeFilePath);
                }
            }

            return lockableRelativeFilePaths;
        }

        public bool Exists(string file)
        {
            return System.IO.File.Exists(Path + file);
        }

        public void GetFile(string file, string local)
        {
            //over write local temp file
            Debug.WriteLine("Local Get " + Path + file);
            System.IO.File.Copy(Path + file, local, true); 
        }

        public void PutFile(string local, string file)
        {
            Debug.WriteLine("Local Put " + Path + file);
            Directory.CreateDirectory(System.IO.Path.GetDirectoryName(Path + file));
            System.IO.File.Copy(local, Path + file);
        }

        public void RemoveFile(string file)
        {
            Debug.WriteLine("Local Remove " + Path + file);
            System.IO.File.Delete(Path + file);
        }
    }

    public class UNCDirectory : LocalDirectory
    {
        [ConfigUse("UserName")]
        public string username;

        [ConfigUse("Password")]
        public string password;

        private NetworkDrive nd = null;

        public override void Prepare()
        {
            Debug.WriteLine("UNC Prepare");
            nd = new NetworkDrive();
            Debug.WriteLine(Path + " " + username + " " + password);
            nd.MapNetworkDrive(Path, username, password);
        }

        public override void Unprepare()
        {
            Debug.WriteLine("UNC Unprepare");
            nd.UnmapNetworkDrive(Path);
        }
    }

    public class FTPDirectory : ConfigSection, IDirectoryReference
    {
        [ConfigUse("Server")]
        public string server;

        [ConfigUse("Path")]
        public string Path { get; set; }

        [ConfigUse("UserName")]
        public string username;

        [ConfigUse("Password", IsOptional = true, Default = "")]
        public string password;

        public string FullFilename(string file)
        {
            return string.Format("ftp://{0}@{1}{2}{3}", username, server, Path, file.Replace("\\", "/"));
        }

        public void Prepare()
        {
        }

        public void Unprepare()
        {
        }

        public IEnumerable<string> ListFiles()
        {
            return ListFilesInternal("/");
        }

        private IEnumerable<string> ListFilesInternal(string ipath)
        {
            Debug.WriteLine("FTP ListFiles " + GetFileUrl(ipath));
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create(GetFileUrl(ipath));
            request.Credentials = new NetworkCredential(username, password);
            request.Method = WebRequestMethods.Ftp.ListDirectory;

            FtpWebResponse response = (FtpWebResponse)request.GetResponse();
            StreamReader reader = new StreamReader(response.GetResponseStream());

            List<string> entries = new List<string>();
            string entry = reader.ReadLine();
            while (entry != null)
            {
                // Test FTP server return topMostSubDir/File.ext instead of just File.ext
                //  this doesn't seem right anymore
                Debug.WriteLine("FTP ListFiles found " + entry);
                if (entry.IndexOf('/') != -1)
                {
                    entry = entry.Remove(0, entry.IndexOf('/') + 1);
                    entry = ipath + "/" + entry;
                }
                else
                {
                    entry = "/" + entry;
                }

                //use GetFileSize to find out if it's a directory or a real file
                //  kind of hackish
                if (GetFileSize(entry) == -1)
                {
                    entries.AddRange(ListFilesInternal(entry));
                }
                else
                {
                    entries.Add(entry.Replace("/", "\\"));
                }
                entry = reader.ReadLine();
            }
            return entries;
        }

        public long GetFileSize(string file)
        {
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create(GetFileUrl(file));
            request.Credentials = new NetworkCredential(username, password);
            request.Method = WebRequestMethods.Ftp.GetFileSize;

            try
            {
                FtpWebResponse response = (FtpWebResponse)request.GetResponse();
                return response.ContentLength;
            }
            catch (WebException)
            {
                return -1;
            }
        }

        public bool Exists(string file)
        {
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create(GetFileUrl(file));
            request.Credentials = new NetworkCredential(username, password);
            request.Method = WebRequestMethods.Ftp.ListDirectory;

            try
            {
                FtpWebResponse response = (FtpWebResponse)request.GetResponse();
            }
            catch (WebException)
            {
                return false;
            }

            return true;
        }

        public void GetFile(string file, string local)
        {
            Debug.WriteLine("FTP Get " + GetFileUrl(file));
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create(GetFileUrl(file));
            request.Credentials = new NetworkCredential(username, password);
            request.Method = WebRequestMethods.Ftp.DownloadFile;

            FtpWebResponse response = (FtpWebResponse)request.GetResponse();
            Stream data = response.GetResponseStream();
            Stream output = File.Open(local, FileMode.OpenOrCreate);

            byte[] buffer = new byte[8 * 1024];
            int len;
            while ((len = data.Read(buffer, 0, buffer.Length)) > 0)
            {
                output.Write(buffer, 0, len);
            }
            output.Close();
        }

        public void PutFile(string local, string file)
        {
            EnsureDirectoryExists(System.IO.Path.GetDirectoryName(file));
            Debug.WriteLine("FTP Put " + GetFileUrl(file));
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create(GetFileUrl(file));
            request.Credentials = new NetworkCredential(username, password);
            request.Method = WebRequestMethods.Ftp.UploadFile;

            Stream output = request.GetRequestStream();
            Stream input = File.Open(local, FileMode.OpenOrCreate);

            byte[] buffer = new byte[8 * 1024];
            int len;
            while ((len = input.Read(buffer, 0, buffer.Length)) > 0)
            {
                output.Write(buffer, 0, len);
            }
            input.Close();
            output.Close();

            FtpWebResponse response = (FtpWebResponse)request.GetResponse();
            Debug.Write("FTP Put status " + response.StatusDescription);
        }

        public void RemoveFile(string file)
        {
            Debug.WriteLine("FTP Remove " + GetFileUrl(file));
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create(GetFileUrl(file));
            request.Credentials = new NetworkCredential(username, password);
            request.Method = WebRequestMethods.Ftp.DeleteFile;

            FtpWebResponse response = (FtpWebResponse)request.GetResponse();
            //Console.WriteLine("Delete status: {0}", response.StatusDescription);
            response.Close();
        }

        public void Mkdir(string dir)
        {
            Debug.WriteLine("FTP Mkdir " + GetFileUrl(dir));
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create(GetFileUrl(dir));
            request.Credentials = new NetworkCredential(username, password);
            request.Method = WebRequestMethods.Ftp.MakeDirectory;

            FtpWebResponse response = (FtpWebResponse)request.GetResponse();
            //Console.WriteLine("Mkdir status: {0}", response.StatusDescription);
            response.Close();
        }

        public void EnsureDirectoryExists(string dir)
        {
            dir = dir.Replace("\\", "/");
            Debug.WriteLine("FTP EnsureDirExists " + dir);
            string[] subdirs = dir.Split('/');
            for (int ii = 2; ii <= subdirs.Count(); ii++)
            {
                string curdir = string.Join("/", subdirs.Take(ii));
                if (!Exists(curdir))
                {
                    Mkdir(curdir);
                }
            }
        }

        public string GetFileUrl(string file)
        {
            file = file.Replace("\\", "/");
            if (!file.StartsWith("/"))
            {
                file = "/" + file;
            }
            return "ftp://" + server + Path + file;
        }
    }

    public class SFTPDirectory : ConfigSection, IDirectoryReference
    {
        [ConfigUse("Server")]
        public string server;

        [ConfigUse("Path")]
        public string Path { get; set; }

        [ConfigUse("UserName")]
        public string username;

        //can use either password or keyfile
        [ConfigUse("Password", IsOptional = true, Default = "")]
        public string password;

        [ConfigUse("KeyFile", IsOptional = true, Default = "")]
        public string keyFile;

        private Sftp sftp;

        public string FullFilename(string file)
        {
            return string.Format("sftp://{0}@{1}{2}{3}", username, server, Path, file.Replace("\\", "/"));
        }

        public void Prepare()
        {
            Debug.WriteLine("SFTP Prepare");
            sftp = new Sftp(server, username);
            if (!string.IsNullOrEmpty(keyFile))
            {
                if (string.IsNullOrEmpty(password))
                {
                    Debug.WriteLine("AddIdentityFile w/o pass");
                    sftp.AddIdentityFile(keyFile);
                }
                else
                {
                    Debug.WriteLine("AddIdentityFile w/ pass");
                    sftp.AddIdentityFile(keyFile, password);
                }
            }
            else
            {
                sftp.Password = password;
            }
            sftp.Connect();
        }

        public void Unprepare()
        {
            Debug.WriteLine("SFTP Unprepare");
            sftp.Close();
        }

        public IEnumerable<string> ListFiles()
        {
            return
                from string entry in ListFilesInternal(Path)
                select entry.Remove(0, Path.Length);
        }

        private IEnumerable<string> ListFilesInternal(string ipath)
        {
            IEnumerable<string> entries =
                from string entry in sftp.GetFileList( ipath )
                select entry;
            List<string> ret = new List<string>();

            foreach (string entry in entries)
            {
                if (entry == "." || entry == "..")
                {
                    continue;
                }

                string fullEntry = ipath + "/" + entry;

                if (sftp.IsDir(fullEntry))
                {
                    ret.AddRange(ListFilesInternal(fullEntry));
                }
                else
                {
                    ret.Add(fullEntry.Replace("/", "\\"));
                }
            }
            return ret;
        }

        public bool Exists(string file)
        {
            return sftp.Exists(Path + file);
        }

        public void GetFile(string file, string local)
        {
            string fullpath = (Path + file).Replace("\\", "/");
            Debug.WriteLine("SFTP Get " + fullpath);
            sftp.Get(fullpath, local);
        }

        public void PutFile(string local, string file)
        {
            string fullpath = (Path + file).Replace("\\", "/");
            EnsureDirectoryExists(System.IO.Path.GetDirectoryName(file));
            Debug.WriteLine("SFTP Put " + fullpath);
            sftp.Put(local, fullpath);
        }

        public void RemoveFile(string file)
        {
            string fullpath = (Path + file).Replace("\\", "/");
            Debug.WriteLine("SFTP Remove " + fullpath);
            sftp.Remove(fullpath);
        }

        public void EnsureDirectoryExists(string dir)
        {
            dir = dir.Replace("\\", "/");
            Debug.WriteLine("SFTP EnsureDirExists " + dir);
            string[] subdirs = dir.Split('/');
            for (int ii = 2; ii <= subdirs.Count(); ii++)
            {
                string curdir = string.Join("/", subdirs.Take(ii));
                if (!Exists(curdir))
                {
                    sftp.Mkdir(Path + curdir);
                }
            }
        }
    }
}
