import React, { useEffect, useState } from 'react';
import api from '../services/api';
import { Link } from 'react-router-dom';
import { Button, Row, Col, Card } from 'react-bootstrap';
import { toast } from 'react-toastify';

export default function Productos() {
  const [productos, setProductos] = useState([]);

  async function load() {
    try {
      const data = await api.getProductos();
      setProductos(data);
    } catch (e) { /* handler interceptor already toasts */ }
  }

  useEffect(() => { load(); }, []);

  async function remove(id) {
    if (!confirm('Eliminar producto?')) return;
    try {
      await api.deleteProducto(id);
      toast.success('Producto eliminado');
      load();
    } catch {}
  }

  return (
    <>
      <div className="d-flex justify-content-between align-items-center mb-3">
        <h3>Productos</h3>
        <Link to="/productos/nuevo" className="btn btn-primary">Nuevo producto</Link>
      </div>
      <Row>
        {productos.map(p => (
          <Col md={4} key={p.productoID} className="mb-3">
            <Card>
              <Card.Body>
                <Card.Title>{p.nombre}</Card.Title>
                <Card.Text>Precio: Q{p.precioBase}</Card.Text>
                <div className="d-flex justify-content-between">
                  <Link className="btn btn-sm btn-outline-primary" to={`/productos/nuevo?id=${p.productoID}`}>Editar</Link>
                  <Button variant="danger" size="sm" onClick={() => remove(p.productoID)}>Eliminar</Button>
                </div>
              </Card.Body>
            </Card>
          </Col>
        ))}
      </Row>
    </>
  );
}
