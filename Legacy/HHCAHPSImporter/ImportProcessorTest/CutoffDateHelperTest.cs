using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using HHCAHPSImporter.ImportProcessor;

namespace ImportProcessorTest
{
    [TestClass]
    public class CutoffDateHelperTest
    {
        #region Helpers

        private void AssertPastCutoffQ1(DateTime q1Cutoff, int sampleMonth, int sampleYear, DateTime current, bool expected)
        {
            var result = CutoffDateHelper.IsPastCutoff(q1Cutoff, DateTime.MinValue, DateTime.MinValue, DateTime.MinValue, sampleMonth, sampleYear, current);
            Assert.AreEqual(expected, result);
        }

        private void AssertPastCutoffQ2(DateTime q2Cutoff, int sampleMonth, int sampleYear, DateTime current, bool expected)
        {
            var result = CutoffDateHelper.IsPastCutoff(DateTime.MinValue, q2Cutoff, DateTime.MinValue, DateTime.MinValue, sampleMonth, sampleYear, current);
            Assert.AreEqual(expected, result);
        }

        private void AssertPastCutoffQ3(DateTime q3Cutoff, int sampleMonth, int sampleYear, DateTime current, bool expected)
        {
            var result = CutoffDateHelper.IsPastCutoff(DateTime.MinValue, DateTime.MinValue, q3Cutoff, DateTime.MinValue, sampleMonth, sampleYear, current);
            Assert.AreEqual(expected, result);
        }

        private void AssertPastCutoffQ4(DateTime q4Cutoff, int sampleMonth, int sampleYear, DateTime current, bool expected)
        {
            var result = CutoffDateHelper.IsPastCutoff(DateTime.MinValue, DateTime.MinValue, DateTime.MinValue, q4Cutoff, sampleMonth, sampleYear, current);
            Assert.AreEqual(expected, result);
        }

        #endregion Helpers

        #region IsPastCutoff

