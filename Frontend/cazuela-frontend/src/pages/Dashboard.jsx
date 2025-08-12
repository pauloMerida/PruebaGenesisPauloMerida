import React, { useEffect, useState } from "react";
import api from "../services/api";
import {
  Card,
  Row,
  Col,
  Button,
  Form
} from "react-bootstrap";
import {
  LineChart,
  Line,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell
} from "recharts";

export default function Dashboard() {
  const [ventasDiarias, setVentasDiarias] = useState([]);
  const [ventasMensuales, setVentasMensuales] = useState([]);
  const [tamales, setTamales] = useState([]);
  const [bebidasHorario, setBebidasHorario] = useState([]);
  const [picante, setPicante] = useState(null);
  const [utilidades, setUtilidades] = useState([]);
  const [desperdicio, setDesperdicio] = useState([]);
  const [llmPrompt, setLlmPrompt] = useState("");
  const [llmRespuesta, setLlmRespuesta] = useState("");

  useEffect(() => {
   
    api.getMetricas().then((data) => {
      setVentasDiarias(data.map(d => ({ fecha: d.fecha, total: d.totalVentas })));

      
      const porMes = {};
      data.forEach(d => {
        const mes = d.fecha.slice(0, 7); 
        porMes[mes] = (porMes[mes] || 0) + d.totalVentas;
      });
      setVentasMensuales(Object.entries(porMes).map(([mes, total]) => ({ mes, total })));
    });

   
    api.getTamalesMasVendidos().then(setTamales);

    
    api.getBebidasPorHorario?.().then(setBebidasHorario);

    
    api.getProporcionPicante().then(setPicante);

    
    api.getUtilidadesPorLinea?.().then(setUtilidades);


    api.getDesperdicioMaterias?.().then(setDesperdicio);
  }, []);

  const colores = ["#8884d8", "#82ca9d", "#ffc658", "#ff8042", "#8dd1e1"];

  async function preguntarLLM() {
    if (!llmPrompt.trim()) return;
    const res = await api.askLLM(llmPrompt);
    setLlmRespuesta(res.output || "Sin respuesta");
  }

  return (
    <>
      <h3>Dashboard</h3>
      <Row>
        <Col md={6}>
          <Card className="p-3 mb-3">
            <h5>Ventas Diarias</h5>
            <ResponsiveContainer width="100%" height={250}>
              <LineChart data={ventasDiarias}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="fecha" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Line type="monotone" dataKey="total" stroke="#8884d8" />
              </LineChart>
            </ResponsiveContainer>
          </Card>
        </Col>

        <Col md={6}>
          <Card className="p-3 mb-3">
            <h5>Ventas Mensuales</h5>
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={ventasMensuales}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="mes" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="total" fill="#82ca9d" />
              </BarChart>
            </ResponsiveContainer>
          </Card>
        </Col>

        <Col md={6}>
          <Card className="p-3 mb-3">
            <h5>Tamales más vendidos</h5>
            <ResponsiveContainer width="100%" height={250}>
              <BarChart layout="vertical" data={tamales}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis type="number" />
                <YAxis dataKey="nombre" type="category" />
                <Tooltip />
                <Bar dataKey="cantidad" fill="#ffc658" />
              </BarChart>
            </ResponsiveContainer>
          </Card>
        </Col>

        <Col md={6}>
          <Card className="p-3 mb-3">
            <h5>Picante vs No Picante</h5>
            <ResponsiveContainer width="100%" height={250}>
              <PieChart>
                <Pie
                  data={[
                    { name: "Con Picante", value: picante?.conPicante || 0 },
                    { name: "Sin Picante", value: (picante?.total || 0) - (picante?.conPicante || 0) }
                  ]}
                  cx="50%"
                  cy="50%"
                  label
                  outerRadius={80}
                  fill="#8884d8"
                  dataKey="value"
                >
                  {colores.map((c, i) => (
                    <Cell key={i} fill={colores[i % colores.length]} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </Card>
        </Col>

        <Col md={6}>
          <Card className="p-3 mb-3">
            <h5>Utilidades por línea</h5>
            <ResponsiveContainer width="100%" height={250}>
              <PieChart>
                <Pie
                  data={utilidades}
                  dataKey="valor"
                  nameKey="linea"
                  outerRadius={80}
                  label
                >
                  {colores.map((c, i) => (
                    <Cell key={i} fill={colores[i % colores.length]} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </Card>
        </Col>

        <Col md={6}>
          <Card className="p-3 mb-3">
            <h5>Desperdicio de Materias Primas</h5>
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={desperdicio}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="nombre" />
                <YAxis />
                <Tooltip />
                <Bar dataKey="cantidad" fill="#ff8042" />
              </BarChart>
            </ResponsiveContainer>
          </Card>
        </Col>

        <Col md={12}>
          <Card className="p-3 mb-3">
            <h5>Asistente LLM (OpenRouter)</h5>
            <Form.Control
              as="textarea"
              rows={3}
              placeholder="Escribe tu pregunta..."
              value={llmPrompt}
              onChange={(e) => setLlmPrompt(e.target.value)}
            />
            <Button className="mt-2" onClick={preguntarLLM}>Enviar</Button>
            {llmRespuesta && (
              <div className="mt-3 p-2 border rounded bg-light">
                {llmRespuesta}
              </div>
            )}
          </Card>
        </Col>
      </Row>
    </>
  );
}
