#!/bin/bash

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║     🚀 KDP AUTHOR MANAGER - DESPLIEGUE SIMPLIFICADO       ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker no está instalado${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}✗ Docker Compose no está instalado${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker y Docker Compose detectados${NC}"
echo ""

# Crear .env si no existe
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}▶ Creando archivo .env${NC}"
    cp .env.example .env 2>/dev/null || cp .env.local .env 2>/dev/null || {
        echo -e "${RED}✗ No se encontró .env.example o .env.local${NC}"
        exit 1
    }
    echo -e "${GREEN}✓ .env creado${NC}"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}▶ Limpiando contenedores previos...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

docker-compose down 2>/dev/null || true
sleep 2

echo -e "${GREEN}✓ Limpieza completada${NC}"
echo ""

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}▶ Construyendo y levantando contenedores...${NC}"
echo -e "${YELLOW}   (Esto puede tomar 2-3 minutos)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

docker-compose up -d --build

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Error al construir. Ver logs: docker-compose logs${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Contenedores levantados${NC}"
echo ""

echo -e "${YELLOW}▶ Esperando a que MySQL esté listo (25 segundos)...${NC}"
sleep 25

echo -e "${GREEN}✓ MySQL listo${NC}"
echo ""

# Crear usuario admin
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}▶ Creando usuario admin...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

docker exec kdp-app php artisan tinker <<'TINKER'
User::firstOrCreate(
    ['email' => 'admin@kdpmanager.local'],
    [
        'name' => 'Administrador',
        'password' => Hash::make('password')
    ]
);
exit;
TINKER

echo -e "${GREEN}✓ Usuario admin creado${NC}"
echo ""

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ ¡DESPLIEGUE COMPLETADO CON ÉXITO!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${YELLOW}🌐 URLs DE ACCESO:${NC}"
echo -e "  ${BLUE}Admin Panel:${NC}  http://localhost:8000/admin"
echo -e "  ${BLUE}Aplicación:${NC}   http://localhost:8000"
echo -e "  ${BLUE}PhpMyAdmin:${NC}   http://localhost:8080"
echo ""

echo -e "${YELLOW}🔑 CREDENCIALES:${NC}"
echo -e "  ${BLUE}Email:${NC}    admin@kdpmanager.local"
echo -e "  ${BLUE}Password:${NC} password"
echo ""

echo -e "${YELLOW}💾 BASE DE DATOS:${NC}"
echo -e "  ${BLUE}Host:${NC}     localhost:3306"
echo -e "  ${BLUE}Database:${NC} kdp_author_manager"
echo -e "  ${BLUE}User:${NC}     kdp_user"
echo -e "  ${BLUE}Password:${NC} kdp_password"
echo ""

echo -e "${YELLOW}🐳 CONTENEDORES:${NC}"
docker ps --format "table {{.Names}}\t{{.Status}}" | grep kdp || echo "Contenedores ejecutándose"
echo ""

echo -e "${YELLOW}🛠️ COMANDOS ÚTILES:${NC}"
echo "  Ver logs:       docker-compose logs -f app"
echo "  Bash en app:    docker exec -it kdp-app bash"
echo "  Parar:          docker-compose down"
echo "  Reiniciar:      docker-compose restart"
echo ""

echo -e "${GREEN}¡Abre http://localhost:8000/admin y comienza! 🚀${NC}"
echo ""
