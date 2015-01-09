using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;

namespace QueueManagerLibrary.Objects
{
    public class SurveyTypes
    {

        private ImageIndexes mImageIndexes;

        public string Name { get; set; }

        public int Survey_ID { get; set; }

        public string ColorName { get; set; }

        public Color ObjectColor
        {

            get
            {
                if (ColorName != string.Empty)
                {
                    return Color.FromName(ColorName);
                }
                else throw new Exception("ColorName is not set");
            }

        }


        public ImageIndexes ImageIndexes
        {
            get { return mImageIndexes; }
            set { mImageIndexes = value; }
        }

        public SurveyTypes()
        {
            mImageIndexes = new ImageIndexes();
        }

        public SurveyTypes(string name, string colorName)
        {
            Name = name;
            ColorName = colorName;
            mImageIndexes = new ImageIndexes();
        }


    }
}
