import React from 'react';
import { Routes, Route } from 'react-router-dom';
import AppNavbar from './components/Navbar';
import Home from './pages/Home';
import Productos from './pages/Productos';
import ProductoForm from './pages/ProductoForm';
import Combos from './pages/Combos';
import Inventario from './pages/Inventario';
import Movimientos from './pages/Movimientos';
import VentaForm from './pages/VentaForm';
import Dashboard from './pages/Dashboard';
import Sucursales from './pages/Sucursales';
import LLMLogs from './pages/LLMLogs';

export default function App() {
  return (
    <>
      <AppNavbar />
      <div className="container my-4">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/productos" element={<Productos />} />
          <Route path="/productos/nuevo" element={<ProductoForm />} />
          <Route path="/combos" element={<Combos />} />
          <Route path="/inventario" element={<Inventario />} />
          <Route path="/inventario/movimientos" element={<Movimientos />} />
          <Route path="/ventas/nuevo" element={<VentaForm />} />
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/sucursales" element={<Sucursales />} />
          <Route path="/llm" element={<LLMLogs />} />
        </Routes>
      </div>
    </>
  );
}
