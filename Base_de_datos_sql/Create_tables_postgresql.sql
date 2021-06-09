-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2021-02-04 21:31:17.07

-- tables
-- Table: categoria_pc
CREATE TABLE categoria_pc (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(30)  NULL,
    creacion timestamp  NULL,
    CONSTRAINT categoria_pc_pk PRIMARY KEY (id)
);

-- Table: concepto_dev
CREATE TABLE concepto_dev (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(25)  NULL,
    descripcion text  NULL,
    estado varchar(5)  NULL,
    creacion timestamp  NULL,
    CONSTRAINT concepto_dev_pk PRIMARY KEY (id)
);

-- Table: demografia_cor
CREATE TABLE demografia_cor (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(20)  NULL,
    apellido varchar(20)  NULL,
    numeroDocumento int  NULL,
    telefono int  NULL,
    aceptoTerminosCondiciones int  NULL,
    creacion timestamp  NULL,
    modificacion timestamp  NULL,
    direccion varchar(50)  NULL,
    estado varchar(5)  NULL,
    rolCorId int  NOT NULL,
    tipoDocumentoCorId int  NOT NULL,
    idRazonSocial int  NOT NULL,
    idPoblacion int  NOT NULL,
    CONSTRAINT demografia_cor_pk PRIMARY KEY (id)
);

CREATE INDEX demografia_cor_rol_cor_id_idx on demografia_cor (rolCorId ASC);

CREATE INDEX demografia_cor_tipo_documento_cor_id_idx on demografia_cor (tipoDocumentoCorId ASC);

CREATE INDEX demografia_cor_id_razon_social_idx on demografia_cor (idRazonSocial ASC);

CREATE INDEX demografia_cor_id_poblacion_idx on demografia_cor (idPoblacion ASC);

-- Table: devoluciones_detalle_dev
CREATE TABLE devoluciones_detalle_dev (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    idDevolucion int  NOT NULL,
    IdProducto int  NULL,
    cantidad int  NULL,
    idConcepto int  NOT NULL,
    estado varchar(5)  NULL,
    creacion timestamp  NULL,
    CONSTRAINT devoluciones_detalle_dev_pk PRIMARY KEY (id)
);

CREATE INDEX devoluciones_detalle_dev_id_devolucion_idx on devoluciones_detalle_dev (idDevolucion ASC);

CREATE INDEX devoluciones_detalle_dev_id_concepto_idx on devoluciones_detalle_dev (idConcepto ASC);

-- Table: devoluciones_dev
CREATE TABLE devoluciones_dev (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    idPedido int  NOT NULL,
    idFactura int  NOT NULL,
    fecha timestamp  NULL,
    estado varchar(5)  NULL,
    CONSTRAINT devoluciones_dev_pk PRIMARY KEY (id)
);

CREATE INDEX devoluciones_dev_id_pedido_idx on devoluciones_dev (idPedido ASC);

CREATE INDEX devoluciones_dev_id_factura_idx on devoluciones_dev (idFactura ASC);

-- Table: error_log
CREATE TABLE error_log (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    mensaje text  NULL,
    traza text  NULL,
    creacion timestamp  NULL,
    CONSTRAINT error_log_pk PRIMARY KEY (id)
);

-- Table: estado_poblacion_cor
CREATE TABLE estado_poblacion_cor (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(30)  NULL,
    CONSTRAINT estado_poblacion_cor_pk PRIMARY KEY (id)
);

-- Table: facturas_Fac
CREATE TABLE facturas_Fac (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    idPedido int  NOT NULL,
    fechaFactura timestamp  NULL,
    fechaEntrega timestamp  NULL,
    valorTotalFactura int  NULL,
    valorTotalFacturaIVA int  NULL,
    CONSTRAINT facturas_Fac_pk PRIMARY KEY (id)
);

CREATE INDEX facturas_Fac_id_pedido_idx on facturas_Fac (idPedido ASC);

-- Table: faq_cor
CREATE TABLE faq_cor (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    pregunta text  NULL,
    respuesta text  NULL,
    CONSTRAINT faq_cor_pk PRIMARY KEY (id)
);

-- Table: notificaciones_cor
CREATE TABLE notificaciones_cor (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    detalle varchar(100)  NULL,
    idUsuario int  NOT NULL,
    creacion timestamp  NULL,
    estado varchar(5)  NULL,
    CONSTRAINT notificaciones_cor_pk PRIMARY KEY (id)
);

CREATE INDEX notificaciones_cor_id_usuario_idx on notificaciones_cor (idUsuario ASC);

-- Table: pedidos_ped
CREATE TABLE pedidos_ped (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    idUsuario int  NOT NULL,
    estado varchar(5)  NULL,
    fechaPedido timestamp  NULL,
    CONSTRAINT pedidos_ped_pk PRIMARY KEY (id)
);

