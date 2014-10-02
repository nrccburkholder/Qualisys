using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.AccessControl;
using System.Text;

namespace NRC.Common.IO
{
    public abstract class FileUtils
    {
        public static FileInfo Rebase(FileInfo item, DirectoryInfo fromDir, DirectoryInfo toDir)
        {
            return new FileInfo(RebasePath(item.FullName, fromDir, toDir));
        }

        public static DirectoryInfo Rebase(DirectoryInfo item, DirectoryInfo fromDir, DirectoryInfo toDir)
        {
            return new DirectoryInfo(RebasePath(item.FullName, fromDir, toDir));
        }

        public static string RebasePath(string path, DirectoryInfo fromDir, DirectoryInfo toDir)
        {
            string relpath = RebaseAsRelativePath(path, fromDir);
            return Path.Combine(toDir.FullName, relpath);
        }

        public static string RebaseAsRelativePath(string path, DirectoryInfo baseDir)
        {
            if (!path.StartsWith(baseDir.FullName))
            {
                throw new Exception(String.Format("The item {0} does not seem to be located within {1}.", path, baseDir.FullName));
            }

            string relname = path.Substring(baseDir.FullName.Length);
            if (relname.StartsWith(Path.DirectorySeparatorChar.ToString()))
            {
                relname = relname.Substring(1);
            }
            return relname;
        }

        public static void RecursiveCopy(DirectoryInfo source, DirectoryInfo dest)
        {
            Action<FileInfo> fileCallback = delegate(FileInfo file) {
                file.CopyTo(Rebase(file, source, dest).FullName, true);
            };

            Action<DirectoryInfo> directoryCallback = delegate(DirectoryInfo dir) {
                Rebase(dir, source, dest).Create();
            };

            RecursiveTraverse(source, fileCallback, directoryCallback);
        }

        public static void RecursiveTraverse(DirectoryInfo baseDirectory, Action<FileInfo> fileCallback)
        {
            RecursiveTraverse(baseDirectory, fileCallback, null);
        }

        public static void RecursiveTraverse(DirectoryInfo baseDirectory, Action<FileInfo> fileCallback, Action<DirectoryInfo> directoryCallback)
        {
            foreach (FileInfo file in baseDirectory.GetFiles())
            {
                if (fileCallback != null)
                {
                    fileCallback(file);
                }
            }

            foreach (DirectoryInfo dir in baseDirectory.GetDirectories())
            {
                if (directoryCallback != null)
                {
                    directoryCallback(dir);
                }
                RecursiveTraverse(dir, fileCallback, directoryCallback);
            }
        }

        public static void SetDirectoryPermissions(DirectoryInfo dir, IEnumerable<string> writerReaderEntities, IEnumerable<string> readerOnlyEntities)
        {
            DirectorySecurity sec = new DirectorySecurity();

            foreach (string entity in writerReaderEntities ?? new string[] { })
            {
                sec.AddAccessRule(new FileSystemAccessRule(entity, FileSystemRights.FullControl,
                    InheritanceFlags.ContainerInherit | InheritanceFlags.ObjectInherit,
                    PropagationFlags.None, AccessControlType.Allow));
            }

            foreach (string entity in readerOnlyEntities ?? new string[] { })
            {
                sec.AddAccessRule(new FileSystemAccessRule(entity, FileSystemRights.ReadAndExecute | FileSystemRights.ListDirectory,
                    InheritanceFlags.ContainerInherit | InheritanceFlags.ObjectInherit,
                    PropagationFlags.None, AccessControlType.Allow));
            }

            dir.SetAccessControl(sec);
        }

        /// <summary>
        /// Return true if the directory exists and can be written to, false otherwise. This will create the directory
        /// if it doesn't exist.
        /// </summary>
        public static bool CanWriteDirectory(string dir)
        {
            try
            {
                // apparently you just have to try to write to it to see if you can
                if (!Directory.Exists(dir))
                {
                    Directory.CreateDirectory(dir);
                }
                string filename = Path.Combine(dir, Guid.NewGuid() + ".txt");
                StreamWriter writer = new StreamWriter(File.OpenWrite(filename));
                writer.WriteLine("This is a test, please delete.");
                writer.Close();
                File.Delete(filename);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}
