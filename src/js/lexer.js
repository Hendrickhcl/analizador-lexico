// URL del servidor backend
const API_URL = 'http://localhost:5000/api/analizar';

/**
 * Función principal para analizar el código usando FLEX
 */
async function analizar() {
  const codigo = document.getElementById('codigo').value;

  if (!codigo.trim()) {
    alert('Por favor, ingresa código para analizar');
    return;
  }

  document.getElementById('status').textContent = 'Analizando con FLEX...';
  document.getElementById('status').style.color = '#FFA500';

  try {
    // Llamar al servidor Flask que ejecuta el lexer de FLEX
    const response = await fetch(API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ codigo: codigo })
    });

    const data = await response.json();

    if (data.success) {
      mostrarTokens(data.tokens);
      document.getElementById('status').textContent = `Análisis completado con FLEX: ${data.total} tokens encontrados`;
      document.getElementById('status').style.color = '#4CAF50';
    } else {
      throw new Error(data.error || 'Error desconocido');
    }

  } catch (error) {
    console.error('Error:', error);
    document.getElementById('status').textContent = `Error: ${error.message}`;
    document.getElementById('status').style.color = '#f44336';
    alert('Error al analizar: ' + error.message + '\n\n¿Está el servidor corriendo? Ejecuta: python web/server.py');
  }
}

/**
 * Muestra los tokens en la tabla HTML
 * @param {Array} tokens - Array de tokens a mostrar
 */
function mostrarTokens(tokens) {
  const tbody = document.getElementById('tokens-body');
  tbody.innerHTML = '';

  tokens.forEach((token, index) => {
    const tr = document.createElement('tr');
    tr.style.background = index % 2 === 0 ? '#f9f9f9' : 'white';
    tr.innerHTML = `
            <td><strong>${escapeHtml(token.tipo)}</strong></td>
            <td><code>${escapeHtml(token.lexema)}</code></td>
            <td>${token.linea}</td>
            <td>${token.columna}</td>
        `;
    tbody.appendChild(tr);
  });
}

/**
 * Escapa caracteres HTML para prevenir XSS
 * @param {string} text - Texto a escapar
 * @returns {string} Texto escapado
 */
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

/**
 * Limpia el editor y la tabla de tokens
 */
function limpiar() {
  document.getElementById('codigo').value = '';
  document.getElementById('tokens-body').innerHTML = `
        <tr>
            <td colspan="4" style="text-align: center; color: #999; padding: 40px;">
                Escribe código y presiona "Analizar"
            </td>
        </tr>
    `;
  document.getElementById('status').textContent = 'Limpiado';
  document.getElementById('status').style.color = '#4CAF50';
}

/**
 * Carga ejemplos de código predefinidos
 * @param {number} num - Número del ejemplo (1, 2 o 3)
 */
function cargarEjemplo(num) {
  const ejemplos = {
    1: `int x = 10;
float pi = 3.14;
string mensaje = "Hola Mundo";
bool activo = true;`,

    2: `int edad = 18;
if (edad >= 18) {
    print("Eres mayor de edad");
} else {
    print("Eres menor de edad");
}`,

    3: `int suma = 0;
for (int i = 1; i <= 10; i = i + 1) {
    suma = suma + i;
}
print(suma);`
  };

  document.getElementById('codigo').value = ejemplos[num] || '';
  document.getElementById('status').textContent = `Ejemplo ${num} cargado - Usando FLEX`;
  document.getElementById('status').style.color = '#2196F3';
}

// Atajo de teclado F5 para analizar
document.addEventListener('keydown', (e) => {
  if (e.key === 'F5') {
    e.preventDefault();
    analizar();
  }
});
