using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using HHCAHPSImporter.ImportProcessor;

namespace ImportProcessorTest
{
    [TestClass]
    public class CutoffDateHelperTest
    {
        #region Helpers

        private void AssertQuarter(int sampleMonth, CutoffDateHelper.Quarter expected)
        {
            var quarter = CutoffDateHelper.GetQuarter(sampleMonth);
            Assert.AreEqual(expected, quarter);
        }

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

        #region GetQuarter

        [TestMethod]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void GetQuarter_0_ThrowsArgumentOutOfRangeException()
        {
            CutoffDateHelper.GetQuarter(0);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void GetQuarter_13_ThrowsArgumentOutOfRangeException()
        {
            CutoffDateHelper.GetQuarter(13);
        }

        [TestMethod]
        public void GetQuarter_1_ReturnsQ1()
        {
            AssertQuarter(1, CutoffDateHelper.Quarter.Q1);
        }

        [TestMethod]
        public void GetQuarter_2_ReturnsQ1()
        {
            AssertQuarter(2, CutoffDateHelper.Quarter.Q1);
        }

        [TestMethod]
        public void GetQuarter_3_ReturnsQ1()
        {
            AssertQuarter(3, CutoffDateHelper.Quarter.Q1);
        }

        [TestMethod]
        public void GetQuarter_4_ReturnsQ2()
        {
            AssertQuarter(4, CutoffDateHelper.Quarter.Q2);
        }

        [TestMethod]
        public void GetQuarter_5_ReturnsQ2()
        {
            AssertQuarter(5, CutoffDateHelper.Quarter.Q2);
        }

        [TestMethod]
        public void GetQuarter_6_ReturnsQ2()
        {
            AssertQuarter(6, CutoffDateHelper.Quarter.Q2);
        }

        [TestMethod]
        public void GetQuarter_7_ReturnsQ3()
        {
            AssertQuarter(7, CutoffDateHelper.Quarter.Q3);
        }

        [TestMethod]
        public void GetQuarter_8_ReturnsQ3()
        {
            AssertQuarter(8, CutoffDateHelper.Quarter.Q3);
        }

        [TestMethod]
        public void GetQuarter_9_ReturnsQ3()
        {
            AssertQuarter(9, CutoffDateHelper.Quarter.Q3);
        }

        [TestMethod]
        public void GetQuarter_10_ReturnsQ4()
        {
            AssertQuarter(10, CutoffDateHelper.Quarter.Q4);
        }

        [TestMethod]
        public void GetQuarter_11_ReturnsQ4()
        {
            AssertQuarter(11, CutoffDateHelper.Quarter.Q4);
        }

        [TestMethod]
        public void GetQuarter_12_ReturnsQ4()
        {
            AssertQuarter(12, CutoffDateHelper.Quarter.Q4);
        }

        #endregion GetQuarter

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
