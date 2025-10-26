cat >> README.md << 'ENDREADME'

## Clonar el Proyecto
```bash
git clone https://github.com/Hendrickhcl/analizador-lexico.git
cd analizador-lexico
```

## Instalación de Dependencias

### Arch Linux
```bash
sudo pacman -S flex gcc python python-flask python-flask-cors
```
## Uso

### Opción 1: Terminal
```bash
flex -o src/lex.yy.c src/lexer.l
gcc src/lex.yy.c -o bin/lexer
echo 'int x = 10;' | ./bin/lexer
```

### Opción 2: Interfaz Web (Recomendado)
```bash
# Instalar dependencias
sudo pacman -S python-flask python-flask-cors

# Iniciar servidor
python web/server.py

# Abre http://localhost:5000 en tu navegador
```
