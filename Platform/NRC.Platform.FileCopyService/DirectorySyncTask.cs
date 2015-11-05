using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Diagnostics;
using System.IO;

using NRC.Common;
using NRC.Common.Configuration;

namespace NRC.Platform.FileCopyService
{
    public class DirectorySyncTask : ConfigSection
    {
        [ConfigUse("Source")]
        public DirectoryReferenceManager sourceTag = null;
        public IDirectoryReference source = null;

        [ConfigUse("Destination")]
        public DirectoryReferenceManager destinationTag = null;
        public IDirectoryReference destination = null;

        [ConfigUse("Backup", IsOptional=true, Default="null")]
        public DirectoryReferenceManager backupTag = null;
        public IDirectoryReference backup = null;

        [ConfigUse("Filename", IsOptional = true, Default = "")]
        public string filename = "";

        [ConfigUse("Action")]   //either "Move", "Copy", or "Overwrite"
        public string action = "";

        [ConfigUse("FileMatch", IsOptional = true, Default = "")]
        public string fileMatch = "";

        [ConfigUse("ToFlatLayout", IsOptional = true, Default = "false")]
        public bool toFlatLayout = false;

        [ConfigUse("TimeStamp", IsOptional = true, Default = "")]
        public string timeStamp = "";

        [ConfigUse("Interval", IsOptional = true, Default = "null")]
        public IntervalManager interval;

        DateTime lastRun = DateTime.MinValue;

        public bool ShouldRun()
        {
            if (interval == null)
            {
                //didn't specify any interval, run on every pass
                return true;
            }
            IInterval which = interval.Which();
            return which.ShouldRun(lastRun, DateTime.Now);
        }

        public void OnRunOnce()
        {
            //Set up references to source, dest, and backup
            source = sourceTag.Which();
            destination = destinationTag.Which();
            if (backupTag != null)
            {
                backup = backupTag.Which();
            }
            else
            {
                backup = null;
            }

            if (ShouldRun())
            {
                DoSync();
            }
        }

