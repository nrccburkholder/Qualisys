using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace NRC.Platform.FileCopyService.Test
{
    /// <summary>
    /// Do a basic Prepare, PutFile, GetFile, RemoveFile, Exists, Unprepare cycle
    /// </summary>
    [TestClass]
    public class SingleFileTest : SingleDirectoryTest
    {
        public override void RunTest(IDirectoryReference dest)
        {
            string tmpSource = MakeTestFile(16);
            string tmpDest = System.IO.Path.GetTempFileName();
            string testfile = @"\test.txt";

            dest.Prepare();
            if (dest.Exists(testfile))
            {
                dest.RemoveFile(testfile);
            }
            Assert.IsFalse(dest.Exists(testfile), "File already appears to exist, can't be deleted.");
            dest.PutFile(tmpSource, testfile);
            dest.GetFile(testfile, tmpDest);
            dest.RemoveFile(testfile);
            Assert.IsFalse(dest.Exists(testfile), "File did not appear to be removed from destination on clean up.");
            dest.Unprepare();

            Assert.IsTrue(FilesAreEqual(tmpSource, tmpDest), "File did not transfer correctly to/from {0}", dest);

            System.IO.File.Delete(tmpSource);
            System.IO.File.Delete(tmpDest);
        }
    }
}
