using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;

using NRC.Platform.FileCopyService;

namespace NRC.Platform.FileCopyService.Test
{
    public class TestDirectories {
        //You will need to update this to whatever credentials your test accounts have.
        private static string TestUser = "TestUser";
        private static string TestPassword = "T3stP@ssw0rd";

        public static IDirectoryReference LocalSource()
        {
            LocalDirectory ret = new LocalDirectory();
            ret.path = @"C:\FCS\Source";
            return ret;
        }

        public static IDirectoryReference LocalDestination()
        {
            LocalDirectory ret = new LocalDirectory();
            ret.path = @"C:\FCS\Destination";
            return ret;
        }

        public static IDirectoryReference UNCSource()
        {
            UNCDirectory ret = new UNCDirectory();
            ret.path = @"\\nbebarsalou\FCS\Source";
            ret.username = TestUser;
            ret.password = TestPassword;  //Doesn't appear to be necessary on local mount
            return ret;
        }

        public static IDirectoryReference UNCDestination()
        {
            UNCDirectory ret = new UNCDirectory();
            ret.path = @"\\nbebarsalou\FCS\Destination";
            ret.username = TestUser;
            ret.password = TestPassword;  //Doesn't appear to be necessary on local mount
            return ret;
        }

        public static IDirectoryReference FTPSource()
        {
            FTPDirectory ret = new FTPDirectory();
            ret.server = "localhost";
            ret.username = TestUser;
            ret.password = TestPassword;
            ret.path = "/Source";
            return ret;
        }

        public static IDirectoryReference FTPDestination()
        {
            FTPDirectory ret = new FTPDirectory();
            ret.server = "localhost";
            ret.username = TestUser;
            ret.password = TestPassword;
            ret.path = "/Destination";
            return ret;
        }

        public static IDirectoryReference SFTPSource()
        {
            SFTPDirectory ret = new SFTPDirectory();
            ret.server = "push.myinnerview.com";
            ret.username = TestUser;
            ret.password = TestPassword;
            ret.path = "/home/ebarsalou/test/source";
            return ret;
        }

        public static IDirectoryReference SFTPDestination()
        {
            SFTPDirectory ret = new SFTPDirectory();
            ret.server = "push.myinnerview.com";
            ret.username = TestUser;
            ret.password = TestPassword;
            ret.path = "/home/ebarsalou/test/destination";
            return ret;
        }

        public static IDirectoryReference[] Sources
        {
            get
            {
                IDirectoryReference[] ret = { LocalSource(), UNCSource(), FTPSource(), SFTPSource() };
                return ret;
            }
        }

        public static IDirectoryReference[] Destinations
        {
            get
            {
                IDirectoryReference[] ret = { LocalDestination(), UNCDestination(), FTPDestination(), SFTPDestination() };
                return ret;
            }
        }
    }

    // provide some utility functions
    public abstract class BaseTest
    {
        public string MakeTestFile(int size)
        {
            string tmp = System.IO.Path.GetTempFileName();
            FileStream file = System.IO.File.OpenWrite(tmp);
            //write 0123456789 into file until it is 'size' bytes long
            for (int ii = 0; ii < size; ii++)
            {
                file.WriteByte((byte)(48 + ii % 10));
            }
            file.Close();
            return tmp;
        }

        public bool FilesAreEqual(string file1, string file2)
        {
            int file1byte = 0;
            int file2byte = 0;
            FileStream fs1;
            FileStream fs2;

            if (file1 == file2)
            {
                return true;
            }

            fs1 = new FileStream(file1, FileMode.Open);
            fs2 = new FileStream(file2, FileMode.Open);

            if (fs1.Length != fs2.Length)
            {
                fs1.Close();
                fs2.Close();
                return false;
            }

            do
            {
                file1byte = fs1.ReadByte();
                file2byte = fs2.ReadByte();
            }
            while (file1byte == file2byte && file1byte != -1);

            fs1.Close();
            fs2.Close();

            return file1byte - file2byte == 0;
        }
    }

    // execute RunTest for every Destination in TestDirectories
    [TestClass]
    public abstract class SingleDirectoryTest : BaseTest
    {
        [TestMethod]
        public void RunTests()
        {
            foreach (var dest in TestDirectories.Destinations)
            {
                Debug.WriteLine("");
                Debug.WriteLine("Testing {0}", dest);
                RunTest(dest);
            }
        }

        public abstract void RunTest(IDirectoryReference dest);
    }

    // execute RunTest for every Source and Destination pair in TestDirectories
    [TestClass]
    public abstract class SourceDestTest : BaseTest
    {
        [TestMethod]
        public void RunTests()
        {
            foreach (var source in TestDirectories.Sources)
            {
                foreach (var dest in TestDirectories.Destinations)
                {
                    Debug.WriteLine("");
                    Debug.WriteLine("Testing {0} -> {1}", source, dest);
                    RunTest(source, dest);
                }
            }
        }

        public abstract void RunTest(IDirectoryReference source, IDirectoryReference dest);
    }
}
