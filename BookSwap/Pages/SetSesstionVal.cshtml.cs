//using Microsoft.AspNetCore.Mvc;
//using Microsoft.AspNetCore.Mvc.RazorPages;

//namespace BookSwap.Pages
//{
//    public class SetSesstionValModel : PageModel
//    {

//        [BindProperty]

//        public string Name { get; set; }
//        public void OnGet()
//        {

//        }

//        public IActionResult OnPost()
//        {
//            HttpContext.Session.SetString("sName",Name);
//            return RedirectToPage("GetSesstionVal");
//        }
//    }
//}
