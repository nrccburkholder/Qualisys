using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Platform.FileCopyService
{
    public class FileCopyException : Exception
    {
        public FileCopyException()
        {

        }

        public FileCopyException(string message)
            : base(message)
        {

        }

        public FileCopyException(string message, Exception inner)
            : base(message, inner)
        {

        }
    }
}
