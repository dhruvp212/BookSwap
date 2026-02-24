//using Microsoft.AspNetCore.Mvc;
//using Microsoft.AspNetCore.Mvc.Filters;

//namespace BookSwap.Filters
//{
//    public class AuthPageFilter : IPageFilter
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
//            if (string.IsNullOrEmpty(httpContent.Session.GetString("sName")))
//            {
//                context.Result = new RedirectToPageResult("/SetSesstionVal");
//            }
//        }

//        public void OnPageHandlerSelected(PageHandlerSelectedContext context)
//        {
            
//        }
//    }
//}
