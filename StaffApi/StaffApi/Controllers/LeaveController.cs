using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using StaffApi.DO;
using System.Diagnostics.CodeAnalysis;
using StaffApi.Common;
using static System.Runtime.InteropServices.JavaScript.JSType;
using StaffApi.Models.Entities;
namespace StaffApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LeaveController : ControllerBase
    {
        private readonly Leave_DO leave_do;
        private readonly Employee_DO employee_do;

        public LeaveController(IServiceProvider serviceProvider)
        {
            employee_do = new Employee_DO(serviceProvider);
            leave_do = new Leave_DO(serviceProvider);
        }
        // Calculator leavel by employee id
        [HttpGet("Cal_EmpID")]
        public async Task<ActionResult> GetCalLeave_EmpID(int emp_id)
        {
            var condition = "AND EMPLOYEE_ID =" + emp_id.ToString();
            var data_cal_leave = (await leave_do.SEL_CAL_LEAVE(condition)).FirstOrDefault();
            if (data_cal_leave == null)
            {
                return NotFound();
            }
            return Ok(data_cal_leave);
        }
        // get data leavel by emloyee id
        [HttpGet("GetList_EmpID")]
        public async Task<ActionResult> GetListLeave_EmpID(int emp_id)
        {
            var data_leave = (await leave_do.GetLeaveByEmpID(emp_id)).Where(w => w.LEAVE_STARTDATE.Year == DateTime.Now.Year).OrderByDescending(o => o.LEAVE_STARTDATE).ToList();
            if (data_leave == null)
            {
                return NotFound();
            }
            return Ok(data_leave);
        }
        [HttpGet("GetListByMonth_EmpID")]
        public async Task<ActionResult> GetListLeaveByMonth_EmpID(int emp_id, int month)
        {
            var data_leave = (await leave_do.GetLeaveByEmpID(emp_id)).Where(w => w.LEAVE_STARTDATE.Year == DateTime.Now.Year
            && w.LEAVE_STARTDATE.Month == month).OrderByDescending(o => o.LEAVE_STARTDATE).ToList();
            if (data_leave == null)
            {
                return NotFound();
            }
            return Ok(data_leave);
        }
        [HttpGet("GetAllKindLeave")]
        public async Task<ActionResult> GetAllKindLeave()
        {
            var data = (await leave_do.GetAllKindLeave()).ToList();
            if (data == null)
            {
                return NotFound();
            }
            return Ok(data);
        }
        [HttpGet("CheckLeaveEmp")]
        public async Task<ActionResult> CheckLeaveEmp(int emp_id, int kindLeave_id, int period, string startDate, string endDate, string? detailReason)
        {
            DateTime? startDate_dt, endDate_dt;
            startDate_dt = ConvertDateTime_Common.StrToDateTime(startDate);
            endDate_dt = ConvertDateTime_Common.StrToDateTime(endDate);
            string condition = " AND LEAVE_TAB.LEAVE_STARTDATE between'" + startDate_dt?.ToString("yyyy-MM-dd") + "' and '" + endDate_dt?.ToString("yyyy-MM-dd") + "'";
            if (emp_id > 0)
            {
                condition += " AND LEAVE_TAB.EMPLOYEE_ID = " + emp_id;
            }
            List<Leave_Entities> leave_CHECK = (await leave_do.SEL_LEAVE(condition)).ToList();

            foreach (Leave_Entities leave in leave_CHECK)
            {
                if (leave.STATUS_L != 0)
                {
                    return Ok(new { error = "Ngày nghỉ phép " + leave.LEAVE_STARTDATE + " này đã được duyệt." });
                }

            }
            return Ok(new { succcess = "" });
        }
        [HttpPost("Insert")]
        public async Task<ActionResult> Insert_Leave(int emp_id, int kindLeave_id, int period, string startDate, string endDate, string? detailReason)
        {
            DateTime? startDate_dt, endDate_dt;
            float PNCL = await leave_do.SEL_ANUAL_LEAVE_REMAIN(emp_id);
            startDate_dt = ConvertDateTime_Common.StrToDateTime(startDate);
            endDate_dt = ConvertDateTime_Common.StrToDateTime(endDate);

            if (kindLeave_id == 1 && Calculate_Common.TotalLeaveInsert(startDate_dt.Value, endDate_dt.Value, (float)period, PNCL) < 0)
            {
                //   return NotFound(new { error = "Phép năm của bạn không đủ. Lưu không thành công." });
                return Ok(new { error = "Phép năm của bạn không đủ. Lưu không thành công." });

            }
            else if (Calculate_Common.Max3_DateLeave(startDate_dt.Value, endDate_dt.Value))
            {
                //  return NotFound(new { error = "Tối đa là 3 ngày phép. Lưu không thành công." });
                return Ok(new { error = "Tối đa là 3 ngày phép. Lưu không thành công." });

            }
            else
            {
                string condition = " AND LEAVE_TAB.LEAVE_STARTDATE between'" + startDate_dt?.ToString("yyyy-MM-dd") + "' and '" + endDate_dt?.ToString("yyyy-MM-dd") + "'";
                if (emp_id > 0)
                    condition += " AND LEAVE_TAB.EMPLOYEE_ID = " + emp_id;
                List<Leave_Entities> leave_CHECK = (await leave_do.SEL_LEAVE(condition)).ToList();
                if (leave_CHECK.Count > 0)
                {
                    foreach (Leave_Entities leave in leave_CHECK)
                    {
                        if (leave.STATUS_L != 0)
                        {
                            return Ok(new { error = "Ngày nghỉ phép " + leave.LEAVE_STARTDATE.ToString("dd/MM/yyyy") + " này đã được duyệt." });
                        }
                    }
                }
                int i = await leave_do.INS_Leave(emp_id, kindLeave_id, period, startDate_dt.Value, endDate_dt.Value, detailReason, 0, null, null, null);
                if (i > 0)
                    return Ok(new { success = "insert success..." });
                else
                    return Ok(new { error = "Thêm phép không thành công!" });
            }
        }
    }
}
