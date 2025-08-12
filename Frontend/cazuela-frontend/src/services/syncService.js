import api from './api';
import { toast } from 'react-toastify';

const KEY = 'cazuela_offline_ventas';

export function queueVenta(payload) {
  const list = JSON.parse(localStorage.getItem(KEY) || '[]');
  list.push(payload);
  localStorage.setItem(KEY, JSON.stringify(list));
  toast.info('Venta guardada offline (cola)');
}

export async function syncQueuedVentas() {
  const list = JSON.parse(localStorage.getItem(KEY) || '[]');
  if (!list.length) {
    toast.info('No hay ventas en cola');
    return;
  }
  let success = 0, fail = 0;
  for (const item of list) {
    try {
      await api.createVenta(item.venta, item.detalles);
      success++;
    } catch {
      fail++;
    }
  }
  if (success > 0) toast.success(`${success} ventas sincronizadas`);
  if (fail > 0) toast.error(`${fail} ventas fallaron`);
  localStorage.removeItem(KEY);
}
