using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NRC.Platform.FileCopyService;

namespace NRC.Platform.FileCopyService.Test
{
    [TestClass]
    public class MoveFileTest : SourceDestTest
    {
        // put a file in source, and test DirectorySyncTask moving it over
        public override void RunTest(IDirectoryReference source, IDirectoryReference dest)
        {
            string tmpSource = MakeTestFile(16);
            string testfile = @"\subdir\test.txt";

            Debug.WriteLine("Putting test file to source");
            source.Prepare();
            if (source.Exists(testfile))
            {
                source.RemoveFile(testfile);
            }
            Assert.IsFalse(source.Exists(testfile), "File already appears to exist, can't be deleted.");
            source.PutFile(tmpSource, testfile);
            source.Unprepare();

            Debug.WriteLine("Executing DST.DoSync");
            DirectorySyncTask dst = new DirectorySyncTask();
            dst.source = source;
            dst.destination = dest;
            dst.backup = null;
            dst.action = "Move";
            dst.DoSync();

            Debug.WriteLine("Getting dest testfile");
            dest.Prepare();
            string tmpDest = System.IO.Path.GetTempFileName();
            dest.GetFile(testfile, tmpDest);
            dest.RemoveFile(testfile);
            dest.Unprepare();
            
            source.Prepare();
            bool exists = source.Exists(testfile);
            source.Unprepare();

            Debug.WriteLine("Done");
            Assert.IsFalse(exists, "File was not removed from original source: {0}", source);
            Assert.IsTrue(FilesAreEqual(tmpSource, tmpDest), "File did not transfer correctly from {0} to {1}", source, dest);

            System.IO.File.Delete(tmpSource);
            System.IO.File.Delete(tmpDest);
        }
    }
}
