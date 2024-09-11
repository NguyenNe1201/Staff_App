using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using StaffApi.DO;

namespace StaffApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SalaryController : ControllerBase
    {
        private readonly Salary_DO _salary_do;
        public SalaryController(IServiceProvider serviceProvider)
        {
            _salary_do = new Salary_DO(serviceProvider);
        }
        [HttpGet("ByMonth")]
        public async Task<ActionResult> GetSalaryEmpCode(string code, string year_month)
        {
            var data = (await _salary_do.GetSalaryByEmpCode(code, year_month)).FirstOrDefault();
            if (data == null)
            {
                return NotFound();
            }
            return Ok(data);

        }
    }
}