CREATE INDEX pedidos_ped_id_usuario_idx on pedidos_ped (idUsuario ASC);

-- Table: poblacion_cor
CREATE TABLE poblacion_cor (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(20)  NULL,
    estado varchar(5)  NULL,
    idEstadoPoblacion int  NOT NULL,
    CONSTRAINT poblacion_cor_pk PRIMARY KEY (id)
);

CREATE INDEX poblacion_cor_id_estado_poblacion_idx on poblacion_cor (idEstadoPoblacion ASC);

-- Table: preguntas_respuestas_pc
CREATE TABLE preguntas_respuestas_pc (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    idProductoServicio int  NOT NULL,
    pregunta varchar(50)  NULL,
    respuesta varchar(50)  NULL,
    creacion timestamp  NULL,
    CONSTRAINT preguntas_respuestas_pc_pk PRIMARY KEY (id)
);

CREATE INDEX preguntas_respuestas_pc_id_producto_servicio_idx on preguntas_respuestas_pc (idProductoServicio ASC);

-- Table: prod_ser_trueque_true
CREATE TABLE prod_ser_trueque_true (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    idTruequePedido int  NOT NULL,
    idProductoServicioComprador int  NOT NULL,
    idProductoServicioVendedor int  NOT NULL,
    cantidadComprador int  NULL,
    cantidadVendedor int  NULL,
    creacion timestamp  NULL,
    CONSTRAINT prod_ser_trueque_true_pk PRIMARY KEY (id)
);

CREATE INDEX prod_ser_trueque_true_id_trueque_pedido_idx on prod_ser_trueque_true (idTruequePedido ASC);

CREATE INDEX prod_ser_trueque_true_id_prod_ser_comprador_idx on prod_ser_trueque_true (idProductoServicioComprador ASC);

CREATE INDEX prod_ser_trueque_true_d_prod_ser_vendedor_idx on prod_ser_trueque_true (idProductoServicioVendedor ASC);

-- Table: prod_ser_x_factura_fac
CREATE TABLE prod_ser_x_factura_fac (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    precioFacturado int  NULL,
    cantidadFacturado int  NULL,
    idProductoServicio int  NULL,
    idFactura int  NOT NULL,
    CONSTRAINT prod_ser_x_factura_fac_pk PRIMARY KEY (id)
);

CREATE INDEX prod_ser_x_factura_fac_id_factura on prod_ser_x_factura_fac (idFactura ASC);

-- Table: prod_ser_x_vendidos_ped
CREATE TABLE prod_ser_x_vendidos_ped (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    idProductoServico int  NOT NULL,
    idPedido int  NOT NULL,
    precioTotal int  NULL,
    cantidadesPedida int  NULL,
    creacion timestamp  NULL,
    CONSTRAINT prod_ser_x_vendidos_ped_pk PRIMARY KEY (id)
);

CREATE INDEX prod_ser_x_vendidos_ped_id_prod_ser_idx on prod_ser_x_vendidos_ped (idProductoServico ASC);

CREATE INDEX prod_ser_x_vendidos_ped_id_pedido_idx on prod_ser_x_vendidos_ped (idPedido ASC);

-- Table: productos_servicios_pc
CREATE TABLE productos_servicios_pc (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    idCategoria int  NOT NULL,
    idTipoPublicacion int  NOT NULL,
    idUsuario int  NOT NULL,
    nombre int  NULL,
    descripcion text  NULL,
    cantidadTotal int  NULL,
    tiempoEntrega timestamp  NULL,
    tiempoGarantia timestamp  NULL,
    precioUnitario int  NULL,
    descuento decimal(5,3)  NULL,
    estado varchar(5)  NULL,
    calificacionPromedio decimal(10,5)  NULL,
    habilitaTrueque int  NULL,
    creacion timestamp  NULL,
    CONSTRAINT productos_servicios_pc_pk PRIMARY KEY (id)
);

CREATE INDEX productos_servicios_pc_id_categoria_idx on productos_servicios_pc (idCategoria ASC);

CREATE INDEX productos_servicios_pc_id_tipo_publicacion_idx on productos_servicios_pc (idTipoPublicacion ASC);

CREATE INDEX productos_servicios_pc_id_usuario_idx on productos_servicios_pc (idUsuario ASC);

-- Table: razon_social_cor
CREATE TABLE razon_social_cor (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(30)  NULL,
    direccion varchar(30)  NULL,
    telefono int  NULL,
    estado varchar(5)  NULL,
    creacion timestamp  NULL,
    CONSTRAINT razon_social_cor_pk PRIMARY KEY (id)
);

