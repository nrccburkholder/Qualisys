using System;

namespace NRC.Common.Store.API
{
    public interface IAPIPreservable
    {
        DateTime Created { get; set; }
        DateTime Modified { get; set; }
    }
}