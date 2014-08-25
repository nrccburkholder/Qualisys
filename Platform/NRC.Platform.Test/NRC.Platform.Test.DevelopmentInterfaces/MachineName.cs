using System.Collections.Generic;
namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class MachineName
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Comments { get; set; }
        public int Port {get; set; }

        public MachineName()
        {
        }
        public MachineName(string name, string comments, int port)
        {
            Name = name;
            Comments = comments;
            Port = port;
        }
    }
}
