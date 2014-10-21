
namespace Nrc.CatalystExporter.Logging
{
    public class UserContext
    {
        public string UserName { get; set; }

        public UserContext(string userName)
        {
            this.UserName = userName;
        }
    }
}
