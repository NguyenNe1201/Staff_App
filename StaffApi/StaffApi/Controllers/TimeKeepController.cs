using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using StaffApi.DO;

namespace StaffApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TimeKeepController : ControllerBase
    {
        private readonly TimeKeep_DO _timekeepDo;

        public TimeKeepController(IServiceProvider serviceProvider)
        {
            _timekeepDo = new TimeKeep_DO(serviceProvider);
        }
        // api/Timekeep/MonthEmp?code=
        [HttpGet("timeKeepMonth")]
        public async Task<ActionResult> GetTimeKeepMonthEmp(string code)
        {
            var currentDate = DateTime.Now;
            var current_year = DateTime.Now.Year.ToString();
            var lastmonth = DateTime.Now.Month.ToString();

            if (currentDate.Month == 1)
            {

                current_year = (currentDate.Year - 1).ToString();
                lastmonth = (currentDate.Month - 1 + 12).ToString();
            }
            else
            {

                lastmonth = (currentDate.Month - 1).ToString();
            }
            //var name_table = current_year + lastmonth;
            var name_table = "202312";
            //
            var data = (await _timekeepDo.GetTimekeepMonthByCode(code,name_table)).ToList();
            if (data == null)
            {
                return NotFound();
            }
            return Ok(data);

        }
        // 
        [HttpGet("logListTime")]
        public async Task<ActionResult> GetLogListTimeEmp(string code)
        {
           
            var data = (await _timekeepDo.GetTimeLogListMonthByCode(code)).ToList();
            if (data == null)
            {
                return NotFound();
            }
            return Ok(data);

        }
    }
}
