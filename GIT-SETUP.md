# 🔧 Configuración de Git - Gangster MMO RPG

## ✅ Estado Actual
- ✅ Repositorio Git inicializado
- ✅ Commit inicial creado: `[001] Configuración inicial del proyecto`
- ⏳ Pendiente: Conectar con repositorio remoto

## 🚀 Opciones para Subir tu Proyecto

### Opción 1: GitHub (Recomendado) 🌟

#### Paso 1: Crear repositorio en GitHub
1. Ve a https://github.com/new
2. Nombre del repositorio: `gangster-mmo-rpg` (o el que prefieras)
3. Descripción: "MMO RPG 3D con estética chunky pixel art y temática de gangsters"
4. ⚠️ **NO marques** "Initialize with README" (ya tenemos uno)
5. ⚠️ **NO agregues** .gitignore ni licencia (ya los tenemos)
6. Click en "Create repository"

#### Paso 2: Conectar y subir (ejecuta estos comandos)
```powershell
# Conectar con tu repositorio
git remote add origin https://github.com/TU-USUARIO/gangster-mmo-rpg.git

# Subir el proyecto
git push -u origin main
```

---

### Opción 2: GitLab 🦊

#### Paso 1: Crear repositorio en GitLab
1. Ve a https://gitlab.com/projects/new
2. Nombre: `gangster-mmo-rpg`
3. Visibility: Private/Public (tu elección)
4. ⚠️ **NO marques** "Initialize repository with a README"
5. Click en "Create project"

#### Paso 2: Conectar y subir
```powershell
git remote add origin https://gitlab.com/TU-USUARIO/gangster-mmo-rpg.git
git push -u origin main
```

---

### Opción 3: Bitbucket 🪣

#### Paso 1: Crear repositorio en Bitbucket
1. Ve a https://bitbucket.org/repo/create
2. Nombre: `gangster-mmo-rpg`
3. ⚠️ **NO marques** "Include a README"
4. Click en "Create repository"

#### Paso 2: Conectar y subir
```powershell
git remote add origin https://bitbucket.org/TU-USUARIO/gangster-mmo-rpg.git
git push -u origin main
```

---

## 📝 Comandos Útiles de Git

### Ver estado actual
```powershell
git status
```

### Ver historial de commits
```powershell
git log --oneline
```

### Agregar cambios
```powershell
# Agregar todos los archivos modificados
git add .

# Agregar un archivo específico
git add ruta/al/archivo.gd
```

### Hacer commit
```powershell
git commit -m "Descripción del cambio"
```

### Subir cambios al servidor
```powershell
git push
```

### Descargar cambios del servidor
```powershell
git pull
```

### Ver repositorio remoto configurado
```powershell
git remote -v
```

---

## 🔐 Configuración de Usuario (si no la tienes)

```powershell
# Configurar tu nombre
git config --global user.name "Tu Nombre"

# Configurar tu email
git config --global user.email "tu@email.com"

# Verificar configuración
git config --list
```

---

## 📦 Archivos que Git Está Ignorando

Gracias al `.gitignore`, estos archivos **NO se subirán**:
- `.godot/` (archivos de caché de Godot)
- `*.import` (archivos de importación)
- Archivos temporales y de sistema
- Builds y exports

---

## ⚠️ Notas Importantes

1. **Ejecutables de Godot**: Los archivos `.exe` en `godot-engine/` SE ESTÁN SUBIENDO actualmente.
   - Si NO quieres subirlos, agrégalos al `.gitignore`:
   ```
   godot-engine/*.exe
   ```

2. **Assets Grandes**: Si tienes archivos muy pesados (>100MB), considera usar Git LFS.

3. **Proyecto sd-s**: La carpeta `sd-s/` también se está subiendo. Si quieres eliminarla del repo:
   ```powershell
   git rm -r sd-s
   git commit -m "Eliminar proyecto de prueba vacío"
   ```

---

## 🎯 Próximos Pasos Recomendados

1. ✅ Crear repositorio en GitHub/GitLab/Bitbucket
2. ✅ Ejecutar los comandos de conexión y push
3. 📝 Actualizar el README con el link del repositorio
4. 🏷️ Crear un tag para la versión inicial:
   ```powershell
   git tag -a v0.1.0 -m "Versión inicial - Estructura base"
   git push origin v0.1.0
   ```

---

**¿Listo para subir tu proyecto? Elige una opción y sigue los pasos!** 🚀
