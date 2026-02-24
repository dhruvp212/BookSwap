using BookSwap.DAL;
using BookSwap.Pages.Admin.Education;
using BookSwap.Pages.TblDTO;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Data.SqlClient;
using System.Data;

namespace BookSwap.Pages.Admin.Education
{
    

    public class AddEducationModel : PageModel
    {
        private readonly DbConnector db;

        public AddEducationModel(DbConnector db)
        {
            this.db = db;

            //eduTblDTO = new EducationTblDTO();
            //EducationList = new DataTable();
        }
        [BindProperty]

        public EducationTblDTO eduTblDTO { get; set; }
        public void OnGet(int EditId)
        {
            if (EditId > 0)
            {
                Dictionary<string, object> returnResponse = db.GetData("Select * from EducationTbl Where EducationId=@eid", new SqlParameter[] {
                 new SqlParameter("@eid",EditId)
                });
                if (returnResponse.ContainsKey("Data"))
                {
                    DataTable editDt = (DataTable)returnResponse["Data"];
                    if (editDt != null)
                    {
                        if (editDt.Rows.Count > 0)
                        {
                            eduTblDTO = new EducationTblDTO();
                            eduTblDTO.EducationName = editDt.Rows[0]["EducationName"].ToString();
                            eduTblDTO.Status = editDt.Rows[0]["Status"].ToString();
                            eduTblDTO.EducationId = Convert.ToInt32(editDt.Rows[0]["EducationId"].ToString());
                        }
                    }
                }
                else
                {
                    ViewData["Error"] = returnResponse["Error"];
                }
            }
        }
        public void OnPostCreate()
        {
            if (eduTblDTO != null)
            {
               Dictionary<string , object> returnResponse =  db.InsertUpdateDelete("Insert into EducationTbl values(@ename,@status,GETDATE())",new Microsoft.Data.SqlClient.SqlParameter[]
                {
                    new SqlParameter("@ename",eduTblDTO.EducationName),
                    new SqlParameter("@status",eduTblDTO.Status)
                });
                if (returnResponse.ContainsKey("Status"))
                {
                    ViewData["Message"] = "Your Eduction Data Sucessfully Done.";
                }
                else
                {
                    ViewData["Error"] = returnResponse["Error"];
                }
            }
        }

        public void OnPostUpdate()
        {
             if (eduTblDTO != null)
            {
                if (eduTblDTO.EducationId > 0)
                {
                    Dictionary<string, object> returnResponse = db.InsertUpdateDelete("Update EducationTbl Set EducationName=@ename,Status=@status Where EducationId = @eid", new Microsoft.Data.SqlClient.SqlParameter[]
                {
                    new SqlParameter("@ename",eduTblDTO.EducationName),
                    new SqlParameter("@status",eduTblDTO.Status),
                    new SqlParameter("@eid",eduTblDTO.EducationId)
                });
                    if (returnResponse.ContainsKey("Status"))
                    {
                        ViewData["Message"] = "Your Eduction Data Sucessfully Update.";
                       
                    }
                    else
                    {
                        ViewData["Error"] = returnResponse["Error"];
                    }
                } 
            }
        }
        
    }
}
