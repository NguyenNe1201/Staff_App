namespace StaffApi.Common
{
    public class RandomOTP_Common
    {
        public string MakeRandomOTP(int length)
        {
            string UpperCase = "QWERTYUIOPASDFGHJKLZXCVBNM";
            string LowerCase = "qwertyuiopasdfghjklzxcvbnm";
            string Digits = "1234567890";
            string allcharacter = UpperCase + LowerCase + Digits;
            Random R = new Random();
            string otp = "";
            for (int i = 0; i < length; i++)
            {
                double rand = R.NextDouble();
                otp += Math.Floor(rand * Digits.Length);

            }
            return otp;
        }
    }
}
