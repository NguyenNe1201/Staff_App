namespace StaffApi.Common
{
    public class Calculate_Common
    {
        public static float TotalLeaveInsert(DateTime StartDate, DateTime EndDate,float Hours, float PNCL)
        {
            float total_Phep;
            int total_day = 0;
            for (DateTime dt_temp = StartDate; dt_temp <= EndDate; dt_temp = dt_temp.AddDays(1))
            {
                if (dt_temp.DayOfWeek != DayOfWeek.Sunday)
                {
                    total_day++;
                }
            }
            total_Phep = (total_day * (Hours / 8));
            return PNCL - total_Phep;
        }
        public static bool Max3_DateLeave(DateTime start, DateTime end)
        {
            //tính cả ngày bắt đầu nên tổng ngày chỉ là 2. vd: 1>3 -> 2

            TimeSpan time_diff = end - start;
            if (time_diff.TotalDays > 2)
                return true;
            else
                return false;
        }
    }
}
