using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NRC.Common.Configuration;

namespace NRC.Platform.FileCopyService
{
    /// <summary>
    /// A reference to a directory on any supported server or protocol.
    /// All remoate filenames returned and accepted are relative to the directory in the format: \path\to\file.ext
    /// </summary>
    public interface IDirectoryReference
    {
        /// <summary>
        /// Get any resources needed for interacting with referenced directory.
        /// </summary>
        void Prepare();

        /// <summary>
        /// Release any resources held by Prepare.
        /// Shouldn't fail if Prepare wasn't called.
        /// </summary>
        void Unprepare();

        /// <summary>
        /// Get files available for moving.
        /// </summary>
        /// <returns>"\subdir\file.ext" formatted paths.  Paths are relative to referenced directory.</returns>
        IEnumerable<string> ListFiles();

        /// <summary>
        /// Return true if file already exists on filesystem.
        /// </summary>
        /// <param name="file">Filename of the remote file, relative to the referenced directory.</param>
        /// <returns></returns>
        bool Exists(string file);

        /// <summary>
        /// Make a copy of the remote file to a temp file on the local system.
        /// Overwrite by default.
        /// </summary>
        /// <param name="local">Filename of the local temporary file.</param>
        /// <param name="file">Filename of the remote file, relative to the referenced directory.</param>
        void GetFile(string file, string local);


        /// <summary>
        /// Put a copy of a local temp file on the remote system.
        /// Should create directory if it doesn't exist.
        /// </summary>
        /// <param name="local">Filename of the local temporary file.</param>
        /// <param name="file">Filename of the remote file, relative to the referenced directory.</param>
        void PutFile(string local, string file);

        /// <summary>
        /// Remove the file from the remote system.
        /// </summary>
        /// <param name="file">Filename of the remote file, relative to the referenced directory.</param>
        void RemoveFile(string file);

        /// <summary>
        /// Implementation dependant description that gives context to a relative path
        /// </summary>
        /// <param name="file">Filename of the remote file, relative to the referenced directory.</param>
        /// <example>FullFilename("/relative/path") might yield "sftp@127.0.0.1:/home/user/relative/path"</example>
        string FullFilename(string file);
    }
}
