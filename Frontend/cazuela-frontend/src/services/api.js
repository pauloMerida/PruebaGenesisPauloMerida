import axios from 'axios';
import { toast } from 'react-toastify';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:5266/api';

const api = axios.create({
  baseURL: API_URL,
  timeout: 15000,
});


api.interceptors.response.use(
  r => r,
  e => {
    const msg = e?.response?.data?.title || e?.message || 'Error al conectar';
    toast.error(msg);
    return Promise.reject(e);
  }
);

export default {
  // Productos
  getProductos: () => api.get('/productos').then(r => r.data),
  getProducto: id => api.get(`/productos/${id}`).then(r => r.data),
  createProducto: payload => api.post('/productos', payload).then(r => r.data),
  updateProducto: (id, payload) => api.put(`/productos/${id}`, payload).then(r => r.data),
  deleteProducto: id => api.delete(`/productos/${id}`).then(r => r.data),

  // Atributos y producto-atributos
  getAtributos: () => api.get('/atributos').then(r => r.data),
  createAtributo: payload => api.post('/atributos', payload).then(r => r.data),
  updateAtributo: (id, payload) => api.put(`/atributos/${id}`, payload).then(r => r.data),
  deleteAtributo: id => api.delete(`/atributos/${id}`).then(r => r.data),

  getProductoAtributos: productoId => api.get(`/productoatributos/producto/${productoId}`).then(r => r.data),
  createProductoAtributo: payload => api.post('/productoatributos', payload).then(r => r.data),
  updateProductoAtributo: (id, payload) => api.put(`/productoatributos/${id}`, payload).then(r => r.data),
  deleteProductoAtributo: id => api.delete(`/productoatributos/${id}`).then(r => r.data),

  // Sucursales
  getSucursales: () => api.get('/sucursales').then(r => r.data),
  createSucursal: payload => api.post('/sucursales', payload).then(r => r.data),

  // Materias primas e inventario
  getMaterias: () => api.get('/materias').then(r => r.data),
  createMateria: payload => api.post('/materias', payload).then(r => r.data),

  getMovimientos: () => api.get('/inventario/movimientos').then(r => r.data),
  postMovimiento: payload => api.post('/inventario/movimientos', payload).then(r => r.data),
  getStock: id => api.get(`/inventario/stock/${id}`).then(r => r.data),

  // Combos
  getCombos: () => api.get('/combos').then(r => r.data),
  createCombo: payload => api.post('/combos', payload).then(r => r.data),
  addComboItem: (comboId, payload) => api.post(`/combos/${comboId}/items`, payload).then(r => r.data),
  getComboItems: comboId => api.get(`/combos/${comboId}/items`).then(r => r.data),

  // Ventas (nota: backend espera { venta, detalles } body)
  getVentas: () => api.get('/ventas').then(r => r.data),
  createVenta: (venta, detalles) => api.post('/ventas', { venta, detalles }).then(r => r.data),
  updateVentaEstado: (id, estado) => api.put(`/ventas/${id}/estado?estado=${estado}`).then(r => r.data),

  // Dashboard
  getMetricas: (from, to, sucursalId) => api.get('/dashboard/ventas/diarias', { params: { from, to, sucursalId } }).then(r => r.data),
  getTamalesMasVendidos: () => api.get('/dashboard/tamales/masvendidos').then(r => r.data),
  getProporcionPicante: () => api.get('/dashboard/proporcion/picante').then(r => r.data),

  // LLM logs
  postLLMLog: payload => api.post('/llm/log', payload).then(r => r.data),
  getLLMLogs: () => api.get('/llm/logs').then(r => r.data),
  askLLM: prompt => api.post('/llm/ask', { prompt }).then(r => r.data),

  // atributos (si tu backend tiene endpoint /atributos)
  getAtributos: () => api.get('/atributos').then(r => r.data),
};
