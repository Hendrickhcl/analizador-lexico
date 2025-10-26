# 🔍 Analizador Léxico

Analizador léxico implementado con **FLEX**.

## 🚀 Inicio Rápido

### Compilar
```bash
flex -o src/lex.yy.c src/lexer.l
gcc src/lex.yy.c -o bin/lexer
```

### Usar desde Terminal
```bash
echo 'int x = 10;' | ./bin/lexer
```

### Usar con Interfaz Web
```bash
# Instalar dependencias
sudo pacman -S python-flask python-flask-cors

# Iniciar servidor
python3 web/server.py

# Abrir navegador o tu navegador de preferencia
firefox http://localhost:5000
```

## 📁 Estructura
```
├── src/
│   └── lexer.l              # Analizador FLEX
├── bin/
│   └── lexer                # Ejecutable compilado
├── web/
│   ├── index.html           # Interfaz web
│   ├── css/styles.css       # Estilos
│   ├── js/lexer.js          # Frontend
│   └── server.py            # Backend Flask
└── examples/
    └── test.txt             # Código de ejemplo
```

##  Características

- ✅ Reconoce 18+ tipos de tokens
- ✅ Palabras reservadas: if, else, while, for, return...
- ✅ Tipos de datos: int, float, string, bool
- ✅ Operadores: aritméticos, relacionales, lógicos
- ✅ Números enteros y reales
- ✅ Cadenas de texto
- ✅ Comentarios (`//`)
- ✅ Salida en formato JSON


##  Tecnologías

- **FLEX** - Generador de analizadores léxicos
- **C/GCC** - Compilación del lexer
- **Python/Flask** - Servidor backend
- **HTML/CSS/JavaScript** - Interfaz web