        public void DoSync()
        {
            Logger logger = Program.Logger();
            Debug.WriteLine("DoSync Enter");
            //if fileMatch is unset, match any filename
            if (fileMatch == "" ) {
                fileMatch = ".";
            }
            Regex fileMatchRE = new Regex(fileMatch);

            source.Prepare();
            //whether or not dest and backup have been prepared
            bool havePrepared = false, hadError = false;
            
            IEnumerable<string> files = source.ListFiles();
            foreach (string file in files)
            {
                string fromFullFilename = source.FullFilename(file);
                string tmpFilename = "";
                string destFullFilename = "";
                string backupFullFilename = "";
                try
                {
                    Debug.WriteLine("DoSync found: " + fromFullFilename);

                    //filter files based on filematch
                    Match match = fileMatchRE.Match(file);
                    if (!match.Success)
                    {
                        Debug.WriteLine("DoSync did not match: " + file);
                        continue;
                    }

                    Debug.WriteLine("DoSync preparing");
                    //make sure dest and backup have been prepared
                    if (!havePrepared)
                    {
                        try
                        {
                            destination.Prepare();
                            if (backup != null)
                            {
                                backup.Prepare();
                            }
                            havePrepared = true;
                        }
                        catch (Exception ex)
                        {
                            var detailEx = CreateDetailException(ex, action, fromFullFilename, destFullFilename, backupFullFilename);
                            Program.Log(detailEx);
                            
                            hadError = true;
                            break;
                        }
                    }
                    
                    //generate filenames from original + filematch + toflatlayout [+ timestamp]
                    string rewriteFilename;
                    if (string.IsNullOrEmpty(filename))
                    {
                        rewriteFilename = file;
                    }
                    else
                    {
                        rewriteFilename = filename;
                    }
                    string destFilename = MakeDestinationFilename(rewriteFilename, match.Groups);
                    destFullFilename = destination.FullFilename(destFilename);
                    string backupFilename = MakeBackupFilename(rewriteFilename, match.Groups);
                    backupFullFilename = backup == null ? "" : backup.FullFilename(backupFilename);
                    Debug.WriteLine("DoSync to: " + destFilename);
                    
                    //check exists/overwrite
                    if (destination.Exists(destFilename))
                    {
                        if (action == "Overwrite")
                        {
                            destination.RemoveFile(destFilename);
                        }
                        else
                        {
                            logger.Error("Failed to move/copy file: " + destFullFilename + " already exists");
                            Debug.WriteLine("DoSync file already exists: " + destFullFilename);
                            continue;
                        }
                    }

                    //check exists/overwrite for backup
                    if (backup != null && backup.Exists(backupFilename))
                    {
                        Debug.WriteLine("DoSync backup file already exists: " + backupFilename);
                        logger.Error("Failed to backup file: " + backupFullFilename + " already exists");
                        continue;
                    }
                    
                    //copy source to local
                    tmpFilename = System.IO.Path.GetTempFileName();
                    Debug.WriteLine("DoSync tmp: " + tmpFilename);
                    source.GetFile(file, tmpFilename);

                    if (backup != null)
                    {
                        //copy local to backup
                        logger.Info(string.Format("Backing up {0} to {1}", fromFullFilename, backupFullFilename));
                        backup.PutFile(tmpFilename, backupFilename);
                    }
                    
                    //copy local to destination
                    try
                    {
                        if (action == "Move" || action == "Overwrite") {
                            logger.Info(string.Format("Moving {0} to {1}", fromFullFilename, destFullFilename));
                        }
                        else
                        {
                            logger.Info(string.Format("Copying {0} to {1}", fromFullFilename, destFullFilename));
                        }
                        destination.PutFile(tmpFilename, destFilename);
                    }
                    catch (Exception ex)
                    {
                        var detailEx = CreateDetailException(ex, action, fromFullFilename, destFullFilename, backupFullFilename);
                        Program.Log(detailEx);

                        if (backup != null)
                        {
                            backup.RemoveFile(backupFilename);
                        }
                    }

                    //remove temp file
                    Debug.WriteLine("DoSync deleting: " + tmpFilename);
                    System.IO.File.Delete(tmpFilename);

                    //remove from source if action=move or overwrite
                    if (action == "Move" || action == "Overwrite")
                    {
                        Debug.WriteLine("DoSync removing original");
                        source.RemoveFile(file);
                    }
                }
                catch (Exception ex)
                {
                    var detailEx = CreateDetailException(ex, action, fromFullFilename, destFullFilename, backupFullFilename);
                    Program.Log(detailEx);
                    hadError = true;
                }
                finally
                {
                    if(!string.IsNullOrEmpty(tmpFilename))
                    {
                        System.IO.File.Delete(tmpFilename);
                    }
                }
            }

            source.Unprepare();
            if (havePrepared)
            {
                destination.Unprepare();
                if (backup != null)
                {
                    backup.Unprepare();
                }
            }

            // exited without error, so set lastRun
            if (!hadError)
            {
                lastRun = DateTime.Now;
            }
        }

        // Make destination filename from fromFilename
        //   replaces {0} like directives with captures from FileMatch
        //   strips subdirectories if toFlatlayout is true
        public string MakeDestinationFilename(string fromFilename, GroupCollection replacements)
        {
            if (toFlatLayout)
            {
                fromFilename = "\\" + Path.GetFileName(fromFilename);
            }
            for (int ii = 0; ii < replacements.Count; ii++)
            {
                Group group = replacements[ii];
                fromFilename = fromFilename.Replace("{" + ii.ToString() + "}", group.Value);
            }
            return fromFilename;
        }

        // Make backup filename from fromFilename
        //   same as MakeDestinationFilename, but adds timestamp before extension
        public string MakeBackupFilename(string fromFilename, GroupCollection replacements)
        {
            string dest = MakeDestinationFilename(fromFilename, replacements);
            string ext = Path.GetExtension(dest);
            if (!string.IsNullOrEmpty(ext))
            {
                dest = dest.Remove(dest.Length - ext.Length);
            }
            string curTimeStamp = "";
            if (!string.IsNullOrEmpty(timeStamp))
            {
                curTimeStamp = DateTime.Now.ToString(timeStamp);
            }
            string backupFilename = dest + curTimeStamp + ext;
            return backupFilename;
        }

        private Exception CreateDetailException(Exception ex, string action, string source, string destination, string backup)
        {
            return new FileCopyException(string.Format("Error doing {0} from '{1}' to '{2}' with backup '{3}'.", action, source, destination, backup), ex);
        }
    }
}
