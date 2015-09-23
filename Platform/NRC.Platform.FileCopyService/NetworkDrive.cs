using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.InteropServices;

namespace NRC.Platform.FileCopyService
{
    public class NetworkDrive
    {
        [DllImport("mpr.dll")]
        private static extern int WNetAddConnection2(NETRESOURCE lpNetResource, string lpPassword, string lpUsername, int dwFlags);

        [DllImport("mpr.dll")]
        public static extern int WNetCancelConnection2(string lpName, Int32 dwFlags, bool fForce);

        private const int CONNECT_UPDATE_PROFILE    = 0x00000001;
        private const int CONNECT_TEMPORARY         = 0x00000004;

        private const int NO_ERROR = 0;
        private const int NOT_CONNECTED = 2250;
        private const int ERROR_SESSION_CREDENTIAL_CONFLICT = 1219;

        public enum ResourceScope
        {
            RESOURCE_CONNECTED = 1,
            RESOURCE_GLOBALNET,
            RESOURCE_REMEMBERED,
            RESOURCE_RECENT,
            RESOURCE_CONTEXT
        }

        public enum ResourceType
        {
            RESOURCETYPE_ANY,
            RESOURCETYPE_DISK,
            RESOURCETYPE_PRINT,
            RESOURCETYPE_RESERVED
        }

        public enum ResourceUsage
        {
            RESOURCEUSAGE_CONNECTABLE = 0x00000001,
            RESOURCEUSAGE_CONTAINER = 0x00000002,
            RESOURCEUSAGE_NOLOCALDEVICE = 0x00000004,
            RESOURCEUSAGE_SIBLING = 0x00000008,
            RESOURCEUSAGE_ATTACHED = 0x00000010,
            RESOURCEUSAGE_ALL = (RESOURCEUSAGE_CONNECTABLE | RESOURCEUSAGE_CONTAINER | RESOURCEUSAGE_ATTACHED),
        }

        public enum ResourceDisplayType
        {
            RESOURCEDISPLAYTYPE_GENERIC,
            RESOURCEDISPLAYTYPE_DOMAIN,
            RESOURCEDISPLAYTYPE_SERVER,
            RESOURCEDISPLAYTYPE_SHARE,
            RESOURCEDISPLAYTYPE_FILE,
            RESOURCEDISPLAYTYPE_GROUP,
            RESOURCEDISPLAYTYPE_NETWORK,
            RESOURCEDISPLAYTYPE_ROOT,
            RESOURCEDISPLAYTYPE_SHAREADMIN,
            RESOURCEDISPLAYTYPE_DIRECTORY,
            RESOURCEDISPLAYTYPE_TREE,
            RESOURCEDISPLAYTYPE_NDSCONTAINER
        }

        [StructLayout(LayoutKind.Sequential)]
        private class NETRESOURCE
        {
            public ResourceScope dwScope = 0;
            public ResourceType dwType = 0;
            public ResourceDisplayType dwDisplayType = 0;
            public ResourceUsage dwUsage = 0;
            public string lpLocalName = null;
            public string lpRemoteName = null;
            public string lpComment = null;
            public string lpProvider = null;
        }

        public void MapNetworkDrive(string unc, string user, string password)
        {
            NETRESOURCE myNetResource = new NETRESOURCE();
            myNetResource.lpRemoteName = unc;
            //myNetResource.lpLocalName = drive;
            myNetResource.lpLocalName = null;
            myNetResource.lpProvider = null;
            myNetResource.dwType = ResourceType.RESOURCETYPE_DISK;

            //int result = WNetAddConnection2(myNetResource, password, user, CONNECT_TEMPORARY);
            int result = WNetAddConnection2(myNetResource, password, user, 0);
            if (result != NO_ERROR)
            {
                throw new Exception(string.Format("WNetAddConnection2 returned {0} when attempting to mount {1}", result, unc));
            }
        }

        public void UnmapNetworkDrive(string drive)
        {
            //int result = WNetCancelConnection2(drive, 0, true);
            int result = WNetCancelConnection2(drive, CONNECT_UPDATE_PROFILE, true);
            if (result != NO_ERROR && result != NOT_CONNECTED)
            {
                throw new Exception( string.Format("WNetCancelConnection2 returned {0}", result) );
            }
        }

    }
}