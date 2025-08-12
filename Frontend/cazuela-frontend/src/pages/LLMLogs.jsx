import React, { useEffect, useState } from 'react';
import api from '../services/api';
import { Form, Button } from 'react-bootstrap';

export default function LLMLogs() {
  const [logs, setLogs] = useState([]);
  const [tipo, setTipo] = useState('');
  const [entrada, setEntrada] = useState('');
  const [salida, setSalida] = useState('');
  const [prompt, setPrompt] = useState('');
  const [response, setResponse] = useState('');

  useEffect(() => { api.getLLMLogs().then(setLogs); }, []);

  async function saveLog(e) {
    e.preventDefault();
    await api.postLLMLog({ tipoSolicitud: tipo, entrada, salida });
    setTipo(''); setEntrada(''); setSalida('');
    setLogs(await api.getLLMLogs());
  }

  async function ask(e) {
    e.preventDefault();
    if (!prompt) return;
    const res = await api.askLLM(prompt);
    
    setResponse(res.result || res.raw || 'Sin respuesta');
  
    setLogs(await api.getLLMLogs());
  }

  return (
    <>
      <h3>LLM — Logs e integración</h3>

      <div className="mb-4">
        <h5>Hacer pregunta al modelo (OpenRouter vía backend)</h5>
        <Form onSubmit={ask}>
          <Form.Control as="textarea" rows={3} value={prompt} onChange={e => setPrompt(e.target.value)} placeholder="Escribe tu pregunta" />
          <div className="mt-2">
            <Button type="submit">Preguntar</Button>
          </div>
        </Form>
        {response && <div className="mt-3 p-3 border bg-white"><strong>Respuesta:</strong><div>{response}</div></div>}
      </div>

      <hr/>

      <h5>Registrar log manual</h5>
      <Form onSubmit={saveLog}>
        <Form.Control className="mb-2" placeholder="Tipo" value={tipo} onChange={e => setTipo(e.target.value)} />
        <Form.Control className="mb-2" placeholder="Entrada" value={entrada} onChange={e => setEntrada(e.target.value)} />
        <Form.Control className="mb-2" placeholder="Salida" value={salida} onChange={e => setSalida(e.target.value)} />
        <Button type="submit">Guardar Log</Button>
      </Form>

      <hr/>

      <div style={{maxHeight:300, overflow:'auto'}}>
        {logs.map(l => (
          <div key={l.logID} className="mb-2 border p-2 bg-white">
            <b>{l.tipoSolicitud}</b>
            <div className="text-muted small">{new Date(l.fechaHora).toLocaleString()}</div>
            <div><strong>Entrada:</strong> {l.entrada}</div>
            <div><strong>Salida:</strong> {l.salida}</div>
          </div>
        ))}
      </div>
    </>
  );
}
