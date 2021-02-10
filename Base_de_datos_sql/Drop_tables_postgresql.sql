-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2021-02-04 21:31:17.07

-- foreign keys
ALTER TABLE demografia_cor
    DROP CONSTRAINT demografia_cor_razon_social_cor;

ALTER TABLE demografia_cor
    DROP CONSTRAINT demografia_cor_rol_cor;

ALTER TABLE demografia_cor
    DROP CONSTRAINT demografia_cor_tipo_documento_cor;

ALTER TABLE demografia_cor
    DROP CONSTRAINT demografia_poblacion_cor;

ALTER TABLE devoluciones_detalle_dev
    DROP CONSTRAINT devoluciones_detalle_dev_concepto_dev;

ALTER TABLE devoluciones_detalle_dev
    DROP CONSTRAINT devoluciones_detalle_dev_devoluciones_dev;

ALTER TABLE devoluciones_dev
    DROP CONSTRAINT devoluciones_dev_facturas_Fac;

ALTER TABLE devoluciones_dev
    DROP CONSTRAINT devoluciones_dev_pedidos_ped;

ALTER TABLE poblacion_cor
    DROP CONSTRAINT estado_poblacion_cor;

ALTER TABLE facturas_Fac
    DROP CONSTRAINT facturas_Fac_pedidos_ped;

ALTER TABLE notificaciones_cor
    DROP CONSTRAINT notificaciones_cor_usuario_cor;

ALTER TABLE pedidos_ped
    DROP CONSTRAINT pedidos_ped_usuario_cor;

ALTER TABLE preguntas_respuestas_pc
    DROP CONSTRAINT preguntas_respuestas_pc_productos_servicios_pc;

ALTER TABLE prod_ser_trueque_true
    DROP CONSTRAINT prod_ser_trueque_true_trueques_pedido_true;

ALTER TABLE prod_ser_x_factura_fac
    DROP CONSTRAINT prod_ser_x_factura_fac_facturas_Fac;

ALTER TABLE prod_ser_x_vendidos_ped
    DROP CONSTRAINT prod_ser_x_vendidos_ped_pedidos_ped;

ALTER TABLE prod_ser_x_vendidos_ped
    DROP CONSTRAINT prod_ser_x_vendidos_ped_productos_servicios_pc;

ALTER TABLE productos_servicios_pc
    DROP CONSTRAINT productos_servicios_pc_categoria_pc;

ALTER TABLE productos_servicios_pc
    DROP CONSTRAINT productos_servicios_pc_tipo_publicacion_pc;

ALTER TABLE productos_servicios_pc
    DROP CONSTRAINT productos_servicios_pc_usuario_cor;

ALTER TABLE resenas_pc
    DROP CONSTRAINT resenas_pc_productos_servicios_pc;

ALTER TABLE prod_ser_trueque_true
    DROP CONSTRAINT trueque_true_productos_servicios_idComprador;

ALTER TABLE prod_ser_trueque_true
    DROP CONSTRAINT trueque_true_productos_servicios_idVendedor;

ALTER TABLE trueques_pedido_true
    DROP CONSTRAINT trueques_pedido_usuario_cor_id_comprador;

ALTER TABLE trueques_pedido_true
    DROP CONSTRAINT trueques_pedido_usuario_cor_id_vendedor;

ALTER TABLE usuario_cor
    DROP CONSTRAINT usuario_cor_rol_cor;

-- tables
DROP TABLE categoria_pc;

DROP TABLE concepto_dev;

DROP TABLE demografia_cor;

DROP TABLE devoluciones_detalle_dev;

DROP TABLE devoluciones_dev;

DROP TABLE error_log;

DROP TABLE estado_poblacion_cor;

DROP TABLE facturas_Fac;

DROP TABLE faq_cor;

DROP TABLE notificaciones_cor;

DROP TABLE pedidos_ped;

DROP TABLE poblacion_cor;

DROP TABLE preguntas_respuestas_pc;

DROP TABLE prod_ser_trueque_true;

DROP TABLE prod_ser_x_factura_fac;

DROP TABLE prod_ser_x_vendidos_ped;

DROP TABLE productos_servicios_pc;

DROP TABLE razon_social_cor;

DROP TABLE resenas_pc;

DROP TABLE rol_cor;

DROP TABLE tipo_documento_cor;

DROP TABLE tipo_publicacion_pc;

DROP TABLE trueques_pedido_true;

DROP TABLE usuario_cor;

-- End of file.

