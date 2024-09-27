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
        public async Task<ActionResult> GetTimeKeepMonthEmp(string code,string month,string year)
        {
            var name_table = year + month;
            //var name_table = "202312";
            var data = (await _timekeepDo.GetTimekeepMonthByCode(code,name_table)).OrderByDescending(o=>o.DATEOFMONTH).ToList();
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
            var data = (await _timekeepDo.GetTimeLogListMonthByCode(code)).OrderByDescending(o=>o.DATECHECK).ToList();
            if (data == null)
            {
                return NotFound();
            }
            return Ok(data);
        }
    }
}
