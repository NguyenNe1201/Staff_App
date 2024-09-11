using Microsoft.Extensions.DependencyInjection;
using System;

namespace StaffApi.DO
{
    public class BaseDO
    {
        protected readonly DbHelper _dbHelper;

        public BaseDO(IServiceProvider serviceProvider)
        {
            _dbHelper = serviceProvider.GetRequiredService<DbHelper>();
        }
    }
}
