using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.DataAnnotations;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class RunQueue
    {
        public int QId { get; set; }

        [Required(ErrorMessage = "Test run Template id is required")] 
        public int TestrunTemplateId { get; set; }

        public string TestrunTemplateDescription { get; set; }

        [StringLength(100)]
        public string Description {get; set; }
        
        public bool IsActive { get; set; }

        public int CasesToRun { get; set; }

        public bool ShowResultInWebApp { get; set; }

        [Required(ErrorMessage = "Start time is required")]
        [DataType(DataType.DateTime)]
        public DateTime FromDate { get; set; }

        [DataType(DataType.DateTime)]
        public DateTime? ToDate { get; set; }

        [DataType(DataType.DateTime)]
        public DateTime RunAt { get; set; }

        [DataType(DataType.DateTime)]
        public DateTime? PrevFireTime { get; set; }

        [DataType(DataType.DateTime)]
        public DateTime? NextFireTime { get; set; }

        public string Recur { get; set; }

        [Required(ErrorMessage = "Minute is required")]
        [Range(1, int.MaxValue, ErrorMessage = "Minute must be greater than 0")]
        public int T_Minute { get; set; }

        [Range(0, int.MaxValue, ErrorMessage = "Week must be greater than 0")]
        public int W_week { get; set; }

        public string W_days { get; set; }

        public int M_option { get; set; }

        [Required(ErrorMessage = "Day is required")]
        [Range(1, int.MaxValue, ErrorMessage = "Day must be greater than 0")]
        public int M_day { get; set; }

        [Required(ErrorMessage = "Month is required")]
        [Range(1, int.MaxValue, ErrorMessage = "Month must be greater than 0")]
        public int M_month1 { get; set; }
        public int M_which { get; set; }
        public int M_weekday { get; set; }

        [Required(ErrorMessage = "Month is required")]
        [Range(1, int.MaxValue, ErrorMessage = "Month must be greater than 0")]
        public int M_month2 { get; set; }

        public DateTime ModifiedDate { get; set; }
        public string UserId { get; set; }
        public bool email { get; set; }

        [DataType(DataType.EmailAddress)]
        public string EmailAddress { get; set; }

        public int RunEnvironmentId { get; set; }
        public string EnvName { get; set; }
        public string Browser { get; set; }

        public int MachineId { get; set; }
        public string MachineName { get; set; }
        public string Status { get; set; }

        [Range(1, 20, ErrorMessage = "Max threads must be between 1 and 20")]
        public int MaxThreads { get; set; }

        public RunQueue()
        {
            // default values
            Recur = "W";
            email = false;
            IsActive = true;
            FromDate = DateTime.Now;
            ToDate = FromDate.AddMonths(1);
            Status = "";
            MaxThreads = 1;
        }

        public string GetRecurrenceString()
        {
            if (QId <= 0)
                return "";

            string tmpStr, recurExp;
            switch (Recur)
            {
                case "T":
                    recurExp = "Occurs every " + T_Minute.ToString() + " minutes";
                    break;

                case "W":
                default:
                    if (W_week > 1)
                        recurExp = "Occurs every " + W_week.ToString() + " weeks on " + GetDayNames(W_days, -1);
                    else
                        recurExp = "Occurs every week on " + GetDayNames(W_days, -1);
                    break;

                case "M":
                    if (M_option == 1)
                    {
                        tmpStr = M_day.ToString();
                        if (M_month1 > 1)
                            recurExp = "Occurs day " + tmpStr + " of every " + M_month1.ToString() + " month";
                        else
                            recurExp = "Occurs day " + tmpStr + " of every month";
                    }
                    else
                    {
                        if (M_month2 > 1)
                            recurExp = "Occurs the " + GetNumberString(M_which) + " " + GetDayNames("", M_weekday) + " of every " + M_month2.ToString() + " month";
                        else
                            recurExp = "Occurs the " + GetNumberString(M_which) + " " + GetDayNames("", M_weekday) + " of every month";
                    }

                    break;
            }

            recurExp = recurExp + " effective " + FromDate.ToString("MM/dd/yyyy") + " until " + ToDate.Value.ToString("MM/dd/yyyy") + " at " + RunAt.ToString("HH:mm");

            return recurExp;
        }

        public string GetCronExpression()
        {
            // convert the schedule to a crontab expression
            string cronExp = "";
            string s;
            switch (Recur)
            {
                case "T": // minute
                    s = "0/" + T_Minute.ToString();
                    cronExp = "0 " + s + " * * * ?";
                    break;

                case "W": // weekly
                    s = GetWeekNames(-1, W_days);
                    cronExp = "0 " + RunAt.Minute.ToString() + " " + RunAt.Hour.ToString() + " ? * " + s;
                    break;

                case "M": // monthly
                    if (M_option == 1)
                    {
                        cronExp = "0 " + RunAt.Minute.ToString() + " " +
                            RunAt.Hour.ToString() + " " + M_day.ToString() + " 1/" +
                            M_month1.ToString() + " ? *";
                    }
                    else
                    {
                        if (M_which > 3)
                            cronExp = "0 " + RunAt.Minute.ToString() + " " +
                                RunAt.Hour.ToString() + " ? 1/" + M_month2.ToString() + " " +
                                GetWeekNames(M_weekday, null).ToString() + "L *";
                        else
                            cronExp = "0 " + RunAt.Minute.ToString() + " " +
                                RunAt.Hour.ToString() + " ? 1/" + M_month2.ToString() + " " +
                                GetWeekNames(M_weekday, null).ToString() + "#" + (M_which + 1).ToString() + " *";
                    }
                    break;
            }
            return cronExp;
        }

        private string GetDayNames(string pat, int num)
        {
            string[] days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };
            string[] dayNames = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", };
            StringBuilder sb = new StringBuilder();

            if (num >= 0)
                sb.Append(dayNames[num]);
            else
            {
                for (int i = 0; i < pat.Length; i++)
                {
                    if (pat[i] == '1')
                    {
                        if (sb.Length > 0)
                            sb.Append(", " + days[i]);
                        else
                            sb.Append(days[i]);
                    }
                }
            }
            return sb.ToString();
        }

        private string GetMonthNames(int num)
        {
            string[] monthNames = { "January", "Febraury", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" };
            return monthNames[num - 1];
        }

        private string GetNumberString(int num)
        {
            string[] names = { "first", "second", "third", "fourth" };
            if (num < names.Length)
                return names[num];
            else
                return "last";
        }

        private string GetWeekNames(int num, string wDays)
        {
            string[] days = { "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT" };
            if (num >= 0)
            {
                return days[num];
            }
            else
            {
                if (wDays == null)
                    return ("*");

                StringBuilder sb = new StringBuilder();

                for (int i = 0; i < 7; i++)
                {
                    if (wDays.Substring(i, 1) == "1")
                    {
                        if (sb.Length <= 0)
                            sb.Append(days[i]);
                        else
                            sb.Append("," + days[i]);
                    }
                }
                return sb.ToString();
            }
        }
    }
}
