//using Microsoft.AspNetCore.Mvc;
//using Microsoft.AspNetCore.Mvc.Filters;

//namespace BookSwap.Filters
//{
//    public class AdminAuthPageFilter : IPageFilter
//    {
//        public void OnPageHandlerExecuted(PageHandlerExecutedContext context)
//        {

//        }

//        public void OnPageHandlerExecuting(PageHandlerExecutingContext context)
//        {
//            var httpContent = context.HttpContext;
//            //if (httpContent != null)
//            //{
//            //    return;
//            //}
//            var path = httpContent.Request.Path.Value?.ToLower();
//            String[] pageList = new string[]
//            {
//                "/",
//                "/index",
//            };

//            if (!string.IsNullOrEmpty(path))
//            {
//                if (pageList.Any(pageName => path.EndsWith(pageName)))
//                {
//                    return;
//                }
//            }

//            if (string.IsNullOrEmpty(httpContent.Session.GetString("Admin")))
//            {
//                context.Result = new RedirectToPageResult("/Registretion");
//            }
//        }

//        public void OnPageHandlerSelected(PageHandlerSelectedContext context)
//        {

//        }
//    }
//}
