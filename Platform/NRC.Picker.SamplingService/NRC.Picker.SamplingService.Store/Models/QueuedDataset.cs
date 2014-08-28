using System;

namespace NRC.Picker.SamplingService.Store.Models
{
    public enum State
    {
        New,
        Queued,
        Processing,
        Completed,
        Failed,
        Locked,
        Aborted
    }

    public partial class QueuedDataset
    {
        public State State
        {
            get
            {
                return (State)Enum.Parse(typeof(State), StateString);
            }
            set
            {
                QualisysAdapter.SetState(DatasetID, value);
            }
        }

        public string SampleTime
        {
            get
            {
                if (SampleStartTime != null && SampleEndTime != null)
                {
                    TimeSpan ts = (SampleEndTime - SampleStartTime).Value;
                    return ts.ToString(@"h\:mm\:ss");
                }

                return "";
            }
        }

        public int? RecordCount
        {
            get
            {
                return Dataset.RecordCount;
            }
        }

        public string ClientName
        {
            get
            {
                return Dataset.Study.Client.ClientName;
            }
        }

        public void SetStartTime()
        {
            QualisysAdapter.SetStartTime(DatasetID);
        }

        public void SetEndTime()
        {
            QualisysAdapter.SetEndTime(DatasetID);
        }

        public static QueuedDataset Enqueue(int datasetID)
        {
            QualisysAdapter.Enqueue(datasetID);
            return QualisysAdapter.GetQueuedDataset(datasetID);
        }

        public static void Dequeue(int datasetID)
        {
            QualisysAdapter.Dequeue(datasetID);
        }
    }
}
