using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Press return to start");
            Console.ReadLine();
            Console.WriteLine();
            DoWork();
            Console.WriteLine();
            Console.WriteLine("Press <RETURN> to Exit)");
            Console.ReadLine();
            Console.WriteLine();
            Console.WriteLine("Goodbye!");
        }




        static void DoWork()
        {
            Dictionary<string, int[]> interestingNumbers = new Dictionary<string, int[]>();

            interestingNumbers.Add("Prime", new int[] { 2, 3, 5, 7, 11, 13 });
            interestingNumbers.Add("Fibonacci", new int[] { 1, 1, 2, 3, 5, 8, 12, 20, 32 });
            interestingNumbers.Add("Square", new int[] { 1, 4, 9, 16, 25 });

            int largest = 0;
            string kindOfNumber = string.Empty;

            foreach (KeyValuePair<string,int[]> kvp in interestingNumbers){

                foreach (int number in kvp.Value)
                {
                    if (number > largest)
                    {
                        largest = number;
                        kindOfNumber = kvp.Key;
                    }
                }
            }

            Console.WriteLine($"Largest: {largest}, Kind: {kindOfNumber}");
        }
    }
}