        [TestMethod]
        public void IsPastCutoff_CutoffJuly15SampleJan2018CurrentJuly15_ReturnsFalse()
        {
            AssertPastCutoffQ1(new DateTime(2016, 7, 15), 1, 2018, new DateTime(2018, 7, 15), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJuly15SampleJan2018CurrentJuly15Noon_ReturnsFalse()
        {
            AssertPastCutoffQ1(new DateTime(2016, 7, 15), 1, 2018, new DateTime(2018, 7, 15, 12, 0, 0), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJuly15SampleJan2018CurrentJuly16_ReturnsTrue()
        {
            AssertPastCutoffQ1(new DateTime(2016, 7, 15), 1, 2018, new DateTime(2018, 7, 16), true);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJuly15SampleFeb2018CurrentJuly15_ReturnsFalse()
        {
            AssertPastCutoffQ1(new DateTime(2016, 7, 15), 2, 2018, new DateTime(2018, 7, 15), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJuly15SampleFeb2018CurrentJuly15Noon_ReturnsFalse()
        {
            AssertPastCutoffQ1(new DateTime(2016, 7, 15), 2, 2018, new DateTime(2018, 7, 15, 12, 0, 0), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJuly15SampleFeb2018CurrentJuly16_ReturnsTrue()
        {
            AssertPastCutoffQ1(new DateTime(2016, 7, 15), 2, 2018, new DateTime(2018, 7, 16), true);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJuly15SampleMar2018CurrentJuly15_ReturnsFalse()
        {
            AssertPastCutoffQ1(new DateTime(2016, 7, 15), 3, 2018, new DateTime(2018, 7, 15), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJuly15SampleMar2018CurrentJuly15Noon_ReturnsFalse()
        {
            AssertPastCutoffQ1(new DateTime(2016, 7, 15), 3, 2018, new DateTime(2018, 7, 15, 12, 0, 0), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJuly15SampleMar2018CurrentJuly16_ReturnsTrue()
        {
            AssertPastCutoffQ1(new DateTime(2016, 7, 15), 3, 2018, new DateTime(2018, 7, 16), true);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffOct15SampleApr2018CurrentOct15_ReturnsFalse()
        {
            AssertPastCutoffQ2(new DateTime(2016, 10, 15), 4, 2018, new DateTime(2018, 10, 15), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffOct15SampleApr2018CurrentOct15Noon_ReturnsFalse()
        {
            AssertPastCutoffQ2(new DateTime(2016, 10, 15), 4, 2018, new DateTime(2018, 10, 15, 12, 0, 0), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffOct15SampleApr2018CurrentOct16_ReturnsTrue()
        {
            AssertPastCutoffQ2(new DateTime(2016, 10, 15), 4, 2018, new DateTime(2018, 10, 16), true);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffOct15SampleMay2018CurrentOct15_ReturnsFalse()
        {
            AssertPastCutoffQ2(new DateTime(2016, 10, 15), 5, 2018, new DateTime(2018, 10, 15), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffOct15SampleMay2018CurrentOct15Noon_ReturnsFalse()
        {
            AssertPastCutoffQ2(new DateTime(2016, 10, 15), 5, 2018, new DateTime(2018, 10, 15, 12, 0, 0), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffOct15SampleMay2018CurrentOct16_ReturnsTrue()
        {
            AssertPastCutoffQ2(new DateTime(2016, 10, 15), 5, 2018, new DateTime(2018, 10, 16), true);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffOct15SampleJun2018CurrentOct15_ReturnsFalse()
        {
            AssertPastCutoffQ2(new DateTime(2016, 10, 15), 6, 2018, new DateTime(2018, 10, 15), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffOct15SampleJun2018CurrentOct15Noon_ReturnsFalse()
        {
            AssertPastCutoffQ2(new DateTime(2016, 10, 15), 6, 2018, new DateTime(2018, 10, 15, 12, 0, 0), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffOct15SampleJun2018CurrentOct16_ReturnsTrue()
        {
            AssertPastCutoffQ2(new DateTime(2016, 10, 15), 6, 2018, new DateTime(2018, 10, 16), true);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJan15SampleJul2018CurrentJan15_ReturnsFalse()
        {
            AssertPastCutoffQ3(new DateTime(2017, 1, 15), 7, 2018, new DateTime(2019, 1, 15), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJan15SampleJul2018CurrentJan15Noon_ReturnsFalse()
        {
            AssertPastCutoffQ3(new DateTime(2017, 1, 15), 7, 2018, new DateTime(2019, 1, 15, 12, 0, 0), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJan15SampleJul2018CurrentJan16_ReturnsTrue()
        {
            AssertPastCutoffQ3(new DateTime(2017, 1, 15), 7, 2018, new DateTime(2019, 1, 16), true);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJan15SampleAug2018CurrentJan15_ReturnsFalse()
        {
            AssertPastCutoffQ3(new DateTime(2017, 1, 15), 8, 2018, new DateTime(2019, 1, 15), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJan15SampleAug2018CurrentJan15Noon_ReturnsFalse()
        {
            AssertPastCutoffQ3(new DateTime(2017, 1, 15), 8, 2018, new DateTime(2019, 1, 15, 12, 0, 0), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJan15SampleAug2018CurrentJan16_ReturnsTrue()
        {
            AssertPastCutoffQ3(new DateTime(2017, 1, 15), 8, 2018, new DateTime(2019, 1, 16), true);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJan15SampleSep2018CurrentJan15_ReturnsFalse()
        {
            AssertPastCutoffQ3(new DateTime(2017, 1, 15), 9, 2018, new DateTime(2019, 1, 15), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJan15SampleSep2018CurrentJan15Noon_ReturnsFalse()
        {
            AssertPastCutoffQ3(new DateTime(2017, 1, 15), 9, 2018, new DateTime(2019, 1, 15, 12, 0, 0), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffJan15SampleSep2018CurrentJan16_ReturnsTrue()
        {
            AssertPastCutoffQ3(new DateTime(2017, 1, 15), 9, 2018, new DateTime(2019, 1, 16), true);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffApr15SampleOct2018CurrentApr15_ReturnsFalse()
        {
            AssertPastCutoffQ4(new DateTime(2017, 4, 15), 10, 2018, new DateTime(2019, 4, 15), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffApr15SampleOct2018CurrentApr15Noon_ReturnsFalse()
        {
            AssertPastCutoffQ4(new DateTime(2017, 4, 15), 10, 2018, new DateTime(2019, 4, 15, 12, 0, 0), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffApr15SampleOct2018CurrentApr16_ReturnsTrue()
        {
            AssertPastCutoffQ4(new DateTime(2017, 4, 15), 10, 2018, new DateTime(2019, 4, 16), true);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffApr15SampleNov2018CurrentApr15_ReturnsFalse()
        {
            AssertPastCutoffQ4(new DateTime(2017, 4, 15), 11, 2018, new DateTime(2019, 4, 15), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffApr15SampleNov2018CurrentApr15Noon_ReturnsFalse()
        {
            AssertPastCutoffQ4(new DateTime(2017, 4, 15), 11, 2018, new DateTime(2019, 4, 15, 12, 0, 0), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffApr15SampleNov2018CurrentApr16_ReturnsTrue()
        {
            AssertPastCutoffQ4(new DateTime(2017, 4, 15), 11, 2018, new DateTime(2019, 4, 16), true);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffApr15SampleDec2018CurrentApr15_ReturnsFalse()
        {
            AssertPastCutoffQ4(new DateTime(2017, 4, 15), 12, 2018, new DateTime(2019, 4, 15), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffApr15SampleDec2018CurrentApr15Noon_ReturnsFalse()
        {
            AssertPastCutoffQ4(new DateTime(2017, 4, 15), 12, 2018, new DateTime(2019, 4, 15, 12, 0, 0), false);
        }

        [TestMethod]
        public void IsPastCutoff_CutoffApr15SampleDec2018CurrentApr16_ReturnsTrue()
        {
            AssertPastCutoffQ4(new DateTime(2017, 4, 15), 12, 2018, new DateTime(2019, 4, 16), true);
        }

        #endregion IsPastCutoff
    }
}
