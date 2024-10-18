const db = require('../database/db');
const conexion = require('../database/db');
const fs = require('fs');
const PDFDocument = require('pdfkit');
const path = require('path');

exports.mostrarFormularioVenta = async (req, res) => {
    try {
        const clientes = await queryAsync('SELECT * FROM clientes');
        const productos = await queryAsync('SELECT * FROM productos');
        const usuarios = await queryAsync('SELECT * FROM usuarios');
        res.render('createVenta', { clientes, productos, usuarios });
    } catch (error) {
        console.error('Error en la consulta de clientes, productos o usuarios:', error);
        res.status(500).send('Error en el servidor');
    }
};

exports.guardarVenta = async (req, res) => {
    const { 
        IdCliente, 
        productos, 
        cantidad, 
        numeroSerie, 
        FormaPago, 
        Anticipo, 
        Descuento, 
        CuentaCorriente, 
        IdUsuario 
    } = req.body;

    if (!Array.isArray(productos) || productos.length === 0) {
        return res.status(400).send('La lista de productos no es válida. Por favor, agregue al menos un producto.');
    }

    try {
        await queryAsync('START TRANSACTION');

        const resultVenta = await queryAsync(
            'INSERT INTO ventas (IdCliente, FormaPago, Anticipo, Descuento, CuentaCorriente, IdUsuario) VALUES (?, ?, ?, ?, ?, ?)',
            [IdCliente, FormaPago, Anticipo, Descuento, CuentaCorriente ? 1 : 0, IdUsuario]
        );

        const ventaId = resultVenta.insertId;
        let totalVenta = 0;

        const productosInfo = await queryAsync('SELECT IdProd, Precio, Nombre FROM productos WHERE IdProd IN (?)', [productos]);
        const productosMap = new Map(productosInfo.map(p => [p.IdProd.toString(), p]));

        for (let i = 0; i < productos.length; i++) {
            const productoId = productos[i];
            const cantidadProducto = parseInt(cantidad[i]);
            const serie = numeroSerie[i];
            const productoInfo = productosMap.get(productoId);
            
            if (!productoInfo) {
                throw new Error(`Producto con ID ${productoId} no encontrado`);
            }

            const precioProducto = productoInfo.Precio;
            const totalProducto = precioProducto * cantidadProducto;
            totalVenta += totalProducto;

            await queryAsync(
                'INSERT INTO detalleventas (IdVenta, IdProd, Cantidad, NumeroSerie) VALUES (?, ?, ?, ?)',
                [ventaId, productoId, cantidadProducto, serie]
            );
        }

        const descuentoAplicado = (totalVenta * Descuento) / 100;
        const totalConDescuento = totalVenta - descuentoAplicado;
        const totalFinal = totalConDescuento - Anticipo;

        await queryAsync('UPDATE ventas SET Total = ? WHERE IdVenta = ?', [totalFinal, ventaId]);

        await queryAsync('COMMIT');

        const pdfDoc = new PDFDocument();
        const pdfPath = path.join(__dirname, '../public/facturas', `venta_${ventaId}.pdf`);
        pdfDoc.pipe(fs.createWriteStream(pdfPath));

        pdfDoc.fontSize(18).text(`Factura de Venta ${ventaId}`, { align: 'center' });
        pdfDoc.moveDown();
        pdfDoc.fontSize(12).text(`Cliente: ${IdCliente}`);
        pdfDoc.text(`Usuario: ${IdUsuario}`);
        pdfDoc.text(`Fecha: ${new Date().toLocaleDateString()}`);
        pdfDoc.text(`Forma de Pago: ${FormaPago}`);
        pdfDoc.moveDown();
        pdfDoc.text('Productos:');

        for (let i = 0; i < productos.length; i++) {
            const productoId = productos[i];
            const cantidadProducto = parseInt(cantidad[i]);
            const serie = numeroSerie[i];
            const productoInfo = productosMap.get(productoId);
            const precioProducto = productoInfo.Precio;
            const totalProducto = precioProducto * cantidadProducto;

            pdfDoc.text(`${productoInfo.Nombre} - Cantidad: ${cantidadProducto}, Precio: $${precioProducto.toFixed(2)}, Total: $${totalProducto.toFixed(2)}, Número de Serie: ${serie}`);
        }

        pdfDoc.moveDown();
        pdfDoc.text(`Subtotal: $${totalVenta.toFixed(2)}`);
        pdfDoc.text(`Descuento (${Descuento}%): $${descuentoAplicado.toFixed(2)}`);
        pdfDoc.text(`Anticipo: $${Anticipo}`);
        pdfDoc.fontSize(14).text(`Total Final: $${totalFinal.toFixed(2)}`);
        pdfDoc.end();

        res.download(pdfPath, `venta_${ventaId}.pdf`);
    } catch (error) {
        console.error('Error al guardar la venta:', error);
        await queryAsync('ROLLBACK');
        res.status(500).send('Error al guardar la venta: ' + error.message);
    }
};

