import React, { useEffect, useState } from 'react';
import api from '../services/api';
import { Form, Button } from 'react-bootstrap';

export default function Sucursales(){
  const [list, setList] = useState([]);
  const [name, setName] = useState('');
  useEffect(()=>{ api.getSucursales().then(setList); }, []);
  async function add(){ await api.createSucursal({ nombre: name, direccion:'', telefono:'', activo:true }); setName(''); setList(await api.getSucursales()); }
  return (
    <>
      <h3>Sucursales</h3>
      <ul className="list-group mb-3">{list.map(s => <li className="list-group-item" key={s.sucursalID}>{s.nombre}</li>)}</ul>
      <Form inline onSubmit={e=>{ e.preventDefault(); add(); }}>
        <Form.Control value={name} onChange={e=>setName(e.target.value)} placeholder="Nombre sucursal" />
        <Button className="ms-2" type="submit">Crear</Button>
      </Form>
    </>
  );
}
