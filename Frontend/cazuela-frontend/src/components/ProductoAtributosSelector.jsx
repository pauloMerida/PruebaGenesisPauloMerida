import React, { useEffect, useState } from 'react';
import api from '../services/api';

export default function ProductoAtributosSelector({ productoID, onChange }) {
  const [atributos, setAtributos] = useState([]);
  const [seleccion, setSeleccion] = useState({});

  useEffect(() => {
    if (!productoID) return;
    api.getProductoAtributos(productoID).then(data => {
      setAtributos(data);
     
      setSeleccion({});
    });
  }, [productoID]);

  function handleSelect(atributoID, valor) {
    const nuevaSeleccion = { ...seleccion, [atributoID]: valor };
    setSeleccion(nuevaSeleccion);
    onChange(nuevaSeleccion);
  }

  if (!atributos.length) return null;

  return (
    <div>
      {atributos.map(attr => (
        <div key={attr.atributoID} className="mb-2">
          <label className="form-label">{attr.nombre}</label>
          <select
            className="form-select"
            value={seleccion[attr.atributoID] || ''}
            onChange={e => handleSelect(attr.atributoID, e.target.value)}
          >
            <option value="">Seleccione...</option>
            {attr.opciones.map(opt => (
              <option key={opt} value={opt}>{opt}</option>
            ))}
          </select>
        </div>
      ))}
    </div>
  );
}
