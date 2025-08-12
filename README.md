


# 📦 Proyecto Cazuela - Documentación Completa

## 📑 Índice
1. Introducción
2. Arquitectura General
3. Base de Datos
4. Backend (.NET 7 API)
5. Frontend (ReactJS)
6. Aplicación Móvil (Flutter)
7. Integración LLM con OpenRouter
8. Guías de Usuario
9. Despliegue y Configuración
10. Diagramas Técnicos
11. Glosario de Conceptos

---

## 1. 📖 Introducción

**Cazuela** es un sistema integral para la gestión de un negocio de alimentos y bebidas.  
Incluye:
- Gestión de **productos**, **atributos** y **combos**.
- Registro de **ventas** y seguimiento de inventario.
- **Dashboard** con métricas en tiempo real.
- Aplicación móvil Flutter para operaciones rápidas.
- Integración con **LLM** (modelos de lenguaje) mediante **OpenRouter**.

El software está compuesto por:
- **Base de datos SQL Server** (esquema `cazuela`).
- **Backend API REST** en .NET 7.
- **Frontend web** en React + Bootstrap.
- **App móvil** en Flutter.
- **Gráficas interactivas** y análisis de datos.

---

## 2. 🏗 Arquitectura General

```plaintext
+--------------------+        HTTP/JSON         +-------------------+
|    React Frontend  | <----------------------> |    .NET 7 API     |
+--------------------+                          +-------------------+
         ^                                              |
         |                                              v
+--------------------+                           +-------------------+
| Flutter Mobile App |                           |  SQL Server DB    |
+--------------------+                           +-------------------+
                                                    (Esquema cazuela)
```

- **React** y **Flutter** consumen los mismos endpoints.
- El backend centraliza la lógica de negocio y accede a la base de datos.
- La base de datos mantiene la consistencia entre ventas, inventario y combos.
- **LLM** se integra vía API para consultas inteligentes.

---

## 3. 🗄 Base de Datos

### 3.1. Tablas Principales

| Tabla                | Descripción |
|----------------------|-------------|
| `Productos`          | Lista de productos disponibles. |
| `Atributos`          | Características como "Picante", "Sin azúcar". |
| `ProductoAtributos`  | Relación Producto ↔ Atributo. |
| `Combos`             | Paquetes de productos. |
| `ComboItems`         | Productos que componen un combo. |
| `Ventas`             | Encabezado de venta. |
| `VentaDetalles`      | Productos vendidos por venta. |
| `Sucursales`         | Puntos de venta. |
| `MateriasPrimas`     | Ingredientes e insumos. |
| `Inventario`         | Movimientos y stock. |
| `LLMLogs`            | Historial de consultas al LLM. |

### 3.2. Diagrama Entidad-Relación (simplificado)

```plaintext
Productos(ProductoID) ----< ProductoAtributos >---- Atributos(AtributoID)
       |                                             
       |                                              
       v
ComboItems(ProductoID) ----> Combos(ComboID)

Ventas(VentaID) ----< VentaDetalles >---- Productos(ProductoID)
```

---

## 4. 🔧 Backend (.NET 7 API)

### 4.1. Estructura

```plaintext
Backend/
 ├── Program.cs
 ├── Models/
 ├── Endpoints/
 ├── Data/
 └── appsettings.json
```

### 4.2. Endpoints Principales

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET    | `/api/productos` | Lista todos los productos. |
| GET    | `/api/combos` | Lista combos con productos incluidos. |
| POST   | `/api/ventas` | Registra una venta. |
| GET    | `/api/dashboard/ventas/diarias` | Métricas de ventas. |
| POST   | `/api/llm/ask` | Consulta al modelo LLM. |

---

## 5. 🌐 Frontend (ReactJS)

### 5.1. Estructura

```plaintext
frontend/
 ├── src/
 │   ├── components/
 │   ├── pages/
 │   ├── services/
 │   └── App.jsx
 ├── package.json
```

### 5.2. Funcionalidades
- **Venta rápida** con selección de productos y atributos.
- **Gestión de combos** con nombres y cantidades.
- **Dashboard** con gráficas (ventas, productos más vendidos, desperdicio).
- **Integración LLM** con interfaz de chat.

---

## 6. 📱 Aplicación Flutter

### 6.1. Estructura

```plaintext
cazuela_flutter/
 ├── lib/
 │   ├── models/
 │   ├── pages/
 │   ├── services/
 │   └── widgets/
 ├── pubspec.yaml
```

### 6.2. Funcionalidades
- Consumo de los mismos endpoints del backend.
- Registro de ventas.
- Visualización de combos y atributos.
- Dashboard móvil adaptado.
- Chat LLM integrado.

---

## 7. 🤖 Integración LLM

- Uso de **OpenRouter API** con modelos gratuitos.
- Backend expone `/api/llm/ask` que recibe `{ prompt }` y retorna la respuesta del modelo.
- Respuestas se almacenan en `LLMLogs`.

---

## 8. 👩‍💻 Guías de Usuario

### 8.1. Web
1. Iniciar sesión (si aplica).
2. Ir a **Ventas** para registrar pedidos.
3. Seleccionar sucursal y productos.
4. Confirmar venta.

### 8.2. Flutter
1. Abrir app y seleccionar módulo deseado.
2. Registrar ventas o consultar métricas.

---

## 9. 🚀 Despliegue y Configuración

### Backend
```bash
dotnet restore
dotnet run
```

### Frontend
```bash
npm install
npm run dev
```

### Flutter
```bash
flutter pub get
flutter run
```

---

## 10. 📊 Diagramas Técnicos

### 10.1. Flujo de Venta

```plaintext
Usuario → Frontend → POST /api/ventas → Backend → BD
```

### 10.2. Integración LLM

```plaintext
Frontend → /api/llm/ask → Backend → OpenRouter → Backend → Frontend
```

---

## 11. 📚 Glosario
- **Combo**: Paquete de productos vendidos juntos.
- **Atributo**: Característica adicional de un producto.
- **LLM**: Large Language Model, IA capaz de procesar lenguaje natural.




