#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Testes para o módulo principal do ELIS-V1
Projeto colaborativo desenvolvido por Marduka e Gustavo
"""

import unittest
import sys
from pathlib import Path

# Adicionar o diretório src ao path para importações
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root / "src"))

class TestMain(unittest.TestCase):
    """
    Classe de testes para funcionalidades principais
    """
    
    def setUp(self):
        """
        Configuração executada antes de cada teste
        """
        self.project_root = Path(__file__).parent.parent
    
    def test_project_structure(self):
        """
        Testa se a estrutura básica do projeto existe
        """
        # Verificar diretórios essenciais
        essential_dirs = ["src", "tests", "docs", "scripts", ".venv"]
        
        for directory in essential_dirs:
            dir_path = self.project_root / directory
            self.assertTrue(dir_path.exists(), f"Diretório {directory} não encontrado")
    
    def test_essential_files(self):
        """
        Testa se os arquivos essenciais existem
        """
        essential_files = [
            "requirements.txt",
            "activate-python.bat",
            "README.md",
            "src/__init__.py",
            "src/main.py"
        ]
        
        for file in essential_files:
            file_path = self.project_root / file
            self.assertTrue(file_path.exists(), f"Arquivo {file} não encontrado")
    
    def test_python_environment(self):
        """
        Testa se o ambiente Python está configurado corretamente
        """
        # Verificar se estamos usando Python 3.6+
        self.assertGreaterEqual(sys.version_info.major, 3)
        self.assertGreaterEqual(sys.version_info.minor, 6)
        
        # Verificar se o diretório .venv existe
        venv_path = self.project_root / ".venv"
        self.assertTrue(venv_path.exists(), "Ambiente virtual não encontrado")
    
    def test_import_main_module(self):
        """
        Testa se o módulo principal pode ser importado
        """
        try:
            import main
            self.assertTrue(True, "Módulo main importado com sucesso")
        except ImportError as e:
            self.fail(f"Falha ao importar módulo main: {e}")

class TestProjectConfiguration(unittest.TestCase):
    """
    Testes para configuração do projeto
    """
    
    def test_requirements_file(self):
        """
        Testa se o arquivo requirements.txt está bem formado
        """
        project_root = Path(__file__).parent.parent
        requirements_file = project_root / "requirements.txt"
        
        self.assertTrue(requirements_file.exists(), "requirements.txt não encontrado")
        
        # Verificar se o arquivo não está vazio
        content = requirements_file.read_text(encoding='utf-8')
        self.assertGreater(len(content.strip()), 0, "requirements.txt está vazio")
    
    def test_activation_script(self):
        """
        Testa se o script de ativação existe
        """
        project_root = Path(__file__).parent.parent
        activation_script = project_root / "activate-python.bat"
        
        self.assertTrue(activation_script.exists(), "activate-python.bat não encontrado")

def run_tests():
    """
    Executa todos os testes
    """
    print("="*60)
    print("    ELIS-V1 - Executando Testes")
    print("    Projeto: Marduka & Gustavo")
    print("="*60)
    print()
    
    # Descobrir e executar todos os testes
    loader = unittest.TestLoader()
    suite = loader.discover('.', pattern='test_*.py')
    
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)
    
    print()
    print("="*60)
    if result.wasSuccessful():
        print("✅ Todos os testes passaram!")
    else:
        print("❌ Alguns testes falharam.")
        print(f"   Falhas: {len(result.failures)}")
        print(f"   Erros: {len(result.errors)}")
    print("="*60)
    
    return result.wasSuccessful()

if __name__ == "__main__":
    run_tests()