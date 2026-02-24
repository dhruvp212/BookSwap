//using BookSwap.Filters;
using BookSwap.DAL;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddRazorPages();

//builder.Services.AddRazorPages(options =>
//{
//    // Default "/" → Index.cshtml (unchanged)

//    // "/Admin" → Pages/Admin/Dashboard.cshtml
//    //options.Conventions.AddPageRoute("/Admin/Dashboard", "/Admin");
//    //options.Conventions.ConfigureFilter(new AdminAuthPageFilter());
//});

//DbConnection - Add Dependency Injection
//Only 1 instance for the whole app 
//Logging, configration settings
builder.Services.AddSingleton<DbConnector>();

//Add Sesstion In Project 
//builder.Services.AddSession(options =>
//{
//    options.IdleTimeout = TimeSpan.FromMinutes(30);
//    options.Cookie.HttpOnly = true;
//    options.Cookie.IsEssential = true;
//});
var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

//Use Sesstion In Project 
//app.UseSession();

//app.UseSession();

app.UseAuthorization();

app.MapRazorPages();

app.Run();