#!/usr/bin/env python3
import json
import os
import subprocess

from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS

app = Flask(__name__, static_folder=".", static_url_path="")
CORS(app)

# Ruta al lexer compilado
LEXER_PATH = os.path.join(os.path.dirname(__file__), "..", "bin", "lexer")


@app.route("/")
def index():
    """Sirve el index.html"""
    return send_from_directory(".", "index.html")


@app.route("/<path:path>")
def serve_static(path):
    """Sirve archivos estáticos (CSS, JS)"""
    return send_from_directory(".", path)


@app.route("/api/analizar", methods=["POST"])
def analizar():
    """Endpoint para analizar código con FLEX"""
    try:
        data = request.get_json()
        codigo = data.get("codigo", "")

        if not codigo:
            return jsonify({"error": "No se proporcionó código"}), 400

        # Guardar código en archivo temporal
        temp_file = "/tmp/codigo_temp.txt"
        with open(temp_file, "w") as f:
            f.write(codigo)

        # Ejecutar el lexer de FLEX
        result = subprocess.run(
            [LEXER_PATH, temp_file], capture_output=True, text=True, timeout=5
        )

        if result.returncode != 0:
            return jsonify({"error": f"Error al ejecutar lexer: {result.stderr}"}), 500

        # Parsear el JSON devuelto por el lexer
        tokens = json.loads(result.stdout)

        return jsonify({"success": True, "tokens": tokens, "total": len(tokens)})

    except subprocess.TimeoutExpired:
        return jsonify({"error": "Tiempo de análisis excedido"}), 500
    except json.JSONDecodeError as e:
        return jsonify({"error": f"Error al parsear JSON: {str(e)}"}), 500
    except Exception as e:
        return jsonify({"error": f"Error inesperado: {str(e)}"}), 500


if __name__ == "__main__":
    # Verificar que existe el lexer
    if not os.path.exists(LEXER_PATH):
        print(f"ERROR: No se encuentra el lexer en {LEXER_PATH}")
        print("Por favor, compila el lexer primero")
        exit(1)

    print("=" * 60)
    print("  SERVIDOR DEL ANALIZADOR LÉXICO")
    print("=" * 60)
    print(f"Lexer: {LEXER_PATH}")
    print("Servidor: http://localhost:5000")
    print("Presiona Ctrl+C para detener")
    print("=" * 60)

    # Cambiar al directorio web para servir archivos
    os.chdir(os.path.dirname(__file__))

    app.run(debug=True, port=5000, host="0.0.0.0")
