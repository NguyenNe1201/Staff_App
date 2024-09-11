using StaffApi.Models.Entities;

namespace StaffApi.DO
{
    public class Salary_DO : BaseDO
    {
        public Salary_DO(IServiceProvider serviceProvider) : base(serviceProvider)
        {
        }
        public async Task<IEnumerable<Salary_Entities>> GetSalaryByEmpCode(string code,string year_month)
        {
            return await _dbHelper.ExecuteReaderAsync<Salary_Entities>("GetSalaryEmp_ByCode", new string[] { "EMPCODE", "LuongThang" }, new object[] { code,year_month });
        }
    }
}
