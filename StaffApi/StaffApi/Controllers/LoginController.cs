using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using StaffApi.DO;
using System.Data;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace StaffApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly Login_DO login_Do;
        private readonly Employee_DO employee_Do;
        public LoginController(IServiceProvider serviceProvider)
        {
            employee_Do = new Employee_DO(serviceProvider);
            login_Do = new Login_DO(serviceProvider);
        }
        [HttpGet("CheckPhoneUser")]
        public async Task<ActionResult<bool>> CheckPhoneUser(string phone)
        {
            var data = (await employee_Do.GetInfoAllEmployee()).Where(w => w.PHONE_NUMBER == phone).FirstOrDefault();
            if (data == null)
            {
                return Ok(false);
            }
            return Ok(true);
        }
        [HttpGet("CheckTime")]
        public async Task<ActionResult<bool>> CheckTimeLoginByPhone(string phone)
        {
            var data = (await login_Do.GetTimeLoginApp()).Where(w => w.PHONE_NUMBER == phone).FirstOrDefault();
            if (data == null)
            {
                return Ok(false);
            }
            return Ok(true);
        }
        // check account user = phone,password
        [HttpGet("CheckAcByPhone")]
        public async Task<ActionResult> LoginAccountByPhone(string phone, string password)
        {
            var data = (await employee_Do.GetInfoAllEmployee()).Where(w => w.PHONE_NUMBER == phone && w.PASS_WORD == password).FirstOrDefault();
            if (data == null)
            {
                return NotFound();
            }
            return Ok(new { emp_code = data.EMP_CODE, emp_id = data.EMPLOYEE_ID });
        }
        //check account user = email,password
        [HttpGet("CheckAcByEmail")]
        public async Task<ActionResult> LoginAccountByEmail(string email, string password)
        {
            var data = (await employee_Do.GetInfoAllEmployee()).Where(w => w.EMAIL == email && w.PASS_WORD == password).FirstOrDefault();
            if (data == null)
            {
                return NotFound();
            }
            return Ok(new { emp_code = data.EMP_CODE, emp_id = data.EMPLOYEE_ID });
        }
        //check account user = email,password
        [HttpGet("CheckAcByUsername")]
        public async Task<ActionResult> LoginAccountByUsername(string username, string password)
        {
            var data = (await employee_Do.GetInfoAllEmployee()).Where(w => w.USERNAME == username && w.PASS_WORD == password).FirstOrDefault();
            if (data == null)
            {
                return NotFound();
            }
            return Ok(new { emp_code = data.EMP_CODE, emp_id = data.EMPLOYEE_ID });
        }
        // 
        [HttpPut("UpdateStatus")]
        public async Task<ActionResult<bool>> UpStatus_LoginByOTP(string emp_code, string phone, string otp)
        {
            DateTime date_login = DateTime.Now;
            var data_timeLoginApp = login_Do.AddTimeLogin(phone);
            var data_ = (await login_Do.GetInfoEmpLoginAll()).Where(w => w.EMPLOYEE_CODE == emp_code && w.OTP == otp).FirstOrDefault();
            var i = await login_Do.UpdateTime_LoginOTP(emp_code, data_.TIME_GET_OTP, date_login);
            if (data_ == null && data_timeLoginApp == null)
            {
                return Ok(false);
            }
            return Ok(true);
        }
    }
}
