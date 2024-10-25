-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-10-2024 a las 09:49:34
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `puntoventa`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bancos`
--

CREATE TABLE `bancos` (
  `IdBanco` bigint(20) NOT NULL,
  `Nombre` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `bancos`
--

INSERT INTO `bancos` (`IdBanco`, `Nombre`) VALUES
(1, 'Banrural'),
(2, 'G&T Continental'),
(3, 'BAM'),
(4, 'Industrial');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `IdCategoria` bigint(20) NOT NULL,
  `Nombre` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`IdCategoria`, `Nombre`) VALUES
(1, 'Bebidas Energizantes'),
(2, 'Refrescos'),
(3, 'Especias/condimentos'),
(4, 'Galletas'),
(5, 'Dulces'),
(6, 'Golosinas'),
(7, 'Cereales'),
(8, 'Consumo diario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `IdCliente` bigint(20) NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `Direccion` varchar(255) DEFAULT NULL,
  `Telefono` varchar(50) DEFAULT NULL,
  `Email` varchar(255) NOT NULL,
  `Sexo` varchar(10) DEFAULT NULL,
  `NIT` varchar(50) DEFAULT NULL,
  `CUI` varchar(50) DEFAULT NULL,
  `SeguroMedico` varchar(255) DEFAULT NULL,
  `NumeroPoliza` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`IdCliente`, `Nombre`, `Direccion`, `Telefono`, `Email`, `Sexo`, `NIT`, `CUI`, `SeguroMedico`, `NumeroPoliza`) VALUES
(1, 'Ana Elizabeth Garcia', '11-02, Zona 2, Quetzaltenango', '99887121', 'AnaEli@gmail.com', 'M', '7177621-21', '19872890801', 'yy-21', '12'),
(2, 'Juan Carlos Morales Norato', '123-1, Zona 4, Totonicapan', '91260101', 'JuancaMora@gmail.com', 'H', '8177817-2', '9018927', 'yy-21', '11'),
(3, 'Ana Guadalupe Fuentes  ', '19-21, Zona 3, Salcaja, Quetzaltenango', '98182811', 'Lupe89@gmail.com', 'M', '918927-2', '91829010801', 'yy-12', '21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleventas`
--

