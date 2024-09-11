using StaffApi.Models;
using StaffApi.Models.Entities;
namespace StaffApi.DO
{
    public class TimeKeep_DO : BaseDO
    {
        public TimeKeep_DO(IServiceProvider serviceProvider) : base(serviceProvider)
        {
        }
        public async Task<IEnumerable<TimeKeep_Enitites>> GetTimekeepMonthByCode(string code,string name_table)
        {
            return await _dbHelper.ExecuteReaderAsync<TimeKeep_Enitites>("sp_SEL_TimeKeepMonthEmpCode", new string[] { "EMP_CODE", "TableName" }, new object[] {code,name_table });
        }
        public async Task<IEnumerable<LogListMonth_Entities>> GetTimeLogListMonthByCode(string code)
        {
            return await _dbHelper.ExecuteReaderAsync<LogListMonth_Entities>("sp_SEL_TimeLogListMonthEmpCode_NEW", new string[] { "Employee_Code" }, new object[] { code });
        }
    }
}
