using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Http;

namespace miitexam
{
    public class Startup
    {
        public void ConfigureServices(IServiceCollection services)
        {
			services.AddDistributedMemoryCache();
			services.AddSession();
			services.AddHttpContextAccessor();
            services.AddControllers();
			
        }

        public void Configure(IApplicationBuilder app)
        {
            app.UseSession();
			app.UseRouting();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}