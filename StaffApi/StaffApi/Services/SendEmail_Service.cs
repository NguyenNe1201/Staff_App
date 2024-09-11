using Elfie.Serialization;
using MailKit.Security;
using MimeKit;
using StaffApi.DO;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
namespace StaffApi.Common
{
    public class SendEmail_Service
    {
        private readonly EmailSMS_DO _smsDo;

        public SendEmail_Service(IServiceProvider serviceProvider)
        {
            _smsDo = new EmailSMS_DO(serviceProvider);
        }

        public async Task SendEmail_OTP(string toEmail,string OTP)
        {
            // get dữ liệu infomaiton email sms từ csdl  
            var info_sms = (await _smsDo.GetEmailSMS()).FirstOrDefault();
            // get email, pass để tiến hành gửi mã otp qua gmail
            string FromEmail = info_sms.FromEmailAddressSMS;
            string EmailPassword = info_sms.FromEmailPasswordSMS;

            var DisplayName = "Mã OTP Đăng Nhập App";
            var smtpHost = "mail.conectvn.com";
            var smtpport = "465";

            var Email = new MimeMessage();
            Email.From.Add(new MailboxAddress("send", FromEmail));
            Email.To.Add(new MailboxAddress("", toEmail));
            Email.Subject = DisplayName;


            // Thiết kế nội dung email dưới dạng HTML
            var bodyBuilder = new BodyBuilder();
            bodyBuilder.HtmlBody = $@"
                                    <html>
                                        <body>
                                            <h2>{DisplayName}</h2>
                                            <p>Xin chào,{toEmail}</p>
                                            <p>Mã OTP của bạn là: <strong style=""color:#f89321;font-size:24px;font-weight:bold;"">{OTP}</strong></p>
                                            <p>Vui lòng không chia sẻ mã OTP này với bất kỳ ai.</p>
                                            <p>Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!</p>
                                        </body>
                                    </html>";
            Email.Body = bodyBuilder.ToMessageBody();
            using (var smtp = new MailKit.Net.Smtp.SmtpClient())
            {
                smtp.ServerCertificateValidationCallback = (l, j, c, m) => true;
                smtp.Connect(smtpHost, Convert.ToInt32(smtpport), SecureSocketOptions.SslOnConnect);
                smtp.Authenticate(FromEmail, EmailPassword);
                smtp.Send(Email);
                smtp.Disconnect(true);
            }

        }
    }
}
