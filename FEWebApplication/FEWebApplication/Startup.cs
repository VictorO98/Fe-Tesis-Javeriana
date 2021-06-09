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
using Fe.Dominio.contenido;
using Fe.Dominio.contenido.Datos;
using FEWebApplication.Controladores.Dominio.Contenido;
using FEWebApplication.Controladores.Dominio.Devolucion;
using FEWebApplication.Controladores.Dominio.Factura;
using FEWebApplication.Controladores.Dominio.Pedido;
using FEWebApplication.Controladores.Dominio.Trueque;
using Fe.Core.General;
using Fe.Dominio.devoluciones.Negocio;
using Fe.Dominio.devoluciones;
using Fe.Dominio.facturas.Negocio;
using Fe.Dominio.facturas;
using Fe.Dominio.pedidos.Negocio;
using Fe.Dominio.pedidos;
using Fe.Dominio.trueques.Negocio;
using Fe.Dominio.trueques;

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

            services.AddScoped<AuthenticateController>();
            services.AddScoped<COGeneralController>();
            services.AddScoped<COContenidoController>();
            services.AddScoped<DEDevolucionController>();
            services.AddScoped<FAFacturaController>();
            services.AddScoped<PEPedidoController>();
            services.AddScoped<TRTruequeController>();

            services.AddScoped<COGeneralBiz>();
            services.AddScoped<COSeguridadBiz>();
            services.AddScoped<COContenidoBiz>();
            services.AddScoped<DEDevolucionesBiz>();
            services.AddScoped<FAFacturaBiz>();
            services.AddScoped<PEPedidoBiz>();
            services.AddScoped<TRTruequeBiz>();

            services.AddScoped<COFachada>();
            services.AddScoped<COGeneralFachada>();
            services.AddScoped<DEFachada>();
            services.AddScoped<FAFachada>();
            services.AddScoped<PEFachada>();
            services.AddScoped<TRFachada>();

            services.AddScoped<RepoCategoria>();
            services.AddScoped<RepoPoblacion>();
            services.AddScoped<RepoDemografia>();
            services.AddScoped<RepoDocumento>();
            services.AddScoped<RepoTipoPublicacion>();
            services.AddScoped<RepoProducto>();
            services.AddScoped<RepoResena>();
            services.AddScoped<RepoFaqCor>();
            services.AddScoped<RepoPyR>();

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
