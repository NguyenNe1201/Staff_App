using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Org.BouncyCastle.Crypto.Macs;
using StaffApi.Common;
using StaffApi.DO;
using StaffApi.Models;
using StaffApi.Models.Entities;
using StaffApi.Services;

namespace StaffApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        private readonly Employee_Service _employeeService;
        public EmployeeController(IServiceProvider serviceProvider)
        {
            _employeeService = new Employee_Service(serviceProvider);
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _employeeService.GetInfoAllEmployee();
            if (data == null || !data.Any())
            {   
                return NotFound();
            }
            return Ok(data);

        }
        // api/Employee/id
        [HttpGet("{id}")]
        public async Task<ActionResult> GetEmpID(int id)
        {
            var data = await _employeeService.GetInfoEmployeeByID(id);
            if (data == null)
            {
                return NotFound();
            }
            return Ok(data);

        }
        [HttpGet("GetByCode")]
        public async Task<ActionResult> GetEmpCode(string code)
        {
            var data = await _employeeService.GetInfoEmployeeByCODE(code);
            if (data == null)
            {
                return NotFound();
            }   
            return Ok(data);
        }
        // api/Employee/GetByPhone?number_phone=
       /* [HttpGet("GetByPhone")]
        public async Task<ActionResult> GetEmpByPhone(string number_phone)
        {
            var data = (await _employeeDo.GetAllEmployee()).Where(w => w.PHONE_NUMBER == number_phone).FirstOrDefault();
            if (data == null)
            {
                return NotFound();
            }
            else
            {
                //gửi mã otp qua gmail
                GmailOTP_Service comm = new GmailOTP_Service(_serviceProvider);
                Code_OTP = comm.MakeRandomOTP(4);
                comm.SendMail(data.EMAIL,Code_OTP.ToString());
                return Ok(data);
            }
            

        }*/
        /*    [HttpPost]
            public async Task<ActionResult> PostEmployee(Employee_Entities u)
            {
                int data = await _employeeDo.AddNewEmployee(u.EMP_CODE, u.FULLNAME);
                if(data > 0)
                {
                    return Ok(new { message = "Employee added successfully."});
                }
                else
                {
                    return StatusCode(500, new { message = "An error occurred while adding the employee." });
                }
            }*/

    }
}
