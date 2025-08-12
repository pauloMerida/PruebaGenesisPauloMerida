import React, { useEffect, useState } from 'react';
import api from '../services/api';
import ComboEditor from '../components/ComboEditor';

export default function Combos() {
  const [combos, setCombos] = useState([]);
  async function load(){ setCombos(await api.getCombos()); }
  useEffect(() => { load(); }, []);
  return (
    <>
      <h3>Combos</h3>
      {combos.map(c => (
        <div key={c.comboID} className="mb-4">
          <h5>{c.descripcion || `Combo ${c.comboID}`}</h5>
          <ComboEditor comboId={c.comboID} />
        </div>
      ))}
    </>
  );
}
