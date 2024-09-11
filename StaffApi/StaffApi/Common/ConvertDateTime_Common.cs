namespace StaffApi.Common
{
    public class ConvertDateTime_Common
    {
        public static DateTime? StrToDateTime(string dateStr)
        {
            DateTime dateTime;
            bool isValid = DateTime.TryParseExact(dateStr, "dd/MM/yyyy", null, System.Globalization.DateTimeStyles.None, out dateTime);
            if (isValid)
            {
                return dateTime;
            }
            return null; // Trả về null nếu chuỗi không hợp lệ
        }
    }
}
