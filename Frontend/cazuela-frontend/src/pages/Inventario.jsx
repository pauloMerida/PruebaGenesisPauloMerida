import React, { useEffect, useState } from 'react';
import api from '../services/api';
export default function Inventario(){
  const [list, setList] = useState([]);
  useEffect(()=>{ api.getMaterias().then(setList); }, []);
  return (
    <>
      <h3>Materias Primas</h3>
      <ul className="list-group">
        {list.map(m=> <li key={m.materiaPrimaID} className="list-group-item d-flex justify-content-between">{m.nombre}<span>{m.stockMinimo} {m.unidadMedida}</span></li>)}
      </ul>
    </>
  );
}
