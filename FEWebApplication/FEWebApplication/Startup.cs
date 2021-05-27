using Fe.Servidor.Middleware.Modelo.Contexto;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Fe.Servidor.Middleware.Dapper;
using FEWebApplication.Authentication;
using Fe.Core.General.Datos;
using Fe.Core.General.Negocio;
using FEWebApplication.Controladores.Core;
using Fe.Core.Seguridad.Negocio;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Hosting;

namespace FEWebApplication
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddRazorPages();

            //Conexión a DB de Fe
            services.AddDbContext<FeContext>(options =>
                options.UseNpgsql(Configuration.GetConnectionString("ConexionString")));
            CODBOrmFactorycs.Configurar(Configuration);

            //Añadir Identity
            services.AddDbContext<ApplicationUserDbContext>(options =>
                options.UseNpgsql(Configuration.GetConnectionString("ConexionString")));

            // Adding Authentication  
            services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = "Bearer";
                options.DefaultChallengeScheme = "Bearer";
                options.DefaultScheme = "Bearer";
            });

            //Configurar Email

            services.AddIdentity<IdentityUser, IdentityRole>()
                .AddEntityFrameworkStores<ApplicationUserDbContext>()
                .AddDefaultTokenProviders();

            services.AddScoped<DbContext, ApplicationUserDbContext>();

            services.AddScoped<RepoPoblacion>();
            services.AddScoped<COGeneralBiz>();
            services.AddScoped<COGeneralController>();
            services.AddScoped<AuthenticateController>();
            services.AddScoped<COSeguridadBiz>();
            services.AddScoped<RepoDemografia>();

            services.AddRazorPages();
            services.AddControllers();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            app.UseExceptionHandler("/error");
            app.UseHsts();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();
            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapRazorPages();
                endpoints.MapControllers();
            });
        }
    }
}
