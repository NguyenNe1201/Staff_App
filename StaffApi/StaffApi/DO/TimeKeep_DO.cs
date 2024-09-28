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
        public async Task<IEnumerable<LogListMonth_Entities>> GetTimeLogListByEmpCode(string code)
        {
            return await _dbHelper.ExecuteReaderAsync<LogListMonth_Entities>("sp_SEL_TimeLogListMonthEmpCode_NEW", new string[] { "Employee_Code" }, new object[] { code });
        }
        public async Task<IEnumerable<LogListMonth_Entities>> GetLogListTimeByMonth_EmpCode(string code,string month,string year)
        {
            return await _dbHelper.ExecuteReaderAsync<LogListMonth_Entities>("sp_SEL_TimeLogListByMonth_EmpCode", new string[] { "Employee_Code","month","year" }, new object[] { code,month,year });
        }
    }
}
