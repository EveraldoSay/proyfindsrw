-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 17-10-2024 a las 00:47:04
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
(2, 'Industrial'),
(3, 'G&T Continental'),
(7, 'BAM');

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
(2, 'Bedidas Energizantes'),
(3, 'Condimentos y especies'),
(6, 'Cereales'),
(10, 'Panes'),
(11, 'Embutidos');

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
(2, 'Edvin De Leon', '11-21, Zona 3, Totonicapan', '77669888', 'edele@gmail.com', 'H', '11111', '28822', 'yy-2188', 'A-211'),
(6, 'Dany Sapon', '1-12, zona 2, Salcaja', '11223344', 'danys8s@gmail.com', 'H', 'CF', '8119920801', '12-112', 'yy-21'),
(7, 'Joaquin Lopez', '72-21, zona 3, Quetzaltenango', '88776111', 'jLop@gmail.com', 'H', '2818172-21', '1982973', '77', '9000');

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
(1, 1, 1, 1),
(2, 1, 1, 1);

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
(1, 1, 1, 2, '2024-10-16 00:00:00', 'producto caducado'),
(2, 2, 1, 1, '2024-10-16 00:00:00', 'producto cad'),
(4, 1, 1, 110, '2024-10-16 00:00:00', 'simple devolucion');

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
(1, '2', 'pan rodaja', 'pan rodajeado bimbo, 120 gramos', 200.00, 0.90, '123', 2110, 10),
(4, '21', 'Mounster', 'Bebida energizante sabor chocolate, 12 gramos', 21.00, 0.90, '1233', 1200, 2);

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
(1, 'joelpoz', '$2y$10$HU3kZOYTdd2muLV3TGq9GewY4AGVuT8NXThyfPngZECEGHPGc1mnS', 'administrador', 'Joel Santiago', 'Vicente Poz', 'joel21@gmail.com', '45785858', '2024-09-04 22:03:28'),
(5, 'Eve', '$2a$10$vZy3hqL7rsYFO8RdOp1b6e0ox9TwJi2Rqp9KEYz7dlPU0CSzwJ2m.', 'Administrador', 'Everaldo', 'Say', 'deleone94@gmail.com', '55871711', '2024-10-08 10:49:33');

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
(1, 6, '2024-10-14 14:47:52', 'efectivo', NULL, 200.00, NULL, NULL, b'0', NULL, 5),
(2, 6, '2024-10-14 14:47:54', 'efectivo', NULL, 200.00, NULL, NULL, b'0', NULL, 5);

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
  MODIFY `IdBanco` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `IdCategoria` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `IdCliente` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `detalleventas`
--
ALTER TABLE `detalleventas`
  MODIFY `IdDetVent` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `IdDev` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `kardex`
--
ALTER TABLE `kardex`
  MODIFY `Id` bigint(20) NOT NULL AUTO_INCREMENT;

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
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `IdUsuario` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `IdVenta` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
