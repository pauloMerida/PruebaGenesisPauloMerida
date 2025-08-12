import React, { useEffect, useState } from 'react';
import api from '../services/api';
import { queueVenta, syncQueuedVentas } from '../services/syncService';
import { Button, Table, Form } from 'react-bootstrap';
import ProductoAtributosSelector from '../components/ProductoAtributosSelector';


export default function VentaForm(){
  const [productos, setProductos] = useState([]);
  const [sucursales, setSucursales] = useState([]);
  const [cart, setCart] = useState([]);
  const [selectedSucursal, setSelectedSucursal] = useState('');

  useEffect(()=>{
    api.getProductos().then(setProductos);
    api.getSucursales().then(setSucursales);
  }, []);

  function addToCart(p){
    const exists = cart.find(c => c.productoID === p.productoID);
    if(exists) setCart(cart.map(c => c.productoID===p.productoID ? {...c, cantidad: c.cantidad+1} : c));
    else setCart([...cart, {...p, cantidad:1, atributosSeleccionados: {}}]);
  }
  function removeFromCart(id){ setCart(cart.filter(c => c.productoID !== id)); }

  const total = cart.reduce((s, c) => s + (c.precioBase * c.cantidad), 0);

  async function submit(){
    if(!selectedSucursal) return alert('Selecciona sucursal');
    const venta = { sucursalID: Number(selectedSucursal), total, estado: 'Pendiente', esOffline: !navigator.onLine };
    const detalles = cart.map(c => ({
      productoID: c.productoID,
      cantidad: c.cantidad,
      precioUnitario: c.precioBase,
      atributosSeleccionados: JSON.stringify(c.atributosSeleccionados)
    }));

    const payload = { venta, detalles };
    if (!navigator.onLine) {
      queueVenta(payload);
      setCart([]);
      return;
    }

    try {
      await api.createVenta(venta, detalles);
      alert('Venta registrada');
      setCart([]);
    } catch (e) {
      
      queueVenta(payload);
    }
  }

  return (
    <>
      <h3>Registrar Venta</h3>
      <div className="mb-3">
        <Form.Select value={selectedSucursal} onChange={e => setSelectedSucursal(e.target.value)}>
          <option value="">Selecciona sucursal</option>
          {sucursales.map(s => <option key={s.sucursalID} value={s.sucursalID}>{s.nombre}</option>)}
        </Form.Select>
      </div>

      <div className="row">
        <div className="col-md-7">
          <h5>Productos</h5>
          <div className="d-flex flex-wrap gap-2">
            {productos.map(p => (
              <div key={p.productoID} className="card p-2" style={{width:200}}>
                <h6>{p.nombre}</h6>
                <p>Q{p.precioBase}</p>
                <button className="btn btn-sm btn-primary" onClick={()=>addToCart(p)}>Agregar</button>
              </div>
            ))}
          </div>
        </div>

        <div className="col-md-5">
          <h5>Carrito</h5>
          <Table size="sm">
            <thead><tr><th>Producto</th><th>Cant</th><th>Precio</th><th></th></tr></thead>
            <tbody>
            {cart.map(c => (
              <tr key={c.productoID}>
                <td>
                  {c.nombre}
                  <ProductoAtributosSelector
                    productoID={c.productoID}
                    onChange={atribSel => {
                      setCart(prev => prev.map(p =>
                        p.productoID === c.productoID
                          ? { ...p, atributosSeleccionados: atribSel }
                          : p
                      ));
                    }}
                  />
                </td>
                <td>{c.cantidad}</td>
                <td>Q{(c.precioBase * c.cantidad).toFixed(2)}</td>
                <td>
                  <button
                    className="btn btn-sm btn-danger"
                    onClick={() => removeFromCart(c.productoID)}
                  >Q</button>
                </td>
              </tr>
            ))}
              <tr><td colSpan="4" className="text-end">Total: Q{total.toFixed(2)}</td></tr>
            </tbody>
          </Table>
          <div className="d-flex gap-2">
            <Button onClick={submit} variant="success">Registrar Venta</Button>
            <Button onClick={() => syncQueuedVentas()} variant="outline-primary">Sincronizar Cola</Button>
          </div>
        </div>
      </div>
    </>
  );
}
