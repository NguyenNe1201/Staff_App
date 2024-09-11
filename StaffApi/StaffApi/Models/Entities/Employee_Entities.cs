using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.Text.Json.Serialization;
namespace StaffApi.Models.Entities
{
    public class Employee_Entities
    {
        public decimal EMPLOYEE_ID { get; set; }
        public string EMP_CODE { get; set; } = "";
        public string FULLNAME { get; set; } = "";
        public string PHONE_NUMBER { get; set; } = "";
        public string EMAIL { get; set; } = "";
        public DateTime DATE_OF_BIRTH { get; set; }
        public int DEPARTMENT_ID { get; set; }
        public string DEPARTMENT_NAME_VI { get; set; }
        public string DEPARTMENT_NAME_EN { get; set; }
        public string TitleName_vi { get; set; }
        public string TitleName_en { get; set; }
        public string SECTION_NAME_EN { get; set; }
        public string SECTION_NAME_VI { get; set; }
        public string USERNAME { get; set; }
        public string PASS_WORD { get; set; }   
        public string SEX { get; set; }
    }
}