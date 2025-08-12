CREATE DATABASE CazuelaChapinaDB;
GO

USE CazuelaChapinaDB;
GO

CREATE SCHEMA cazuela;
GO

CREATE TABLE cazuela.Sucursales (
    SucursalID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Direccion NVARCHAR(200) NOT NULL,
    Telefono NVARCHAR(20),
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE cazuela.CategoriasProducto (
    CategoriaID TINYINT PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL CHECK (Nombre IN ('Tamal', 'Bebida', 'Combo', 'MateriaPrima', 'Empaque'))
);

CREATE TABLE cazuela.Atributos (
    AtributoID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    Tipo NVARCHAR(20) NOT NULL CHECK (Tipo IN ('Masa', 'Relleno', 'Envase', 'Picante', 'TipoBebida', 'Endulzante', 'Topping'))
);


CREATE TABLE cazuela.Productos (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    CategoriaID TINYINT NOT NULL FOREIGN KEY REFERENCES cazuela.CategoriasProducto(CategoriaID),
    PrecioBase DECIMAL(10,2) NOT NULL CHECK (PrecioBase >= 0),
    UnidadMedida NVARCHAR(20) NULL,
    EsCombo BIT NOT NULL DEFAULT 0,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT CHK_UnidadMedida CHECK (
        (CategoriaID = 1 AND UnidadMedida IN ('Unidad', 'MediaDocena', 'Docena')) -- ID 1 = Tamal
        OR (CategoriaID = 2 AND UnidadMedida IN ('12oz', '1L')) -- ID 2 = Bebida
        OR (CategoriaID > 2 AND UnidadMedida IS NULL) -- Otras categorías
    )
);


CREATE TABLE cazuela.Combos (
    ComboID INT PRIMARY KEY FOREIGN KEY REFERENCES cazuela.Productos(ProductoID),
    Descripcion NVARCHAR(255),
    EsEstacional BIT NOT NULL DEFAULT 0,
    FechaInicio DATE,
    FechaFin DATE
);

CREATE TABLE cazuela.ComboItems (
    ComboItemID BIGINT IDENTITY(1,1) PRIMARY KEY,
    ComboID INT NOT NULL FOREIGN KEY REFERENCES cazuela.Combos(ComboID),
    ProductoID INT NOT NULL FOREIGN KEY REFERENCES cazuela.Productos(ProductoID),
    Cantidad DECIMAL(10,2) NOT NULL CHECK (Cantidad > 0),
    INDEX IX_ComboItems_ComboID (ComboID)
);


CREATE TABLE cazuela.ProductoAtributos (
    ProductoAtributoID BIGINT IDENTITY(1,1) PRIMARY KEY,
    ProductoID INT NOT NULL FOREIGN KEY REFERENCES cazuela.Productos(ProductoID),
    AtributoID SMALLINT NOT NULL FOREIGN KEY REFERENCES cazuela.Atributos(AtributoID),
    Valor NVARCHAR(100) NOT NULL,
    CostoAdicional DECIMAL(10,2) DEFAULT 0,
    INDEX IX_ProductoAtributos_ProductoID (ProductoID)
);


CREATE TABLE cazuela.MateriasPrimas (
    MateriaPrimaID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Tipo NVARCHAR(20) NOT NULL CHECK (Tipo IN ('Masa', 'Hoja', 'Proteina', 'Granos', 'Endulzante', 'Especia', 'Empaque', 'Combustible')),
    UnidadMedida NVARCHAR(20) NOT NULL,
    StockMinimo DECIMAL(10,2) NOT NULL DEFAULT 0,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE cazuela.MovimientosInventario (
    MovimientoID BIGINT IDENTITY(1,1) PRIMARY KEY,
    MateriaPrimaID INT NOT NULL FOREIGN KEY REFERENCES cazuela.MateriasPrimas(MateriaPrimaID),
    TipoMovimiento NVARCHAR(20) NOT NULL CHECK (TipoMovimiento IN ('Entrada', 'Salida', 'Merma', 'Ajuste')),
    Cantidad DECIMAL(10,2) NOT NULL,
    CostoUnitario DECIMAL(10,2),
    FechaMovimiento DATETIME NOT NULL DEFAULT GETDATE(),
    SucursalID INT NOT NULL FOREIGN KEY REFERENCES cazuela.Sucursales(SucursalID),
    Comentarios NVARCHAR(255),
    INDEX IX_MovimientosInventario_Fecha (FechaMovimiento)
);


CREATE TABLE cazuela.Ventas (
    VentaID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    SucursalID INT NOT NULL FOREIGN KEY REFERENCES cazuela.Sucursales(SucursalID),
    FechaVenta DATETIME NOT NULL DEFAULT GETDATE(),
    Total DECIMAL(10,2) NOT NULL CHECK (Total >= 0),
    Estado NVARCHAR(20) NOT NULL CHECK (Estado IN ('Pendiente', 'Completada', 'Cancelada', 'Sincronizada')) DEFAULT 'Pendiente',
    EsOffline BIT NOT NULL DEFAULT 0,
    INDEX IX_Ventas_Fecha (FechaVenta)
);

CREATE TABLE cazuela.VentaDetalles (
    VentaDetalleID BIGINT IDENTITY(1,1) PRIMARY KEY,
    VentaID UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES cazuela.Ventas(VentaID),
    ProductoID INT NOT NULL FOREIGN KEY REFERENCES cazuela.Productos(ProductoID),
    Cantidad DECIMAL(10,2) NOT NULL CHECK (Cantidad > 0),
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    AtributosSeleccionados NVARCHAR(MAX),
    INDEX IX_VentaDetalles_VentaID (VentaID)
);


CREATE TABLE cazuela.MetricasVenta (
    MetricaID INT IDENTITY(1,1) PRIMARY KEY,
    SucursalID INT NOT NULL FOREIGN KEY REFERENCES cazuela.Sucursales(SucursalID),
    Fecha DATE NOT NULL,
    TotalVentas DECIMAL(15,2) NOT NULL,
    TamalesVendidos INT NOT NULL,
    BebidasVendidas INT NOT NULL,
    PorcentajePicante DECIMAL(5,2) NOT NULL,
    DesperdicioMateriasPrimas DECIMAL(15,2) NOT NULL,
    CONSTRAINT UQ_Metricas_SucursalFecha UNIQUE (SucursalID, Fecha)
);


CREATE TABLE cazuela.LLMLogs (
    LogID BIGINT IDENTITY(1,1) PRIMARY KEY,
    FechaHora DATETIME NOT NULL DEFAULT GETDATE(),
    TipoSolicitud NVARCHAR(50) NOT NULL,
    Entrada NVARCHAR(MAX) NOT NULL,
    Salida NVARCHAR(MAX) NOT NULL,
    CostoToken DECIMAL(10,6),
    DuracionMs INT
);

INSERT INTO cazuela.CategoriasProducto (CategoriaID, Nombre)
VALUES 
    (1, 'Tamal'),
    (2, 'Bebida'),
    (3, 'Combo'),
    (4, 'MateriaPrima'),
    (5, 'Empaque');

CREATE INDEX IX_Productos_Categoria ON cazuela.Productos(CategoriaID);
CREATE INDEX IX_Movimientos_MateriaPrima ON cazuela.MovimientosInventario(MateriaPrimaID);
CREATE INDEX IX_Ventas_Sucursal ON cazuela.Ventas(SucursalID);
CREATE INDEX IX_VentaDetalles_Producto ON cazuela.VentaDetalles(ProductoID);

select * from cazuela.Productos;

select * from cazuela.Combos;
select * from cazuela.ComboItems;
delete  from cazuela.Combos where ComboID=3;

delete  from cazuela.ComboItems where ComboItemID=3;


-- Masa
INSERT INTO cazuela.Atributos (Nombre, Tipo) VALUES
('maíz amarillo', 'Masa'),
('maíz blanco', 'Masa'),
('arroz', 'Masa');

-- Relleno
INSERT INTO cazuela.Atributos (Nombre, Tipo) VALUES
('recado rojo de cerdo', 'Relleno'),
('negro de pollo', 'Relleno'),
('chipilín vegetariano', 'Relleno'),
('mezcla estilo chuchito', 'Relleno');

-- Envase
INSERT INTO cazuela.Atributos (Nombre, Tipo) VALUES
('hoja de plátano', 'Envase'),
('tusa de maíz', 'Envase');

-- Picante
INSERT INTO cazuela.Atributos (Nombre, Tipo) VALUES
('sin chile', 'Picante'),
('suave ', 'Picante'),
('chapín).', 'Picante');

-- TipoBebida
INSERT INTO cazuela.Atributos (Nombre, Tipo) VALUES
('natural', 'TipoBebida'),
('gaseosa', 'TipoBebida'),
('atol', 'TipoBebida'),
('cafe', 'TipoBebida');

-- Endulzante
INSERT INTO cazuela.Atributos (Nombre, Tipo) VALUES
('panela', 'Endulzante'),
('miel', 'Endulzante'),
('Azucar', 'Endulzante'),
('sin Azucar', 'Endulzante');

-- Topping
INSERT INTO cazuela.Atributos (Nombre, Tipo) VALUES
('malvaviscos, ', 'Topping'),
('canela ', 'Topping'),
('ralladura de cacao', 'Topping');
