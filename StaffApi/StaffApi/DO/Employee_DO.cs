using StaffApi.Models;
using StaffApi.Models.Entities;

namespace StaffApi.DO
{
    public class Employee_DO : BaseDO
    {
        public Employee_DO(IServiceProvider serviceProvider) : base(serviceProvider)
        {
        }
        public async Task<IEnumerable<Employee_Entities>> GetInfoAllEmployee()
        {
            return await _dbHelper.ExecuteReaderAsync<Employee_Entities>("GetAllEmployee_NEW", new string[] { }, new object[] { });
        }
        public async Task<IEnumerable<Employee_Entities>> GetEmployeeByCODE(string emp_code)
        {
            return await _dbHelper.ExecuteReaderAsync<Employee_Entities>("GetEmployeeByCODE", new string[] { "EMP_CODE" }, new object[] { emp_code });
        }
        public async Task<int> AddAccountEmp(int emp_id, string password)
        {
            return await _dbHelper.ExecStoreProcedureAsync("UPD_EMP_ACCOUNT", new string[] { "EMPLOYEE_ID", "PASS_WORD" },
                new object[] { emp_id, password });
        }
        /*  public async Task<int> AddNewUser(string name, string address)
         {
             return await _dbHelper.ExecStoreProcedureAsync("AddNewUser", new string[] { "name", "address" },
                 new object[] {  name,address });
         }
         public async Task<int> UpdateUser(int id,string name, string address)
         {
             return await _dbHelper.ExecStoreProcedureAsync("UpdateUser", new string[] { "id","name", "address" },
                 new object[] { id,name, address });
         }*/
        public async Task<int> DeleteEmp(int UserId)
        {
            return await _dbHelper.ExecStoreProcedureAsync("DeleteEmp", new string[] { "id" },
                new object[] { UserId });
        }

    }
}
