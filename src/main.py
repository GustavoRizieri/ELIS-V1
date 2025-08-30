#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ELIS-V1 - Arquivo Principal
Projeto colaborativo desenvolvido por Marduka e Gustavo usando Trae-IDE com IA.

Este é o ponto de entrada principal do projeto Python.
"""

import sys
import os
from pathlib import Path

# Adicionar o diretório src ao path para importações
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root / "src"))

def main():
    """
    Função principal do projeto ELIS-V1
    """
    print("="*50)
    print("    ELIS-V1 - Projeto Python")
    print("    Desenvolvido por: Marduka & Gustavo")
    print("    Usando: Trae-IDE com IA")
    print("="*50)
    print()
    
    # Verificar se estamos no ambiente virtual
    if hasattr(sys, 'real_prefix') or (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix):
        print("✅ Ambiente virtual ativo")
    else:
        print("⚠️  Ambiente virtual não detectado")
        print("   Execute: activate-python.bat")
    
    print(f"📁 Diretório do projeto: {project_root}")
    print(f"🐍 Versão do Python: {sys.version}")
    print(f"📦 Localização do Python: {sys.executable}")
    print()
    
    # Verificar estrutura do projeto
    print("📋 Estrutura do projeto:")
    check_project_structure()
    print()
    
    print("🚀 Projeto ELIS-V1 pronto para desenvolvimento!")
    print("   Adicione seu código nos módulos da pasta 'src/'")
    print()

def check_project_structure():
    """
    Verifica e exibe a estrutura do projeto
    """
    project_root = Path(__file__).parent.parent
    
    essential_dirs = [
        "src",
        "tests", 
        "docs",
        "scripts",
        ".venv"
    ]
    
    essential_files = [
        "requirements.txt",
        "activate-python.bat",
        "README.md"
    ]
    
    for directory in essential_dirs:
        dir_path = project_root / directory
        if dir_path.exists():
            print(f"   ✅ {directory}/")
        else:
            print(f"   ❌ {directory}/ (não encontrado)")
    
    for file in essential_files:
        file_path = project_root / file
        if file_path.exists():
            print(f"   ✅ {file}")
        else:
            print(f"   ❌ {file} (não encontrado)")

if __name__ == "__main__":
    main()