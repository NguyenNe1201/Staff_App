using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Scaffolding.Metadata;
using Org.BouncyCastle.Crypto.Macs;
using StaffApi.Common;
using StaffApi.DO;
using static System.Net.WebRequestMethods;

namespace StaffApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmailController : ControllerBase
    {
        private readonly Employee_DO _employeeDo;
        private readonly Login_DO _loginDo;
        private readonly IServiceProvider _serviceProvider;
        private readonly SendEmail_Service _emailService;
        private readonly RandomOTP_Common _randomOTP;

        public RandomOTP_Common common;
        string Code_OTP;
        public string Gmail;
        public string OTP;
        public EmailController(IServiceProvider serviceProvider)
        {
            _emailService =new SendEmail_Service(serviceProvider);
            _employeeDo = new Employee_DO(serviceProvider);
            _loginDo = new Login_DO(serviceProvider);
        }
        [HttpPost("SendEmail")]
        public async Task<ActionResult> sendEmail(string number_phone)
        {
            var data = (await _employeeDo.GetInfoAllEmployee()).Where(w => w.PHONE_NUMBER == number_phone).FirstOrDefault();
            if (data == null)
            {
                return NotFound();
            }
            else
            {
                DateTime date_getotp = DateTime.Now;
                //gửi mã otp qua gmail
                common = new RandomOTP_Common();
                Code_OTP = common.MakeRandomOTP(4);
                await _emailService.SendEmail_OTP(data.EMAIL, Code_OTP);
               _loginDo.AddOTPEmpByPhone(data.PHONE_NUMBER,data.EMP_CODE, Code_OTP,date_getotp);
                return Ok(new { Emp_code = data.EMP_CODE,Emp_id =data.EMPLOYEE_ID,Gmail = data.EMAIL, Phone = number_phone ,Otp =Code_OTP});
            }
        }
    }
}