exports.mostrarVentas = async (req, res) => {
    try {
        const query = `
            SELECT v.IdVenta, v.Fecha, c.Nombre AS ClienteNombre, v.Total
            FROM ventas v
            JOIN clientes c ON v.IdCliente = c.IdCliente
            ORDER BY v.Fecha DESC
        `;
        const ventas = await queryAsync(query);
        res.render('verVentas', { ventas });
    } catch (error) {
        console.error('Error al mostrar las ventas:', error);
        res.status(500).send('Error en la base de datos');
    }
};

exports.regenerarFactura = async (req, res) => {
    const { IdVenta } = req.params;

    try {
        const venta = await queryAsync('SELECT * FROM ventas WHERE IdVenta = ?', [IdVenta]);
        if (venta.length === 0) {
            return res.status(404).send('Venta no encontrada');
        }

        const detalles = await queryAsync('SELECT * FROM detalleventas WHERE IdVenta = ?', [IdVenta]);
        const pdfDoc = new PDFDocument();
        const pdfPath = path.join(__dirname, '../public/facturas', `venta_${IdVenta}.pdf`);
        pdfDoc.pipe(fs.createWriteStream(pdfPath));

        pdfDoc.fontSize(18).text(`Factura de Venta ${IdVenta}`, { align: 'center' });
        pdfDoc.moveDown();
        pdfDoc.fontSize(12).text(`Cliente: ${venta[0].IdCliente}`);
        pdfDoc.text(`Usuario: ${venta[0].IdUsuario}`);
        pdfDoc.text(`Fecha: ${new Date(venta[0].Fecha).toLocaleDateString()}`);
        pdfDoc.text(`Forma de Pago: ${venta[0].FormaPago}`);
        pdfDoc.moveDown();
        pdfDoc.text('Productos:');

        let subtotal = 0;
        for (const detalle of detalles) {
            const producto = await queryAsync('SELECT Nombre, Precio FROM productos WHERE IdProd = ?', [detalle.IdProd]);
            const nombreProducto = producto[0].Nombre;
            const precioProducto = producto[0].Precio;
            const totalProducto = precioProducto * detalle.Cantidad;
            subtotal += totalProducto;

            pdfDoc.text(`${nombreProducto} - Cantidad: ${detalle.Cantidad}, Precio: $${precioProducto.toFixed(2)}, Total: $${totalProducto.toFixed(2)}, Número de Serie: ${detalle.NumeroSerie}`);
        }

        pdfDoc.moveDown();
        pdfDoc.text(`Subtotal: $${subtotal.toFixed(2)}`);
        pdfDoc.text(`Descuento (${venta[0].Descuento}%): $${((subtotal * venta[0].Descuento) / 100).toFixed(2)}`);
        pdfDoc.text(`Anticipo: $${venta[0].Anticipo}`);
        pdfDoc.fontSize(14).text(`Total Final: $${venta[0].Total.toFixed(2)}`);
        pdfDoc.end();

        res.download(pdfPath, `venta_${IdVenta}.pdf`);
    } catch (error) {
        console.error('Error al regenerar la factura:', error);
        res.status(500).send('Error al regenerar la factura');
    }
};

function queryAsync(sql, params) {
    return new Promise((resolve, reject) => {
        conexion.query(sql, params, (error, results) => {
            if (error) reject(error);
            else resolve(results);
        });
    });
}

module.exports = {
    mostrarFormularioVenta: exports.mostrarFormularioVenta,
    guardarVenta: exports.guardarVenta,
    mostrarVentas: exports.mostrarVentas,
    regenerarFactura: exports.regenerarFactura
};