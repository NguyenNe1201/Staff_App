namespace StaffApi.DO
{
    public class SignUp_DO : BaseDO
    {
        public SignUp_DO(IServiceProvider serviceProvider) : base(serviceProvider)
        {
        }
        public async Task<int> UpdateAccount(string emp_code, DateTime TimeGetOTP, DateTime time_login)
        {
            return await _dbHelper.ExecStoreProcedureAsync("UPD_EmpLogin", new string[] { "EMP_CODE", "TIME_GET_OTP", "TIME_LOGIN" }, new object[] { emp_code, TimeGetOTP, time_login });
        }

    }
}
