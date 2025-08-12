import React, { useEffect, useState } from 'react';
import api from '../services/api';
import { Form, Button } from 'react-bootstrap';

export default function Movimientos(){
  const [materias, setMaterias] = useState([]);
  const [form, setForm] = useState({ materiaPrimaID:'', tipoMovimiento:'Entrada', cantidad:0, costoUnitario:0, sucursalID:1, comentarios:''});
  useEffect(()=>{ api.getMaterias().then(setMaterias); }, []);
  function onChange(e){ const {name, value} = e.target; setForm(prev => ({...prev, [name]: value})); }
  async function submit(e){
    e.preventDefault();
    await api.postMovimiento({
      materiaPrimaID: Number(form.materiaPrimaID),
      tipoMovimiento: form.tipoMovimiento,
      cantidad: Number(form.cantidad),
      costoUnitario: Number(form.costoUnitario),
      sucursalID: Number(form.sucursalID),
      comentarios: form.comentarios
    });
    window.location.reload();
  }
  return (
    <>
      <h3>Registrar Movimiento</h3>
      <Form onSubmit={submit}>
        <Form.Select name="materiaPrimaID" value={form.materiaPrimaID} onChange={onChange} required>
          <option value="">Selecciona materia</option>
          {materias.map(m=> <option key={m.materiaPrimaID} value={m.materiaPrimaID}>{m.nombre}</option>)}
        </Form.Select>
        <Form.Control className="my-2" name="cantidad" type="number" value={form.cantidad} onChange={onChange} placeholder="Cantidad"/>
        <Form.Control className="my-2" name="costoUnitario" type="number" value={form.costoUnitario} onChange={onChange} placeholder="Costo unitario"/>
        <Form.Control className="my-2" name="comentarios" value={form.comentarios} onChange={onChange} placeholder="Comentarios"/>
        <Button type="submit">Registrar</Button>
      </Form>
    </>
  );
}