-- Table: resenas_pc
CREATE TABLE resenas_pc (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    idPublicacion int  NOT NULL,
    comentarios text  NULL,
    puntuacion decimal(2,2)  NULL,
    creacion timestamp  NULL,
    CONSTRAINT resenas_pc_pk PRIMARY KEY (id)
);

CREATE INDEX resenas_pc_id_publicacion_idx on resenas_pc (idPublicacion ASC);

-- Table: rol_cor
CREATE TABLE rol_cor (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(30)  NULL,
    creacion timestamp  NULL,
    CONSTRAINT rol_cor_pk PRIMARY KEY (id)
);

-- Table: tipo_documento_cor
CREATE TABLE tipo_documento_cor (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(25)  NULL,
    creacion timestamp  NULL,
    CONSTRAINT tipo_documento_cor_pk PRIMARY KEY (id)
);

-- Table: tipo_publicacion_pc
CREATE TABLE tipo_publicacion_pc (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    nombre varchar(30)  NULL,
    CONSTRAINT tipo_publicacion_pc_pk PRIMARY KEY (id)
);

-- Table: trueques_pedido_true
CREATE TABLE trueques_pedido_true (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    idComprador int  NOT NULL,
    idVendedor int  NOT NULL,
    estado varchar(5)  NULL,
    fechaTrueque timestamp  NULL,
    CONSTRAINT trueques_pedido_true_pk PRIMARY KEY (id)
);

CREATE INDEX trueques_pedido_true_id_comprador_idx on trueques_pedido_true (idComprador ASC);

CREATE INDEX trueques_pedido_true_id_vendedor_idx on trueques_pedido_true (idVendedor ASC);

-- Table: usuario_cor
CREATE TABLE usuario_cor (
    id int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    email varchar(50)  NULL,
    password varchar(50)  NULL,
    creacion timestamp  NULL,
    modificacion timestamp  NULL,
    estado varchar(5)  NULL,
    rolCorId int  NOT NULL,
    CONSTRAINT usuario_cor_pk PRIMARY KEY (id)
);

CREATE INDEX usuario_cor_rol_cor_id_idx on usuario_cor (rolCorId ASC);

