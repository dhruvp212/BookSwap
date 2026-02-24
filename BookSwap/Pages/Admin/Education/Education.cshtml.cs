using BookSwap.DAL;
using BookSwap.Pages.TblDTO;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Data.SqlClient;
using System.Data;

namespace BookSwap.Pages.Admin.Education
{
    public class EducationModel : PageModel
    {
        private readonly DbConnector db;
        public EducationModel(DbConnector db)
        {
            this.db = db;

            //eduTblDTO = new EducationTblDTO();
            //EducationList = new DataTable();
        }

        [BindProperty]
        public EducationTblDTO eduTblDTO { get; set; }
        public DataTable EducationList { get; set; }
        public void FillGrid()
        {
            Dictionary<string, object> responsData = db.GetData("select * from EducationTbl");
            if (responsData.ContainsKey("Data"))
            {
                EducationList = (DataTable)responsData["Data"];
            }
            else
            {
                ViewData["Error"] = responsData["Error"];
            }
        }

        public void OnGet()
        {
            FillGrid();
        }

        public void OnPostDelete(int DeleteId)
        {
            if (DeleteId > 0)
            {

                Dictionary<string, object> returnResponse = db.InsertUpdateDelete("Delete From EducationTbl Where EducationId = @eid", new Microsoft.Data.SqlClient.SqlParameter[]{
                   new SqlParameter("@eid", eduTblDTO.EducationId)
                });
                if (returnResponse.ContainsKey("Status"))
                {
                    ViewData["Message"] = "Your Eduction Data Sucessfully Deleted.";

                }
                else
                {
                    ViewData["Error"] = returnResponse["Error"];
                }
            }
            FillGrid();
        }
    }
}
