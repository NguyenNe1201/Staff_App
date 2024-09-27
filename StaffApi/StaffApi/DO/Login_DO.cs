using StaffApi.Models.Entities;

namespace StaffApi.DO
{
    public class Login_DO : BaseDO
    {
        public Login_DO(IServiceProvider serviceProvider) : base(serviceProvider)
        {
        }
        public async Task<IEnumerable<TimeLoginApp_Entities>> GetTimeLoginApp()
        {
            return await _dbHelper.ExecuteReaderAsync<TimeLoginApp_Entities>("getTimeLoginApp", new string[] {  }, new object[] { });
        }
        public async Task<int> AddTimeLogin(string phone)
        {
            return await _dbHelper.ExecStoreProcedureAsync("Add_TimeLoginApp", new string[] { "PHONE_NUMBER" }, new object[] { phone });
        }
        public async Task<IEnumerable<EmpLogin_Entities>> GetInfoEmpLoginAll ()
        {
            return await _dbHelper.ExecuteReaderAsync<EmpLogin_Entities>("GetEmpLoginByAll", new string[] { }, new object[] { });
        }
        public async Task<int> AddOTPEmpByEmail(string Email, string Emp_CODE, string OTP, DateTime TimeGetOTP)
        {
            return await _dbHelper.ExecStoreProcedureAsync("Add_OtpByEmail", new string[] { "EMAIL", "EMPLOYEE_CODE", "OTP", "TIME_GET_OTP" }, new object[] { Email, Emp_CODE, OTP, TimeGetOTP });
        }
        public async Task<int> AddOTPEmpByPhone(string Email, string Emp_CODE, string OTP, DateTime TimeGetOTP)
        {
            return await _dbHelper.ExecStoreProcedureAsync("Add_OtpByPhone", new string[] { "PHONE_NUMBER", "EMPLOYEE_CODE", "OTP", "TIME_GET_OTP" }, new object[] { Email, Emp_CODE, OTP, TimeGetOTP });
        }
        public async Task<int> UpdateTime_LoginOTP(string emp_code, DateTime TimeGetOTP, DateTime time_login)
        {
            return await _dbHelper.ExecStoreProcedureAsync("UPD_EmpLogin", new string[] { "EMP_CODE", "TIME_GET_OTP", "TIME_LOGIN" }, new object[] { emp_code, TimeGetOTP, time_login });
        }
    }
}