-- foreign keys
-- Reference: demografia_cor_razon_social_cor (table: demografia_cor)
ALTER TABLE demografia_cor ADD CONSTRAINT demografia_cor_razon_social_cor
    FOREIGN KEY (idRazonSocial)
    REFERENCES razon_social_cor (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: demografia_cor_rol_cor (table: demografia_cor)
ALTER TABLE demografia_cor ADD CONSTRAINT demografia_cor_rol_cor
    FOREIGN KEY (rolCorId)
    REFERENCES rol_cor (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: demografia_cor_tipo_documento_cor (table: demografia_cor)
ALTER TABLE demografia_cor ADD CONSTRAINT demografia_cor_tipo_documento_cor
    FOREIGN KEY (tipoDocumentoCorId)
    REFERENCES tipo_documento_cor (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: demografia_poblacion_cor (table: demografia_cor)
ALTER TABLE demografia_cor ADD CONSTRAINT demografia_poblacion_cor
    FOREIGN KEY (idPoblacion)
    REFERENCES poblacion_cor (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: devoluciones_detalle_dev_concepto_dev (table: devoluciones_detalle_dev)
ALTER TABLE devoluciones_detalle_dev ADD CONSTRAINT devoluciones_detalle_dev_concepto_dev
    FOREIGN KEY (idConcepto)
    REFERENCES concepto_dev (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: devoluciones_detalle_dev_devoluciones_dev (table: devoluciones_detalle_dev)
ALTER TABLE devoluciones_detalle_dev ADD CONSTRAINT devoluciones_detalle_dev_devoluciones_dev
    FOREIGN KEY (idDevolucion)
    REFERENCES devoluciones_dev (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: devoluciones_dev_facturas_Fac (table: devoluciones_dev)
ALTER TABLE devoluciones_dev ADD CONSTRAINT devoluciones_dev_facturas_Fac
    FOREIGN KEY (idFactura)
    REFERENCES facturas_Fac (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: devoluciones_dev_pedidos_ped (table: devoluciones_dev)
ALTER TABLE devoluciones_dev ADD CONSTRAINT devoluciones_dev_pedidos_ped
    FOREIGN KEY (idPedido)
    REFERENCES pedidos_ped (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: estado_poblacion_cor (table: poblacion_cor)
ALTER TABLE poblacion_cor ADD CONSTRAINT estado_poblacion_cor
    FOREIGN KEY (idEstadoPoblacion)
    REFERENCES estado_poblacion_cor (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: facturas_Fac_pedidos_ped (table: facturas_Fac)
ALTER TABLE facturas_Fac ADD CONSTRAINT facturas_Fac_pedidos_ped
    FOREIGN KEY (idPedido)
    REFERENCES pedidos_ped (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: notificaciones_cor_usuario_cor (table: notificaciones_cor)
ALTER TABLE notificaciones_cor ADD CONSTRAINT notificaciones_cor_usuario_cor
    FOREIGN KEY (idUsuario)
    REFERENCES usuario_cor (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: pedidos_ped_usuario_cor (table: pedidos_ped)
ALTER TABLE pedidos_ped ADD CONSTRAINT pedidos_ped_usuario_cor
    FOREIGN KEY (idUsuario)
    REFERENCES usuario_cor (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: preguntas_respuestas_pc_productos_servicios_pc (table: preguntas_respuestas_pc)
ALTER TABLE preguntas_respuestas_pc ADD CONSTRAINT preguntas_respuestas_pc_productos_servicios_pc
    FOREIGN KEY (idProductoServicio)
    REFERENCES productos_servicios_pc (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: prod_ser_trueque_true_trueques_pedido_true (table: prod_ser_trueque_true)
ALTER TABLE prod_ser_trueque_true ADD CONSTRAINT prod_ser_trueque_true_trueques_pedido_true
    FOREIGN KEY (idTruequePedido)
    REFERENCES trueques_pedido_true (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: prod_ser_x_factura_fac_facturas_Fac (table: prod_ser_x_factura_fac)
ALTER TABLE prod_ser_x_factura_fac ADD CONSTRAINT prod_ser_x_factura_fac_facturas_Fac
    FOREIGN KEY (idFactura)
    REFERENCES facturas_Fac (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: prod_ser_x_vendidos_ped_pedidos_ped (table: prod_ser_x_vendidos_ped)
ALTER TABLE prod_ser_x_vendidos_ped ADD CONSTRAINT prod_ser_x_vendidos_ped_pedidos_ped
    FOREIGN KEY (idPedido)
    REFERENCES pedidos_ped (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: prod_ser_x_vendidos_ped_productos_servicios_pc (table: prod_ser_x_vendidos_ped)
ALTER TABLE prod_ser_x_vendidos_ped ADD CONSTRAINT prod_ser_x_vendidos_ped_productos_servicios_pc
    FOREIGN KEY (idProductoServico)
    REFERENCES productos_servicios_pc (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: productos_servicios_pc_categoria_pc (table: productos_servicios_pc)
ALTER TABLE productos_servicios_pc ADD CONSTRAINT productos_servicios_pc_categoria_pc
    FOREIGN KEY (idCategoria)
    REFERENCES categoria_pc (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: productos_servicios_pc_tipo_publicacion_pc (table: productos_servicios_pc)
ALTER TABLE productos_servicios_pc ADD CONSTRAINT productos_servicios_pc_tipo_publicacion_pc
    FOREIGN KEY (idTipoPublicacion)
    REFERENCES tipo_publicacion_pc (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: productos_servicios_pc_usuario_cor (table: productos_servicios_pc)
ALTER TABLE productos_servicios_pc ADD CONSTRAINT productos_servicios_pc_usuario_cor
    FOREIGN KEY (idUsuario)
    REFERENCES usuario_cor (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: resenas_pc_productos_servicios_pc (table: resenas_pc)
ALTER TABLE resenas_pc ADD CONSTRAINT resenas_pc_productos_servicios_pc
    FOREIGN KEY (idPublicacion)
    REFERENCES productos_servicios_pc (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: trueque_true_productos_servicios_idComprador (table: prod_ser_trueque_true)
ALTER TABLE prod_ser_trueque_true ADD CONSTRAINT trueque_true_productos_servicios_idComprador
    FOREIGN KEY (idProductoServicioComprador)
    REFERENCES productos_servicios_pc (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: trueque_true_productos_servicios_idVendedor (table: prod_ser_trueque_true)
ALTER TABLE prod_ser_trueque_true ADD CONSTRAINT trueque_true_productos_servicios_idVendedor
    FOREIGN KEY (idProductoServicioVendedor)
    REFERENCES productos_servicios_pc (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: trueques_pedido_usuario_cor_id_comprador (table: trueques_pedido_true)
ALTER TABLE trueques_pedido_true ADD CONSTRAINT trueques_pedido_usuario_cor_id_comprador
    FOREIGN KEY (idComprador)
    REFERENCES usuario_cor (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: trueques_pedido_usuario_cor_id_vendedor (table: trueques_pedido_true)
ALTER TABLE trueques_pedido_true ADD CONSTRAINT trueques_pedido_usuario_cor_id_vendedor
    FOREIGN KEY (idVendedor)
    REFERENCES usuario_cor (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: usuario_cor_rol_cor (table: usuario_cor)
ALTER TABLE usuario_cor ADD CONSTRAINT usuario_cor_rol_cor
    FOREIGN KEY (rolCorId)
    REFERENCES rol_cor (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

