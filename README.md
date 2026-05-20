# Proyectos de Eduardo Alzogaray (Nahue)

> Marketplace local + Utilidad Windows hechos en Chajarí, Entre Ríos.

Este repositorio contiene dos proyectos independientes pero relacionados:

1. **Chajarí Oficios** — Marketplace local de oficios y profesionales.
2. **Deep Clean v3.6** — Limpiador profundo y seguro para Windows.

---

## 📋 Tabla de contenidos

- [Chajarí Oficios](#chajarí-oficios)
- [Deep Clean v3.6](#deep-clean-v36)
- [Cómo correr los proyectos](#cómo-correr-los-proyectos)
- [Stack técnico](#stack-técnico)
- [Próximas mejoras](#próximas-mejoras)
- [Contacto](#contacto)

---

## 🛠️ Chajarí Oficios

### Descripción

Marketplace donde personas que necesitan un oficio (plomero, electricista, fumigador, etc.) pueden publicar trabajos y los profesionales pueden postularse.

### Características v2.0

- ✅ **Sistema de estado robusto** con versionado y validación
- ✅ **Validaciones de formulario** completas (nombre, WhatsApp, descripción, etc.)
- ✅ **Búsqueda con debounce** (no se ejecuta cada tecla)
- ✅ **Filtros** por categoría, zona, ordenamiento
- ✅ **Mis postulaciones** con estado y opción de cancelar
- ✅ **Contacto directo por WhatsApp** desde cada trabajo
- ✅ **Modo urgente** con badge destacado
- ✅ **Avatares automáticos** con iniciales y color único por usuario
- ✅ **Tiempo relativo** ("Hace 3 horas", "Hace 2 días")
- ✅ **Formato de precios** en pesos argentinos
- ✅ **Accesibilidad** (ARIA labels, focus rings, contraste)
- ✅ **Responsive** mobile/tablet/desktop
- ✅ **Atajos de teclado** (Ctrl+K para publicar, ESC para cerrar)
- ✅ **Toasts** elegantes con auto-dismiss
- ✅ **Sin contaminar el scope global** (todo encapsulado en `App`)

### Arquitectura

```
App = IIFE {
  ├── Utils           → Funciones reutilizables (escape HTML, debounce, etc.)
  ├── State           → Manejo de estado con localStorage validado
  ├── Validator       → Validaciones de inputs
  ├── UI              → Renderizado, modales, toasts
  ├── WorkManager     → Lógica de trabajos (publicar, postularse, filtrar)
  ├── UserManager     → Registro de profesionales
  └── init            → Inicialización
}
```

### Próximas features

- [ ] Backend con Supabase (auth real + DB)
- [ ] Subida de fotos a trabajos
- [ ] Sistema de reseñas y estrellas
- [ ] Notificaciones push cuando hay nuevas postulaciones
- [ ] Panel admin para moderar trabajos

---

## 🧹 Deep Clean v3.6

### Descripción

Script `.bat` que limpia profundamente Windows liberando GB de espacio. Es 100% seguro: solo borra archivos basura sin tocar nada importante.

### Mejoras v3.6 vs v3.5

| Característica | v3.5 | v3.6 |
|---|---|---|
| Pasos de limpieza | 9 | 12 |
| Modos | 1 (todo) | 3 (safe / completo / personalizado) |
| Punto de restauración | ❌ | ✅ |
| Reporte automático | ❌ | ✅ (en escritorio) |
| Cache VS Code | ❌ | ✅ |
| Cache NPM/Yarn | ❌ | ✅ |
| Firefox & Brave | ❌ | ✅ |
| Cálculo de espacio liberado | ❌ | ✅ |
| Output visual | Básico | Mejorado con símbolos |

### Qué limpia

1. **Temporales del usuario** (`%TEMP%`)
2. **Temporales de Windows** (`C:\Windows\Temp`)
3. **Prefetch** (`C:\Windows\Prefetch`)
4. **Miniaturas e iconos** (thumbcache, IconCache)
5. **Papelera y archivos recientes**
6. **Cache DNS** (`ipconfig /flushdns`)
7. **Reportes de errores y crash dumps** (WER, CrashDumps)
8. **Logs de Windows**
9. **Windows Update y Delivery Optimization**
10. **Navegadores** (Chrome, Edge, Firefox, Brave)
11. **Dev tools** (VS Code, NPM, Yarn, Cypress) — *Nuevo*
12. **DISM** (limpieza profunda de componentes) — opcional

### Modos de uso

- **Safe**: solo pasos 1-8 (los más básicos y seguros)
- **Completo**: los 12 pasos (recomendado)
- **Personalizado**: el script te pregunta antes de cada paso opcional

---

## 🚀 Cómo correr los proyectos

### Chajarí Oficios

**Opción A: Localmente**
1. Abrí `chajari-oficios-v2.html` con doble click → se abre en el navegador

**Opción B: En Vercel**
```bash
cd carpeta-del-proyecto
vercel --prod
```

Te da una URL pública para compartir.

### Deep Clean v3.6

1. Descargá `deep-clean-v3.6.bat` desde la landing
2. Click derecho → **"Ejecutar como administrador"**
3. Seguí las instrucciones en pantalla

**Importante**: el modo administrador es necesario para acceder a carpetas del sistema.

---

## 🔧 Stack técnico

### Chajarí Oficios

- **HTML5 + CSS3** (sin frameworks pesados)
- **Tailwind CSS** (vía CDN)
- **JavaScript vanilla ES6+** (sin React/Vue por ahora)
- **localStorage** para persistencia (migrable a Supabase)
- **FontAwesome 6.5** para iconos
- **Inter + Space Grotesk** como tipografía

### Deep Clean

- **Batch script** (`.bat`) — funciona en Windows 7+
- **PowerShell** para crear punto de restauración
- **WMIC** para medir espacio en disco
- **DISM** para limpieza profunda (opcional)

---

## 🗺️ Próximas mejoras

### Chajarí Oficios

- [ ] Migrar localStorage → Supabase (PostgreSQL + Auth real)
- [ ] Subida de imágenes a Cloudinary
- [ ] Notificaciones por WhatsApp Business API
- [ ] Sistema de reseñas y rating de 5 estrellas
- [ ] Panel admin para moderar contenido
- [ ] Pagos con Mercado Pago para destacar trabajos
- [ ] Versión PWA instalable
- [ ] Geolocalización para "trabajos cerca mío"

### Deep Clean

- [ ] Versión PowerShell con GUI (Windows Forms)
- [ ] Versión portable que no requiera ejecutar como admin
- [ ] Sincronización con OneDrive antes de limpiar
- [ ] Programador para limpieza automática mensual
- [ ] Estadísticas históricas (cuánto liberó en cada ejecución)

---

## 📁 Estructura de archivos

```
proyectos-nahue/
├── chajari-oficios-v2.html        ← Marketplace completo
├── deep-clean-v3.6.bat            ← Script de limpieza
├── deep-clean-landing.html        ← Landing del script
├── README.md                       ← Este archivo
└── GUIA-DE-USUARIO.md             ← Guía para usuarios finales
```

---

## 📞 Contacto

**Eduardo Alzogaray (Nahue)**
Chajarí, Entre Ríos, Argentina

- 📧 Email: nahuealzogaray01@gmail.com
- 💬 WhatsApp: [+54 9 3456 461557](https://wa.me/5493456461557)
- 🐙 GitHub: [@elfinalestacercaarg](https://github.com/elfinalestacercaarg)
- 📷 Instagram: [@postaleslindasdechajari](https://instagram.com/postaleslindasdechajari)

---

## 📄 Licencia

Estos proyectos son **código abierto** bajo licencia MIT.

Sentite libre de:
- ✅ Usarlos personal o comercialmente
- ✅ Modificarlos
- ✅ Distribuirlos
- ✅ Crear forks

Solo te pido que mantengas la atribución original.

---

**Hecho con 💚 en Chajarí, Entre Ríos** • 2026
