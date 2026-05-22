# ⚡ QUICK START - KDP Author Manager

## 🚀 Ejecutar en 5 Minutos

### Paso 1: Limpiar (IMPORTANTE)
```bash
docker-compose down -v
docker system prune -f
```

### Paso 2: Ejecutar
```bash
chmod +x deploy.sh
./deploy.sh
```

### Paso 3: Acceder
```
http://localhost:8000/admin
Email:    admin@kdpmanager.local
Password: password
```

## 📍 URLs
- **Admin Panel:** http://localhost:8000/admin
- **Base de Datos:** http://localhost:8080
- **Aplicación:** http://localhost:8000

## 🐳 Contenedores
```bash
docker ps          # Ver contenedores
docker-compose logs -f app     # Ver logs
docker exec -it kdp-app bash   # Acceder a bash
```

## ✅ ¿Funcionó?
Si ves el login de Filament en http://localhost:8000/admin, ¡ÉXITO! ✨

## 🛠️ Si Falla
```bash
docker-compose logs app    # Ver qué pasó
docker system prune -f     # Limpiar
./deploy.sh                # Reintentar
```

## 📚 Documentación
- `README.md` - Documentación completa
- `DEPLOYMENT_GUIDE.md` - Guía detallada
- `DOCKERFILE_FIX.md` - Explicación del Dockerfile

---

**Estado:** ✅ Funcional sin errores
**Versión:** 1.0.2
