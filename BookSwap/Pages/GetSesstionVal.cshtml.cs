//using BookSwap.Filters;
//using Microsoft.AspNetCore.Mvc;
//using Microsoft.AspNetCore.Mvc.RazorPages;

//namespace BookSwap.Pages
//{

//    [TypeFilter(typeof(AuthPageFilter))]
//    public class GetSesstionValModel : PageModel
//    {

//        [BindProperty]

//        public string GetSVal { get; set; }
//        public void OnGet()
//        {
      
//            if (!string.IsNullOrEmpty(HttpContext.Session.GetString("sName")))
//            {
//                GetSVal = HttpContext.Session.GetString("sName");
//               // return Page();
//            }
//           //0 return RedirectToPage("SetSessionVal");
//        }

//        public IActionResult OnPost()
//        {
//            if (!string.IsNullOrEmpty(HttpContext.Session.GetString("sName")))
//            {
//                //HttpContext.Session.Remove("sName");
//                HttpContext.Session.Clear();
//            }
//            return Page();
//        }
//    }
//}
