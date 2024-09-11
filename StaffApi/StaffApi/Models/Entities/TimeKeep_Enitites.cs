namespace StaffApi.Models.Entities
{
    public class TimeKeep_Enitites
    {
        public decimal EMPLOYEE_ID { get; set; }
        public string EMP_CODE { get; set; }
        public string DATENAME { get; set; }
        public DateTime DATEOFMONTH { get; set; }
        public DateTime TIME_CHECKIN { get; set; }
        public DateTime TIME_CHECKOUT { get; set; }
        public double HOUR_WORK { get; set; }
        public double OT_WORK { get; set; }
        public double OT200_WORK { get; set; }
        public double NIGHT_TIME { get; set; }
        public double ANUAL_LEAVE { get; set; }
        public double WED_FUL_LEAVE { get; set; }
        public double OTHER_LEAVE { get; set; }
        public double OT_HOLIDAY { get; set; }
        public string REMARK { get; set; }
        public double DAYOFF { get; set; }
    }
}
