import React from 'react';
import { Link } from 'react-router-dom';

export default function Home(){
  return (
    <div className="p-4 bg-white rounded shadow-sm">
      <h2>Bienvenido a La Cazuela Chapina</h2>
      <p>Panel de administración — usa el menú para navegar entre Productos, Combos, Inventario, Ventas, Dashboard y LLM.</p>

      <div className="mt-3">
        <Link className="btn btn-primary me-2" to="/productos">Productos</Link>
        <Link className="btn btn-secondary me-2" to="/combos">Combos</Link>
        <Link className="btn btn-info me-2" to="/inventario">Inventario</Link>
        <Link className="btn btn-success me-2" to="/ventas/nuevo">Registrar Venta</Link>
        <Link className="btn btn-warning" to="/dashboard">Dashboard</Link>
      </div>
    </div>
  );
}
