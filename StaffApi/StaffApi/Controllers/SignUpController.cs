using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualBasic;
using StaffApi.DO;

namespace StaffApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SignUpController : ControllerBase
    {
        private readonly SignUp_DO signUp_Do;
        private readonly Employee_DO employee_Do;
        public SignUpController(IServiceProvider serviceProvider)
        {
            employee_Do = new Employee_DO(serviceProvider);
            signUp_Do = new SignUp_DO(serviceProvider);
        }
        [HttpGet("CheckAccountByPhone")]
        public async Task<ActionResult<bool>> CheckAccountByPhone(string phone)
        {
            var data_ = (await employee_Do.GetInfoAllEmployee()).Where(w => w.PHONE_NUMBER == phone).FirstOrDefault();
            if (data_.PASS_WORD == null)
            {
                return Ok(true);
            }
            
            return Ok(false);
        }
        [HttpPut("AddAccount")]
        public async Task<ActionResult<bool>> AddAccount(int empId, string password)
        {
            int i = await employee_Do.AddAccountEmp(empId,password);
            if (i >0)
            {
                // add account for user
                return Ok(true);
            }
            // user đã tồn tại
            return Ok(false);
        }
    }
}
