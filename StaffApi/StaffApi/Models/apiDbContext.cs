using Microsoft.EntityFrameworkCore;
using StaffApi.Models.Entities;

namespace StaffApi.Models
{
    public class apiDbContext : DbContext
    {
        public apiDbContext()
        {

        }
        public apiDbContext(DbContextOptions<apiDbContext> options)
            : base(options)
        {
        }
        
        public virtual DbSet<Employee_Entities> TblEmp { get; set; }
    }
}
