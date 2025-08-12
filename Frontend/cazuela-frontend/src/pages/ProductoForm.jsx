import React, { useEffect, useState } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import api from '../services/api';
import { Form, Button } from 'react-bootstrap';
import { toast } from 'react-toastify';

export default function ProductoForm() {
  const [params] = useSearchParams();
  const id = params.get('id');
  const navigate = useNavigate();

  const [form, setForm] = useState({
    nombre: '', categoriaID: 1, precioBase: 0, unidadMedida: 'Unidad', esCombo: false, activo: true
  });

  useEffect(() => {
    if (id) {
      api.getProducto(id).then(data => {
        setForm({
          nombre: data.nombre,
          categoriaID: data.categoriaID,
          precioBase: data.precioBase,
          unidadMedida: data.unidadMedida,
          esCombo: data.esCombo,
          activo: data.activo
        });
      });
    }
  }, [id]);

  function onChange(e) {
    const { name, value, type, checked } = e.target;
    setForm(prev => ({ ...prev, [name]: type === 'checkbox' ? checked : (type === 'number' ? Number(value) : value) }));
  }

  async function submit(e){
    e.preventDefault();
    try {
      if (id) {
        await api.updateProducto(id, { productoID: Number(id), ...form });
        toast.success('Producto actualizado');
      } else {
        await api.createProducto(form);
        toast.success('Producto creado');
      }
      navigate('/productos');
    } catch {}
  }

  return (
    <>
      <h3>{id ? 'Editar' : 'Nuevo'} Producto</h3>
      <Form onSubmit={submit}>
        <Form.Group className="mb-2">
          <Form.Label>Nombre</Form.Label>
          <Form.Control name="nombre" value={form.nombre} onChange={onChange} required />
        </Form.Group>
        <Form.Group className="mb-2">
          <Form.Label>CategoriaID</Form.Label>
          <Form.Control name="categoriaID" type="number" value={form.categoriaID} onChange={onChange} required />
          <small className="text-muted">1=Tamal 2=Bebida 3=Combo</small>
        </Form.Group>
        <Form.Group className="mb-2">
          <Form.Label>Precio</Form.Label>
          <Form.Control name="precioBase" type="number" step="0.01" value={form.precioBase} onChange={onChange} />
        </Form.Group>
        <Form.Group className="mb-2">
          <Form.Label>Unidad Medida</Form.Label>
          <Form.Control name="unidadMedida" value={form.unidadMedida} onChange={onChange} />
        </Form.Group>
        <Form.Group className="mb-2 form-check">
          <input className="form-check-input" id="esCombo" name="esCombo" type="checkbox" checked={form.esCombo} onChange={onChange}/>
          <label className="form-check-label" htmlFor="esCombo">Es Combo</label>
        </Form.Group>
        <Button type="submit">Guardar</Button>
      </Form>
    </>
  );
}
