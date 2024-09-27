using StaffApi.Models.Entities;
using System.Data;

namespace StaffApi.DO
{
    public class Leave_DO : BaseDO
    {
        public Leave_DO(IServiceProvider serviceProvider) : base(serviceProvider)
        {
        }
        public async Task<IEnumerable<Cal_Leave_Entities>> SEL_CAL_LEAVE(string condition)
        {
            return await _dbHelper.ExecuteReaderAsync<Cal_Leave_Entities>("SEL_CAL_LEAVE_TAB", new string[] { "CONDITION" }, new object[] { condition });
        }
        public async Task<IEnumerable<KindLeave_Entities>> GetAllKindLeave()
        {
            return await _dbHelper.ExecuteReaderAsync<KindLeave_Entities>("sp_SEL_KindLeave", new string[] { }, new object[] { });
        }
        public async Task<IEnumerable<Leave_Entities>> SEL_LEAVE(string condition)
        {
            return await _dbHelper.ExecuteReaderAsync<Leave_Entities>("sp_SEL_LEAVE", new string[] { "@CONDITION" }, new object[] { condition });
        }
        public async Task<float> SEL_ANUAL_LEAVE_REMAIN(decimal EMP_ID)
        {
            float i = 0;
            DataTable datatable = await _dbHelper.ReturnDataTableAsync("SEL_CURRENT_ANUAL_LEAVE", new string[] { "@EMPLOYEE_ID" }, new object[] { EMP_ID });
            if (datatable.Rows.Count > 0)
            {
                i = float.Parse(datatable.Rows[0][2].ToString());
            }
            return i;
        }
        public async Task<int> INS_Leave(int emp_id, int kindLeave_id, int hour, DateTime startDate, DateTime endDate, string detailReason, double ANNUAL_LEAVE_USED
            , string COM_MONTH, string COM_YEAR, string COM_YEAR_MONTH)
        {
            return await _dbHelper.ExecStoreProcedureAsync("sp_INS_Leave", new string[] { "EMPLOYEE_ID", "KINDLEAVE_ID", "HOURS", "LEAVE_STARTDATE",
                "LEAVE_ENDDATE", "REASON", "ANNUAL_LEAVE_USED","COM_MONTH","COM_YEAR","COM_YEAR_MONTH" },
                new object[] { emp_id, kindLeave_id, hour, startDate, endDate, detailReason, ANNUAL_LEAVE_USED, COM_MONTH, COM_YEAR, COM_YEAR_MONTH });
        }
        public async Task<int> UPD_LEAVE_STATUS(string POSITION, int LEAVE_ID, int STATUS, int EMP_ID_APP)
        {
            return await _dbHelper.ExecStoreProcedureAsync("UPD_Leave_Status", new string[] { "POSITION", "LEAVE_ID", "STATUS", "EMP_ID_APP" },
                new object[] { POSITION, LEAVE_ID,STATUS,EMP_ID_APP });
        }
        public async Task<IEnumerable<Leave_Entities>> GetLeaveByEmpID(decimal emp_id)
        {
            return await _dbHelper.ExecuteReaderAsync<Leave_Entities>("sp_SEL_LeaveByEmployeeID", new string[] { "EMPLOYEE_ID" }, new object[] { emp_id });
        }
    }
}
