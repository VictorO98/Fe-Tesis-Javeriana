using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Fe.Servidor.Middleware.Modelo.Entidades;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Contexto
{
    public partial class FeContext : DbContext
    {
        public FeContext()
        {
        }

        public FeContext(DbContextOptions<FeContext> options)
            : base(options)
        {
        }

        public virtual DbSet<CategoriaPc> CategoriaPcs { get; set; }
        public virtual DbSet<ConceptoDev> ConceptoDevs { get; set; }
        public virtual DbSet<DemografiaCor> DemografiaCors { get; set; }
        public virtual DbSet<DevolucionesDetalleDev> DevolucionesDetalleDevs { get; set; }
        public virtual DbSet<DevolucionesDev> DevolucionesDevs { get; set; }
        public virtual DbSet<ErrorLog> ErrorLogs { get; set; }
        public virtual DbSet<EstadoPoblacionCor> EstadoPoblacionCors { get; set; }
        public virtual DbSet<FacturasFac> FacturasFacs { get; set; }
        public virtual DbSet<FaqCor> FaqCors { get; set; }
        public virtual DbSet<FavoritosUsuarioProductosPc> FavoritosUsuarioProductosPcs { get; set; }
        public virtual DbSet<NotificacionesCor> NotificacionesCors { get; set; }
        public virtual DbSet<PedidosPed> PedidosPeds { get; set; }
        public virtual DbSet<PoblacionCor> PoblacionCors { get; set; }
        public virtual DbSet<PreguntasRespuestasPc> PreguntasRespuestasPcs { get; set; }
        public virtual DbSet<ProdSerTruequeTrue> ProdSerTruequeTrues { get; set; }
        public virtual DbSet<ProdSerXFacturaFac> ProdSerXFacturaFacs { get; set; }
        public virtual DbSet<ProdSerXVendidosPed> ProdSerXVendidosPeds { get; set; }
        public virtual DbSet<ProductosServiciosPc> ProductosServiciosPcs { get; set; }
        public virtual DbSet<RazonSocialCor> RazonSocialCors { get; set; }
        public virtual DbSet<ResenasPc> ResenasPcs { get; set; }
        public virtual DbSet<RolCor> RolCors { get; set; }
        public virtual DbSet<TipoDocumentoCor> TipoDocumentoCors { get; set; }
        public virtual DbSet<TipoPublicacionPc> TipoPublicacionPcs { get; set; }
        public virtual DbSet<TruequesPedidoTrue> TruequesPedidoTrues { get; set; }
        public virtual DbSet<UsuarioCor> UsuarioCors { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseNpgsql("server=157.230.83.145;port=5432;database=comunidad-fe-db;uid=postgres;password=NoTieneContra123");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("Relational:Collation", "C.UTF-8");

            modelBuilder.Entity<CategoriaPc>(entity =>
            {
                entity.ToTable("categoria_pc");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Nombre)
                    .HasMaxLength(30)
                    .HasColumnName("nombre");
            });

            modelBuilder.Entity<ConceptoDev>(entity =>
            {
                entity.ToTable("concepto_dev");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Descripcion).HasColumnName("descripcion");

                entity.Property(e => e.Estado)
                    .HasMaxLength(5)
                    .HasColumnName("estado");

                entity.Property(e => e.Nombre)
                    .HasMaxLength(25)
                    .HasColumnName("nombre");
            });

            modelBuilder.Entity<DemografiaCor>(entity =>
            {
                entity.ToTable("demografia_cor");

                entity.HasIndex(e => e.Idpoblacion, "demografia_cor_id_poblacion_idx");

                entity.HasIndex(e => e.Idrazonsocial, "demografia_cor_id_razon_social_idx");

                entity.HasIndex(e => e.Rolcorid, "demografia_cor_rol_cor_id_idx");

                entity.HasIndex(e => e.Tipodocumentocorid, "demografia_cor_tipo_documento_cor_id_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Aceptoterminoscondiciones).HasColumnName("aceptoterminoscondiciones");

                entity.Property(e => e.Apellido)
                    .HasMaxLength(20)
                    .HasColumnName("apellido");

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Direccion)
                    .HasMaxLength(50)
                    .HasColumnName("direccion");

                entity.Property(e => e.Estado)
                    .HasMaxLength(5)
                    .HasColumnName("estado");

                entity.Property(e => e.Idpoblacion).HasColumnName("idpoblacion");

                entity.Property(e => e.Idrazonsocial).HasColumnName("idrazonsocial");

                entity.Property(e => e.Modificacion).HasColumnName("modificacion");

                entity.Property(e => e.Nombre)
                    .HasMaxLength(20)
                    .HasColumnName("nombre");

                entity.Property(e => e.Numerodocumento).HasColumnName("numerodocumento");

                entity.Property(e => e.Rolcorid).HasColumnName("rolcorid");

                entity.Property(e => e.Telefono).HasColumnName("telefono");

                entity.Property(e => e.Tipodocumentocorid).HasColumnName("tipodocumentocorid");

                entity.HasOne(d => d.IdpoblacionNavigation)
                    .WithMany(p => p.DemografiaCors)
                    .HasForeignKey(d => d.Idpoblacion)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("demografia_poblacion_cor");

                entity.HasOne(d => d.IdrazonsocialNavigation)
                    .WithMany(p => p.DemografiaCors)
                    .HasForeignKey(d => d.Idrazonsocial)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("demografia_cor_razon_social_cor");

                entity.HasOne(d => d.Rolcor)
                    .WithMany(p => p.DemografiaCors)
                    .HasForeignKey(d => d.Rolcorid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("demografia_cor_rol_cor");

                entity.HasOne(d => d.Tipodocumentocor)
                    .WithMany(p => p.DemografiaCors)
                    .HasForeignKey(d => d.Tipodocumentocorid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("demografia_cor_tipo_documento_cor");
            });

            modelBuilder.Entity<DevolucionesDetalleDev>(entity =>
            {
                entity.ToTable("devoluciones_detalle_dev");

                entity.HasIndex(e => e.Idconcepto, "devoluciones_detalle_dev_id_concepto_idx");

                entity.HasIndex(e => e.Iddevolucion, "devoluciones_detalle_dev_id_devolucion_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Cantidad).HasColumnName("cantidad");

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Estado)
                    .HasMaxLength(5)
                    .HasColumnName("estado");

                entity.Property(e => e.Idconcepto).HasColumnName("idconcepto");

                entity.Property(e => e.Iddevolucion).HasColumnName("iddevolucion");

                entity.Property(e => e.Idproducto).HasColumnName("idproducto");

                entity.HasOne(d => d.IdconceptoNavigation)
                    .WithMany(p => p.DevolucionesDetalleDevs)
                    .HasForeignKey(d => d.Idconcepto)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("devoluciones_detalle_dev_concepto_dev");

                entity.HasOne(d => d.IddevolucionNavigation)
                    .WithMany(p => p.DevolucionesDetalleDevs)
                    .HasForeignKey(d => d.Iddevolucion)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("devoluciones_detalle_dev_devoluciones_dev");
            });

            modelBuilder.Entity<DevolucionesDev>(entity =>
            {
                entity.ToTable("devoluciones_dev");

                entity.HasIndex(e => e.Idfactura, "devoluciones_dev_id_factura_idx");

                entity.HasIndex(e => e.Idpedido, "devoluciones_dev_id_pedido_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Estado)
                    .HasMaxLength(5)
                    .HasColumnName("estado");

                entity.Property(e => e.Fecha).HasColumnName("fecha");

                entity.Property(e => e.Idfactura).HasColumnName("idfactura");

                entity.Property(e => e.Idpedido).HasColumnName("idpedido");

                entity.HasOne(d => d.IdfacturaNavigation)
                    .WithMany(p => p.DevolucionesDevs)
                    .HasForeignKey(d => d.Idfactura)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("devoluciones_dev_facturas_fac");

                entity.HasOne(d => d.IdpedidoNavigation)
                    .WithMany(p => p.DevolucionesDevs)
                    .HasForeignKey(d => d.Idpedido)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("devoluciones_dev_pedidos_ped");
            });

            modelBuilder.Entity<ErrorLog>(entity =>
            {
                entity.ToTable("error_log");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Mensaje).HasColumnName("mensaje");

                entity.Property(e => e.Traza).HasColumnName("traza");
            });

            modelBuilder.Entity<EstadoPoblacionCor>(entity =>
            {
                entity.ToTable("estado_poblacion_cor");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Nombre)
                    .HasMaxLength(30)
                    .HasColumnName("nombre");
            });

            modelBuilder.Entity<FacturasFac>(entity =>
            {
                entity.ToTable("facturas_fac");

                entity.HasIndex(e => e.Idpedido, "facturas_fac_id_pedido_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Fechaentrega).HasColumnName("fechaentrega");

                entity.Property(e => e.Fechafactura).HasColumnName("fechafactura");

                entity.Property(e => e.Idpedido).HasColumnName("idpedido");

                entity.Property(e => e.Valortotalfactura).HasColumnName("valortotalfactura");

                entity.Property(e => e.Valortotalfacturaiva).HasColumnName("valortotalfacturaiva");

                entity.HasOne(d => d.IdpedidoNavigation)
                    .WithMany(p => p.FacturasFacs)
                    .HasForeignKey(d => d.Idpedido)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("facturas_fac_pedidos_ped");
            });

            modelBuilder.Entity<FaqCor>(entity =>
            {
                entity.ToTable("faq_cor");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Pregunta).HasColumnName("pregunta");

                entity.Property(e => e.Respuesta).HasColumnName("respuesta");
            });

            modelBuilder.Entity<FavoritosUsuarioProductosPc>(entity =>
            {
                entity.ToTable("favoritos_usuario_productos_pc");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn()
                    .HasIdentityOptions(null, null, null, 99999L, null, null);

                entity.Property(e => e.Creacion)
                    .HasColumnType("timestamp with time zone")
                    .HasColumnName("creacion");

                entity.Property(e => e.Estado)
                    .IsRequired()
                    .HasColumnType("character varying(3)[]")
                    .HasColumnName("estado");

                entity.Property(e => e.IdProductoServicio).HasColumnName("idProductoServicio");

                entity.Property(e => e.IdUsuario).HasColumnName("idUsuario");

                entity.HasOne(d => d.IdProductoServicioNavigation)
                    .WithMany(p => p.FavoritosUsuarioProductosPcs)
                    .HasForeignKey(d => d.IdProductoServicio)
                    .HasConstraintName("id_prod_ser_fk");

                entity.HasOne(d => d.IdUsuarioNavigation)
                    .WithMany(p => p.FavoritosUsuarioProductosPcs)
                    .HasForeignKey(d => d.IdUsuario)
                    .HasConstraintName("id_usuario_fk");
            });

            modelBuilder.Entity<NotificacionesCor>(entity =>
            {
                entity.ToTable("notificaciones_cor");

                entity.HasIndex(e => e.Idusuario, "notificaciones_cor_id_usuario_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Detalle)
                    .HasMaxLength(100)
                    .HasColumnName("detalle");

                entity.Property(e => e.Estado)
                    .HasMaxLength(5)
                    .HasColumnName("estado");

                entity.Property(e => e.Idusuario).HasColumnName("idusuario");

                entity.HasOne(d => d.IdusuarioNavigation)
                    .WithMany(p => p.NotificacionesCors)
                    .HasForeignKey(d => d.Idusuario)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("notificaciones_cor_usuario_cor");
            });

            modelBuilder.Entity<PedidosPed>(entity =>
            {
                entity.ToTable("pedidos_ped");

                entity.HasIndex(e => e.Idusuario, "pedidos_ped_id_usuario_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Estado)
                    .HasMaxLength(5)
                    .HasColumnName("estado");

                entity.Property(e => e.Fechapedido).HasColumnName("fechapedido");

                entity.Property(e => e.Idusuario).HasColumnName("idusuario");

                entity.HasOne(d => d.IdusuarioNavigation)
                    .WithMany(p => p.PedidosPeds)
                    .HasForeignKey(d => d.Idusuario)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("pedidos_ped_usuario_cor");
            });

            modelBuilder.Entity<PoblacionCor>(entity =>
            {
                entity.ToTable("poblacion_cor");

                entity.HasIndex(e => e.Idestadopoblacion, "poblacion_cor_id_estado_poblacion_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Estado)
                    .HasMaxLength(5)
                    .HasColumnName("estado");

                entity.Property(e => e.Idestadopoblacion).HasColumnName("idestadopoblacion");

                entity.Property(e => e.Nombre)
                    .HasMaxLength(20)
                    .HasColumnName("nombre");

                entity.HasOne(d => d.IdestadopoblacionNavigation)
                    .WithMany(p => p.PoblacionCors)
                    .HasForeignKey(d => d.Idestadopoblacion)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("estado_poblacion_cor");
            });

            modelBuilder.Entity<PreguntasRespuestasPc>(entity =>
            {
                entity.ToTable("preguntas_respuestas_pc");

                entity.HasIndex(e => e.Idproductoservicio, "preguntas_respuestas_pc_id_producto_servicio_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Idproductoservicio).HasColumnName("idproductoservicio");

                entity.Property(e => e.Pregunta)
                    .HasMaxLength(50)
                    .HasColumnName("pregunta");

                entity.Property(e => e.Respuesta)
                    .HasMaxLength(50)
                    .HasColumnName("respuesta");

                entity.HasOne(d => d.IdproductoservicioNavigation)
                    .WithMany(p => p.PreguntasRespuestasPcs)
                    .HasForeignKey(d => d.Idproductoservicio)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("preguntas_respuestas_pc_productos_servicios_pc");
            });

            modelBuilder.Entity<ProdSerTruequeTrue>(entity =>
            {
                entity.ToTable("prod_ser_trueque_true");

                entity.HasIndex(e => e.Idproductoserviciovendedor, "prod_ser_trueque_true_d_prod_ser_vendedor_idx");

                entity.HasIndex(e => e.Idproductoserviciocomprador, "prod_ser_trueque_true_id_prod_ser_comprador_idx");

                entity.HasIndex(e => e.Idtruequepedido, "prod_ser_trueque_true_id_trueque_pedido_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Cantidadcomprador).HasColumnName("cantidadcomprador");

                entity.Property(e => e.Cantidadvendedor).HasColumnName("cantidadvendedor");

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Idproductoserviciocomprador).HasColumnName("idproductoserviciocomprador");

                entity.Property(e => e.Idproductoserviciovendedor).HasColumnName("idproductoserviciovendedor");

                entity.Property(e => e.Idtruequepedido).HasColumnName("idtruequepedido");

                entity.HasOne(d => d.IdproductoserviciocompradorNavigation)
                    .WithMany(p => p.ProdSerTruequeTrueIdproductoserviciocompradorNavigations)
                    .HasForeignKey(d => d.Idproductoserviciocomprador)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("trueque_true_productos_servicios_idcomprador");

                entity.HasOne(d => d.IdproductoserviciovendedorNavigation)
                    .WithMany(p => p.ProdSerTruequeTrueIdproductoserviciovendedorNavigations)
                    .HasForeignKey(d => d.Idproductoserviciovendedor)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("trueque_true_productos_servicios_idvendedor");

                entity.HasOne(d => d.IdtruequepedidoNavigation)
                    .WithMany(p => p.ProdSerTruequeTrues)
                    .HasForeignKey(d => d.Idtruequepedido)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("prod_ser_trueque_true_trueques_pedido_true");
            });

            modelBuilder.Entity<ProdSerXFacturaFac>(entity =>
            {
                entity.ToTable("prod_ser_x_factura_fac");

                entity.HasIndex(e => e.Idfactura, "prod_ser_x_factura_fac_id_factura");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Cantidadfacturado).HasColumnName("cantidadfacturado");

                entity.Property(e => e.Idfactura).HasColumnName("idfactura");

                entity.Property(e => e.Idproductoservicio).HasColumnName("idproductoservicio");

                entity.Property(e => e.Preciofacturado).HasColumnName("preciofacturado");

                entity.HasOne(d => d.IdfacturaNavigation)
                    .WithMany(p => p.ProdSerXFacturaFacs)
                    .HasForeignKey(d => d.Idfactura)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("prod_ser_x_factura_fac_facturas_fac");
            });

            modelBuilder.Entity<ProdSerXVendidosPed>(entity =>
            {
                entity.ToTable("prod_ser_x_vendidos_ped");

                entity.HasIndex(e => e.Idpedido, "prod_ser_x_vendidos_ped_id_pedido_idx");

                entity.HasIndex(e => e.Idproductoservico, "prod_ser_x_vendidos_ped_id_prod_ser_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Cantidadespedida).HasColumnName("cantidadespedida");

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Idpedido).HasColumnName("idpedido");

                entity.Property(e => e.Idproductoservico).HasColumnName("idproductoservico");

                entity.Property(e => e.Preciototal).HasColumnName("preciototal");

                entity.HasOne(d => d.IdpedidoNavigation)
                    .WithMany(p => p.ProdSerXVendidosPeds)
                    .HasForeignKey(d => d.Idpedido)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("prod_ser_x_vendidos_ped_pedidos_ped");

                entity.HasOne(d => d.IdproductoservicoNavigation)
                    .WithMany(p => p.ProdSerXVendidosPeds)
                    .HasForeignKey(d => d.Idproductoservico)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("prod_ser_x_vendidos_ped_productos_servicios_pc");
            });

            modelBuilder.Entity<ProductosServiciosPc>(entity =>
            {
                entity.ToTable("productos_servicios_pc");

                entity.HasIndex(e => e.Idcategoria, "productos_servicios_pc_id_categoria_idx");

                entity.HasIndex(e => e.Idtipopublicacion, "productos_servicios_pc_id_tipo_publicacion_idx");

                entity.HasIndex(e => e.Idusuario, "productos_servicios_pc_id_usuario_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Calificacionpromedio)
                    .HasPrecision(10, 5)
                    .HasColumnName("calificacionpromedio");

                entity.Property(e => e.Cantidadtotal).HasColumnName("cantidadtotal");

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Descripcion).HasColumnName("descripcion");

                entity.Property(e => e.Descuento)
                    .HasPrecision(5, 3)
                    .HasColumnName("descuento");

                entity.Property(e => e.Estado)
                    .HasMaxLength(5)
                    .HasColumnName("estado");

                entity.Property(e => e.Habilitatrueque).HasColumnName("habilitatrueque");

                entity.Property(e => e.Idcategoria).HasColumnName("idcategoria");

                entity.Property(e => e.Idtipopublicacion).HasColumnName("idtipopublicacion");

                entity.Property(e => e.Idusuario).HasColumnName("idusuario");

                entity.Property(e => e.Nombre).HasColumnName("nombre");

                entity.Property(e => e.Preciounitario).HasColumnName("preciounitario");

                entity.Property(e => e.Tiempoentrega).HasColumnName("tiempoentrega");

                entity.Property(e => e.Tiempogarantia).HasColumnName("tiempogarantia");

                entity.HasOne(d => d.IdcategoriaNavigation)
                    .WithMany(p => p.ProductosServiciosPcs)
                    .HasForeignKey(d => d.Idcategoria)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("productos_servicios_pc_categoria_pc");

                entity.HasOne(d => d.IdtipopublicacionNavigation)
                    .WithMany(p => p.ProductosServiciosPcs)
                    .HasForeignKey(d => d.Idtipopublicacion)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("productos_servicios_pc_tipo_publicacion_pc");

                entity.HasOne(d => d.IdusuarioNavigation)
                    .WithMany(p => p.ProductosServiciosPcs)
                    .HasForeignKey(d => d.Idusuario)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("productos_servicios_pc_usuario_cor");
            });

            modelBuilder.Entity<RazonSocialCor>(entity =>
            {
                entity.ToTable("razon_social_cor");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Direccion)
                    .HasMaxLength(30)
                    .HasColumnName("direccion");

                entity.Property(e => e.Estado)
                    .HasMaxLength(5)
                    .HasColumnName("estado");

                entity.Property(e => e.Nombre)
                    .HasMaxLength(30)
                    .HasColumnName("nombre");

                entity.Property(e => e.Telefono).HasColumnName("telefono");
            });

            modelBuilder.Entity<ResenasPc>(entity =>
            {
                entity.ToTable("resenas_pc");

                entity.HasIndex(e => e.Idpublicacion, "resenas_pc_id_publicacion_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Comentarios).HasColumnName("comentarios");

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Idpublicacion).HasColumnName("idpublicacion");

                entity.Property(e => e.Puntuacion)
                    .HasPrecision(2, 2)
                    .HasColumnName("puntuacion");

                entity.HasOne(d => d.IdpublicacionNavigation)
                    .WithMany(p => p.ResenasPcs)
                    .HasForeignKey(d => d.Idpublicacion)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("resenas_pc_productos_servicios_pc");
            });

            modelBuilder.Entity<RolCor>(entity =>
            {
                entity.ToTable("rol_cor");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Nombre)
                    .HasMaxLength(30)
                    .HasColumnName("nombre");
            });

            modelBuilder.Entity<TipoDocumentoCor>(entity =>
            {
                entity.ToTable("tipo_documento_cor");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Nombre)
                    .HasMaxLength(25)
                    .HasColumnName("nombre");
            });

            modelBuilder.Entity<TipoPublicacionPc>(entity =>
            {
                entity.ToTable("tipo_publicacion_pc");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Nombre)
                    .HasMaxLength(30)
                    .HasColumnName("nombre");
            });

            modelBuilder.Entity<TruequesPedidoTrue>(entity =>
            {
                entity.ToTable("trueques_pedido_true");

                entity.HasIndex(e => e.Idcomprador, "trueques_pedido_true_id_comprador_idx");

                entity.HasIndex(e => e.Idvendedor, "trueques_pedido_true_id_vendedor_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Estado)
                    .HasMaxLength(5)
                    .HasColumnName("estado");

                entity.Property(e => e.Fechatrueque).HasColumnName("fechatrueque");

                entity.Property(e => e.Idcomprador).HasColumnName("idcomprador");

                entity.Property(e => e.Idvendedor).HasColumnName("idvendedor");

                entity.HasOne(d => d.IdcompradorNavigation)
                    .WithMany(p => p.TruequesPedidoTrueIdcompradorNavigations)
                    .HasForeignKey(d => d.Idcomprador)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("trueques_pedido_usuario_cor_id_comprador");

                entity.HasOne(d => d.IdvendedorNavigation)
                    .WithMany(p => p.TruequesPedidoTrueIdvendedorNavigations)
                    .HasForeignKey(d => d.Idvendedor)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("trueques_pedido_usuario_cor_id_vendedor");
            });

            modelBuilder.Entity<UsuarioCor>(entity =>
            {
                entity.ToTable("usuario_cor");

                entity.HasIndex(e => e.Rolcorid, "usuario_cor_rol_cor_id_idx");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Creacion).HasColumnName("creacion");

                entity.Property(e => e.Email)
                    .HasMaxLength(50)
                    .HasColumnName("email");

                entity.Property(e => e.Emailconfirmed).HasColumnName("emailconfirmed");

                entity.Property(e => e.Estado)
                    .HasMaxLength(5)
                    .HasColumnName("estado");

                entity.Property(e => e.Modificacion).HasColumnName("modificacion");

                entity.Property(e => e.Passwordhash).HasColumnName("passwordhash");

                entity.Property(e => e.Rolcorid).HasColumnName("rolcorid");

                entity.HasOne(d => d.Rolcor)
                    .WithMany(p => p.UsuarioCors)
                    .HasForeignKey(d => d.Rolcorid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("usuario_cor_rol_cor");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