CREATE TABLE `detalleventas` (
  `IdDetVent` bigint(20) NOT NULL,
  `IdVenta` bigint(20) NOT NULL,
  `IdProd` bigint(20) NOT NULL,
  `Cantidad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `detalleventas`
--

INSERT INTO `detalleventas` (`IdDetVent`, `IdVenta`, `IdProd`, `Cantidad`) VALUES
(1, 1, 1, 2),
(2, 2, 2, 4),
(3, 3, 1, 10),
(4, 4, 1, 5),
(5, 5, 1, 1000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones`
--

CREATE TABLE `devoluciones` (
  `IdDev` bigint(20) NOT NULL,
  `IdVenta` bigint(20) NOT NULL,
  `IdProd` bigint(11) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `Fecha` datetime DEFAULT current_timestamp(),
  `Motivo` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `devoluciones`
--

INSERT INTO `devoluciones` (`IdDev`, `IdVenta`, `IdProd`, `Cantidad`, `Fecha`, `Motivo`) VALUES
(1, 2, 2, 1, '2024-10-25 00:00:00', 'Dañado'),
(2, 3, 1, 5, '2024-10-25 00:00:00', 'Envases dañados');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `kardex`
--

CREATE TABLE `kardex` (
  `Id` bigint(20) NOT NULL,
  `IdProd` bigint(20) NOT NULL,
  `CantidadInicial` int(11) NOT NULL,
  `CantidadVendida` int(11) DEFAULT 0,
  `CantidadRecibida` int(11) DEFAULT 0,
  `CantidadExistente` int(11) NOT NULL,
  `IdUsuario` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `kardex`
--

INSERT INTO `kardex` (`Id`, `IdProd`, `CantidadInicial`, `CantidadVendida`, `CantidadRecibida`, `CantidadExistente`, `IdUsuario`) VALUES
(1, 1, 20000, 10, 5, 19995, 1),
(2, 1, 19995, 10, 15, 20000, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `IdPago` bigint(20) NOT NULL,
  `IdVenta` bigint(20) NOT NULL,
  `Fecha` datetime DEFAULT current_timestamp(),
  `FormaPago` varchar(50) NOT NULL,
  `Monto` decimal(10,2) NOT NULL,
  `SaldoPendiente` decimal(10,2) NOT NULL,
  `IdBanco` bigint(20) DEFAULT NULL,
  `NumeroReferencia` varchar(255) DEFAULT NULL,
  `IdUsuario` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `IdProd` bigint(20) NOT NULL,
  `CodigoProducto` varchar(50) NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `Descripcion` text DEFAULT NULL,
  `Precio` decimal(10,2) NOT NULL,
  `Impuestos` decimal(5,2) NOT NULL,
  `NumeroSerie` varchar(255) DEFAULT NULL,
  `Stock` int(11) NOT NULL,
  `IdCategoria` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`IdProd`, `CodigoProducto`, `Nombre`, `Descripcion`, `Precio`, `Impuestos`, `NumeroSerie`, `Stock`, `IdCategoria`) VALUES
(1, '1', 'Raptor ligth', 'Bebida botella 12 onz', 12.00, 0.90, '123', 19000, 1),
(2, '2', 'Coca cola', 'Jumbo 3 litros', 21.00, 0.90, '1234', 4801, 2),
(3, '3', 'Cereal pepino bebe', 'Cereal para niños, caja 20gramos', 21.00, 0.10, '12345', 19000, 7),
(4, '4', 'Fredo', 'Caja galletas, 12 unidades, 12gramos c/u', 30.00, 0.90, '123456', 3000, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tempdetalle`
--

CREATE TABLE `tempdetalle` (
  `iddetalle` int(11) NOT NULL,
  `idProd` int(11) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `Precio` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `IdUsuario` bigint(20) NOT NULL,
  `NombreUsuario` varchar(255) NOT NULL,
  `Contrasena` varchar(255) NOT NULL,
  `Rol` varchar(50) NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `Apellido` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Telefono` varchar(50) DEFAULT NULL,
  `FechaRegistro` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`IdUsuario`, `NombreUsuario`, `Contrasena`, `Rol`, `Nombre`, `Apellido`, `Email`, `Telefono`, `FechaRegistro`) VALUES
(1, 'wilmerB', '$2y$10$HU3kZOYTdd2muLV3TGq9GewY4AGVuT8NXThyfPngZECEGHPGc1mnS', 'administrador', 'Wilmer Admidael', 'Batz Chaclan', 'wil33@gmail.com', '88776152', '2024-09-04 22:03:28'),
(5, 'Ever', '$2a$10$vZy3hqL7rsYFO8RdOp1b6e0ox9TwJi2Rqp9KEYz7dlPU0CSzwJ2m.', 'Administrador', 'Edvin Everaldo', 'De Leon Say', 'deleone924@gmail.com', '99881212', '2024-10-08 10:49:33');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `IdVenta` bigint(20) NOT NULL,
  `IdCliente` bigint(20) NOT NULL,
  `Fecha` datetime DEFAULT current_timestamp(),
  `FormaPago` varchar(50) DEFAULT NULL,
  `NumeroFactura` varchar(255) DEFAULT NULL,
  `Total` decimal(10,2) DEFAULT NULL,
  `Anticipo` decimal(10,2) DEFAULT NULL,
  `Descuento` decimal(5,2) DEFAULT NULL,
  `CuentaCorriente` bit(1) DEFAULT b'0',
  `NumeroSerie` varchar(255) DEFAULT NULL,
  `IdUsuario` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`IdVenta`, `IdCliente`, `Fecha`, `FormaPago`, `NumeroFactura`, `Total`, `Anticipo`, `Descuento`, `CuentaCorriente`, `NumeroSerie`, `IdUsuario`) VALUES
(1, 1, '2024-10-25 01:31:44', 'Efectivo', '20241025-001', 23.78, 0.00, 0.22, b'0', NULL, 1),
(2, 2, '2024-10-25 01:32:53', 'Tarjeta', '20241025-002', 83.91, 0.00, 0.09, b'0', NULL, 1),
(3, 3, '2024-10-25 01:35:17', 'Tarjeta', '20241025-003', 119.75, 0.00, 0.25, b'0', NULL, 1),
(4, 1, '2024-10-25 01:44:26', 'Efectivo', '20241025-004', 59.93, 0.00, 0.07, b'0', NULL, 1),
(5, 3, '2024-10-25 01:48:18', 'Efectivo', '20241025-005', 11988.00, 0.00, 12.00, b'0', NULL, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bancos`
--
ALTER TABLE `bancos`
  ADD PRIMARY KEY (`IdBanco`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`IdCategoria`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`IdCliente`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indices de la tabla `detalleventas`
--
ALTER TABLE `detalleventas`
  ADD PRIMARY KEY (`IdDetVent`),
  ADD KEY `FK_DetalleVentas_Ventas` (`IdVenta`),
  ADD KEY `FK_DetalleVentas_Productos` (`IdProd`);

--
-- Indices de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD PRIMARY KEY (`IdDev`),
  ADD KEY `FK_Devoluciones_Ventas` (`IdVenta`),
  ADD KEY `FK_DetalleDevoluciones_Productos` (`IdProd`);

--
-- Indices de la tabla `kardex`
--
ALTER TABLE `kardex`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_Kardex_Productos` (`IdProd`),
  ADD KEY `FK_Kardex_Usuarios` (`IdUsuario`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`IdPago`),
  ADD KEY `FK_Pagos_Ventas` (`IdVenta`),
  ADD KEY `FK_Pagos_Bancos` (`IdBanco`),
  ADD KEY `FK_Pagos_Usuarios` (`IdUsuario`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`IdProd`),
  ADD UNIQUE KEY `CodigoProducto` (`CodigoProducto`),
  ADD KEY `FK_Productos_Categorias` (`IdCategoria`);

--
-- Indices de la tabla `tempdetalle`
--
ALTER TABLE `tempdetalle`
  ADD PRIMARY KEY (`iddetalle`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`IdUsuario`),
  ADD UNIQUE KEY `NombreUsuario` (`NombreUsuario`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`IdVenta`),
  ADD KEY `FK_Ventas_Clientes` (`IdCliente`),
  ADD KEY `FK_Ventas_Usuarios` (`IdUsuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `bancos`
--
ALTER TABLE `bancos`
  MODIFY `IdBanco` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `IdCategoria` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `IdCliente` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `detalleventas`
--
ALTER TABLE `detalleventas`
  MODIFY `IdDetVent` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `IdDev` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `kardex`
--
ALTER TABLE `kardex`
  MODIFY `Id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `IdPago` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `IdProd` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tempdetalle`
--
ALTER TABLE `tempdetalle`
  MODIFY `iddetalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `IdUsuario` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `IdVenta` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalleventas`
--
ALTER TABLE `detalleventas`
  ADD CONSTRAINT `FK_DetalleVentas_Productos` FOREIGN KEY (`IdProd`) REFERENCES `productos` (`IdProd`),
  ADD CONSTRAINT `FK_DetalleVentas_Ventas` FOREIGN KEY (`IdVenta`) REFERENCES `ventas` (`IdVenta`);

--
-- Filtros para la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD CONSTRAINT `FK_DetalleDevoluciones_Productos` FOREIGN KEY (`IdProd`) REFERENCES `productos` (`IdProd`),
  ADD CONSTRAINT `FK_Devoluciones_Ventas` FOREIGN KEY (`IdVenta`) REFERENCES `ventas` (`IdVenta`);

--
-- Filtros para la tabla `kardex`
--
ALTER TABLE `kardex`
  ADD CONSTRAINT `FK_Kardex_Productos` FOREIGN KEY (`IdProd`) REFERENCES `productos` (`IdProd`),
  ADD CONSTRAINT `FK_Kardex_Usuarios` FOREIGN KEY (`IdUsuario`) REFERENCES `usuarios` (`IdUsuario`);

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `FK_Pagos_Bancos` FOREIGN KEY (`IdBanco`) REFERENCES `bancos` (`IdBanco`),
  ADD CONSTRAINT `FK_Pagos_Usuarios` FOREIGN KEY (`IdUsuario`) REFERENCES `usuarios` (`IdUsuario`),
  ADD CONSTRAINT `FK_Pagos_Ventas` FOREIGN KEY (`IdVenta`) REFERENCES `ventas` (`IdVenta`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `FK_Productos_Categorias` FOREIGN KEY (`IdCategoria`) REFERENCES `categorias` (`IdCategoria`);

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `FK_Ventas_Clientes` FOREIGN KEY (`IdCliente`) REFERENCES `clientes` (`IdCliente`),
  ADD CONSTRAINT `FK_Ventas_Usuarios` FOREIGN KEY (`IdUsuario`) REFERENCES `usuarios` (`IdUsuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
