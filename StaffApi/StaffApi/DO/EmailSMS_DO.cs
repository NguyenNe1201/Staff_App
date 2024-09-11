using StaffApi.Models.Entities;

namespace StaffApi.DO
{
    public class EmailSMS_DO:BaseDO
    {
        public EmailSMS_DO(IServiceProvider serviceProvider) : base(serviceProvider)
        {
        }
        public async Task<IEnumerable<EmailSMS_Entities>> GetEmailSMS()
        {
            return await _dbHelper.ExecuteReaderAsync<EmailSMS_Entities>("GetEmailSMS", new string[] { }, new object[] { });
        }
    }
}
