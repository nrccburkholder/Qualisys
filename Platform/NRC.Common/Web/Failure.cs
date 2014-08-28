using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Common.Web
{
    public enum FailureType { Internal, External };

    /// <summary>
    /// This class is returned by API methods when a failure has occurred.
    /// </summary>
    public class Failure
    {
        public Failure()
        {
            IsFailure = true;
        }

        public Failure(string message, FailureType type) : this()
        {
            this.Message = message;
            this.Type = type;
        }

        // this property ensures that this class is (de)serialized correctly; without it, a failure object might be mistaken for another kind of
        // object by the serializer (since Type and Message are relatively generic field names)
        public bool IsFailure { get; set; } 
        public FailureType Type { get; set; }
        public string Message { get; set; }
    }
}
