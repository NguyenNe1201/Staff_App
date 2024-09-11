namespace StaffApi.Models.Entities
{
    public class EmpLogin_Entities
    {
        public decimal ID { get; set; }
        public string EMPLOYEE_CODE { get; set; }
        public string EMAIL { get; set; }
        public string OTP { get; set; }
        public DateTime TIME_GET_OTP { get; set; }
        public DateTime TIME_LOGIN { get; set; }
        public bool STATUS_LOGIN { get; set; }
    }
}
