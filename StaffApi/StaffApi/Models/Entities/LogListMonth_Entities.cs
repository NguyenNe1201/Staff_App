using NuGet.Packaging.Signing;

namespace StaffApi.Models.Entities
{
    public class LogListMonth_Entities
    {
        public string EMP_CODE { get; set; }
        public string FULLNAME { get; set; }
        public DateTime DATECHECK { get; set; }
        public string TIMECHECK { get; set; }
        public DateTime TIME_TEMP { get; set; }
        public string NM { get; set; }
        public string EVENT_TYPE { get; set; }
        public double TNAKEY { get; set; }
    }
}
