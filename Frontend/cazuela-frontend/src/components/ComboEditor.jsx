import React, { useEffect, useState } from 'react';
import api from '../services/api';
import { Button, Table } from 'react-bootstrap';

export default function ComboEditor({ comboId }) {
  const [items, setItems] = useState([]);
  const [productoId, setProductoId] = useState('');
  const [cantidad, setCantidad] = useState(1);
  const [productos, setProductos] = useState([]);

  async function load(){
    setItems(await api.getComboItems(comboId));
    setProductos(await api.getProductos());
  }

  useEffect(()=>{ load(); }, [comboId]);

  async function add(){
    if(!productoId) return;
    await api.addComboItem(comboId, { productoID: Number(productoId), cantidad });
    await load();
  }

  return (
    <>
      <div className="d-flex gap-2 mb-2">
        <select className="form-select" value={productoId} onChange={e => setProductoId(e.target.value)}>
          <option value="">Selecciona producto</option>
          {productos.map(p => <option key={p.productoID} value={p.productoID}>{p.nombre}</option>)}
        </select>
        <input className="form-control" type="number" min="1" value={cantidad} onChange={e => setCantidad(Number(e.target.value))}/>
        <Button onClick={add}>Agregar</Button>
      </div>
      <Table striped>
        <thead><tr><th>Producto</th><th>Cantidad</th></tr></thead>
        <tbody>
        {items.map(it => (
          <tr key={it.comboItemID}>
            <td>{it.productoNombre}</td>
            <td>{it.cantidad}</td>
          </tr>
        ))}
        </tbody>
      </Table>
    </>
  );
}
