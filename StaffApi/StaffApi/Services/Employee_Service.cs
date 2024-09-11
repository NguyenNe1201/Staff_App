using StaffApi.DO;
using StaffApi.Models.Entities;

namespace StaffApi.Services
{
    public class Employee_Service
    {
        private readonly Employee_DO _employeeDo;

        public Employee_Service(IServiceProvider serviceProvider)
        {
            _employeeDo = new Employee_DO(serviceProvider);
        }
        public async Task<List<Employee_Entities>> GetInfoAllEmployee()
        {
            return (await _employeeDo.GetInfoAllEmployee()).ToList();
        }
        public async Task<Employee_Entities> GetInfoEmployeeByID(int id)
        {
            return (await _employeeDo.GetInfoAllEmployee()).FirstOrDefault(w => w.EMPLOYEE_ID == id);
            
        }
        public async Task<Employee_Entities> GetInfoEmployeeByCODE(string code)
        {
            return (await _employeeDo.GetInfoAllEmployee()).FirstOrDefault(w => w.EMP_CODE == code);

        }
        public async Task<Employee_Entities> GetInfoEmployeeByAccount(string username,string password)
        {
            return (await _employeeDo.GetInfoAllEmployee()).FirstOrDefault(w => w.USERNAME == username && w.PASS_WORD == password);

        }
        public async Task<Employee_Entities> GetEmployeeByKeyWord()
        {
            return (await _employeeDo.GetInfoAllEmployee()).FirstOrDefault();
        }
    }
}
