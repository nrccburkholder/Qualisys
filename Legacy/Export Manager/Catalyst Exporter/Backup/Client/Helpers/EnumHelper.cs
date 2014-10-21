using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace Nrc.CatalystExporter.ExportClient.Helpers
{
    public static class EnumHelper
    {
        public static List<SelectListItem> GetSelectList<TEnum>(params TEnum[] ignoreList)
        {
            List<SelectListItem> enumList = new List<SelectListItem>();
            foreach (TEnum data in Enum.GetValues(typeof(TEnum)))
            {
                if (!ignoreList.Contains(data))
                {
                    enumList.Add(new SelectListItem
                    {
                        Text = data.ToString().Replace("_", " "),
                        Value = ((int)Enum.Parse(typeof(TEnum), data.ToString())).ToString()
                    });
                }
            }

            return enumList;
        }

        public static string IntToFormattedString<T>(int value)
        {
            string name = Enum.GetName(typeof(T), value);
            name += "";
            return name.Replace("_", " ");
        }

        public static int StringToInt<T>(string value)
        {
            return (int)Enum.Parse(typeof(T), value);
        }

        public static T Parse<T>(string value)
        {
            return (T)Enum.Parse(typeof(T), value);
        }
    }
}
