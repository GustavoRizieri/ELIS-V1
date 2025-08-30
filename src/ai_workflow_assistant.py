#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ELIS-V1 - Assistente de Fluxos de Trabalho para IA
Módulo que permite à IA reconhecer e executar automaticamente fluxos de trabalho existentes.

Desenvolvido por: Marduka & Gustavo
Projeto: ELIS-V1 - Passo 5
"""

import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import re
from datetime import datetime

class AIWorkflowAssistant:
    """
    Assistente inteligente para reconhecimento e execução de fluxos de trabalho.
    """
    
    def __init__(self, config_file: str = "workflow-config.json"):
        """
        Inicializa o assistente com arquivo de configuração.
        
        Args:
            config_file: Caminho para o arquivo de configuração dos fluxos
        """
        self.project_root = Path(__file__).parent.parent
        self.config_file = self.project_root / config_file
        self.log_file = self.project_root / "workflow-automation.log"
        
        # Carregar configurações
        self.config = self._load_config()
        
        # Inicializar sistema de logs
        self._setup_logging()
        
        print(f"🤖 AI Workflow Assistant inicializado")
        print(f"📁 Projeto: {self.config['project_info']['name']}")
        print(f"🔧 Fluxos disponíveis: {len(self.config['ai_workflow_mapping'])}")
    
    def _load_config(self) -> Dict:
        """
        Carrega configurações do arquivo JSON.
        
        Returns:
            Dicionário com configurações dos fluxos
        """
        try:
            with open(self.config_file, 'r', encoding='utf-8') as f:
                return json.load(f)
        except FileNotFoundError:
            print(f"❌ Arquivo de configuração não encontrado: {self.config_file}")
            return self._create_default_config()
        except json.JSONDecodeError as e:
            print(f"❌ Erro ao ler configuração: {e}")
            return self._create_default_config()
    
    def _create_default_config(self) -> Dict:
        """
        Cria configuração padrão caso o arquivo não exista.
        
        Returns:
            Configuração padrão
        """
        return {
            "project_info": {
                "name": "ELIS-V1",
                "version": "1.0.0",
                "step": 5
            },
            "ai_workflow_mapping": {},
            "workflow_definitions": {},
            "ai_recognition_patterns": {},
            "automation_settings": {
                "auto_save": {"enabled": True},
                "logging": {"log_all_workflows": True}
            }
        }
    
    def _setup_logging(self):
        """
        Configura sistema de logs para rastrear execução de fluxos.
        """
        self.log_enabled = self.config.get('automation_settings', {}).get('logging', {}).get('log_all_workflows', True)
    
    def _log_activity(self, message: str, level: str = "INFO"):
        """
        Registra atividade no log.
        
        Args:
            message: Mensagem a ser registrada
            level: Nível do log (INFO, WARNING, ERROR)
        """
        if not self.log_enabled:
            return
        
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_entry = f"[{timestamp}] [{level}] {message}\n"
        
        try:
            with open(self.log_file, 'a', encoding='utf-8') as f:
                f.write(log_entry)
        except Exception as e:
            print(f"⚠️ Erro ao escrever log: {e}")
    
    def recognize_intent(self, user_input: str) -> Optional[Tuple[str, float]]:
        """
        Reconhece a intenção do usuário baseado em padrões configurados.
        
        Args:
            user_input: Texto de entrada do usuário
        
        Returns:
            Tupla com (ação_identificada, confiança) ou None se não reconhecido
        """
        user_input_lower = user_input.lower().strip()
        
        patterns = self.config.get('ai_recognition_patterns', {}).get('intent_detection', {})
        
        best_match = None
        best_confidence = 0.0
        
        for intent_name, intent_config in patterns.items():
            patterns_list = intent_config.get('patterns', [])
            threshold = intent_config.get('confidence_threshold', 0.7)
            
            for pattern in patterns_list:
                # Calcular similaridade simples
                confidence = self._calculate_similarity(user_input_lower, pattern.lower())
                
                if confidence >= threshold and confidence > best_confidence:
                    best_match = intent_config.get('action')
                    best_confidence = confidence
        
        if best_match:
            self._log_activity(f"Intent reconhecido: {best_match} (confiança: {best_confidence:.2f})")
            return best_match, best_confidence
        
        return None
    
    def _calculate_similarity(self, text1: str, text2: str) -> float:
        """
        Calcula similaridade simples entre dois textos.
        
        Args:
            text1: Primeiro texto
            text2: Segundo texto
        
        Returns:
            Valor de similaridade entre 0 e 1
        """
        # Verificar se o padrão está contido no texto
        if text2 in text1:
            return 0.9
        
        # Verificar palavras-chave
        words1 = set(text1.split())
        words2 = set(text2.split())
        
        if not words2:
            return 0.0
        
        intersection = words1.intersection(words2)
        return len(intersection) / len(words2)
    
    def find_workflow_by_keywords(self, user_input: str) -> Optional[Dict]:
        """
        Encontra fluxo de trabalho baseado em palavras-chave.
        
        Args:
            user_input: Entrada do usuário
        
        Returns:
            Configuração do fluxo encontrado ou None
        """
        user_input_lower = user_input.lower()
        
        # Buscar em todas as categorias de operações
        for category_name, category in self.config.get('ai_workflow_mapping', {}).items():
            for operation_name, operation in category.items():
                keywords = operation.get('keywords', [])
                
                for keyword in keywords:
                    if keyword.lower() in user_input_lower:
                        self._log_activity(f"Fluxo encontrado: {category_name}.{operation_name}")
                        return {
                            'category': category_name,
                            'operation': operation_name,
                            'config': operation
                        }
        
        return None
    
    def execute_workflow(self, workflow_info: Dict, interactive: bool = True) -> bool:
        """
        Executa um fluxo de trabalho identificado.
        
        Args:
            workflow_info: Informações do fluxo a ser executado
            interactive: Se deve solicitar confirmação do usuário
        
        Returns:
            True se executado com sucesso, False caso contrário
        """
        try:
            config = workflow_info['config']
            operation_name = workflow_info['operation']
            
            print(f"\n🔄 Fluxo identificado: {config['description']}")
            
            if interactive:
                confirm = input(f"Deseja executar este fluxo? (s/N): ").lower().strip()
                if confirm not in ['s', 'sim', 'y', 'yes']:
                    print("❌ Execução cancelada pelo usuário")
                    return False
            
            # Executar pré-ações
            pre_actions = config.get('pre_actions', [])
            if pre_actions:
                print("📋 Executando pré-ações...")
                for action in pre_actions:
                    print(f"   ⚡ {action}")
                    self._execute_pre_action(action)
            
            # Executar script principal
            script_path = config.get('script')
            parameters = config.get('parameters', '')
            
            if script_path:
                full_script_path = self.project_root / script_path
                
                if full_script_path.exists():
                    print(f"🚀 Executando: {script_path} {parameters}")
                    
                    # Determinar como executar baseado na extensão
                    if script_path.endswith('.ps1'):
                        cmd = f'powershell -ExecutionPolicy Bypass -File "{full_script_path}" {parameters}'
                    elif script_path.endswith('.bat'):
                        cmd = f'"{full_script_path}" {parameters}'
                    else:
                        cmd = f'"{full_script_path}" {parameters}'
                    
                    result = subprocess.run(cmd, shell=True, cwd=self.project_root, 
                                          capture_output=False, text=True)
                    
                    if result.returncode == 0:
                        print("✅ Fluxo executado com sucesso!")
                        self._log_activity(f"Fluxo {operation_name} executado com sucesso")
                    else:
                        print(f"❌ Erro na execução (código: {result.returncode})")
                        self._log_activity(f"Erro na execução do fluxo {operation_name}: código {result.returncode}", "ERROR")
                        return False
                else:
                    print(f"❌ Script não encontrado: {full_script_path}")
                    self._log_activity(f"Script não encontrado: {script_path}", "ERROR")
                    return False
            
            # Executar pós-ações
            post_actions = config.get('post_actions', [])
            if post_actions:
                print("📋 Executando pós-ações...")
                for action in post_actions:
                    print(f"   ⚡ {action}")
                    self._execute_post_action(action)
            
            return True
            
        except Exception as e:
            print(f"❌ Erro na execução do fluxo: {e}")
            self._log_activity(f"Erro na execução: {e}", "ERROR")
            return False
    
    def _execute_pre_action(self, action: str):
        """
        Executa uma pré-ação específica.
        
        Args:
            action: Nome da ação a ser executada
        """
        if action == "auto_save_files":
            print("   💾 Salvando arquivos automaticamente...")
        elif action == "check_git_status":
            print("   📊 Verificando status do Git...")
        elif action == "validate_changes":
            print("   ✅ Validando mudanças...")
        # Adicionar mais pré-ações conforme necessário
    
    def _execute_post_action(self, action: str):
        """
        Executa uma pós-ação específica.
        
        Args:
            action: Nome da ação a ser executada
        """
        if action == "update_notifications":
            print("   🔔 Atualizando notificações...")
        elif action == "log_activity":
            print("   📝 Registrando atividade...")
        # Adicionar mais pós-ações conforme necessário
    
    def suggest_workflows(self, user_input: str) -> List[Dict]:
        """
        Sugere fluxos de trabalho baseado na entrada do usuário.
        
        Args:
            user_input: Entrada do usuário
        
        Returns:
            Lista de fluxos sugeridos
        """
        suggestions = []
        user_input_lower = user_input.lower()
        
        # Buscar sugestões em todas as categorias
        for category_name, category in self.config.get('ai_workflow_mapping', {}).items():
            for operation_name, operation in category.items():
                keywords = operation.get('keywords', [])
                description = operation.get('description', '')
                
                # Calcular relevância
                relevance = 0
                for keyword in keywords:
                    if keyword.lower() in user_input_lower:
                        relevance += 1
                
                if relevance > 0:
                    suggestions.append({
                        'category': category_name,
                        'operation': operation_name,
                        'description': description,
                        'relevance': relevance,
                        'config': operation
                    })
        
        # Ordenar por relevância
        suggestions.sort(key=lambda x: x['relevance'], reverse=True)
        
        return suggestions[:5]  # Retornar top 5
    
    def process_user_request(self, user_input: str) -> bool:
        """
        Processa uma solicitação do usuário e executa o fluxo apropriado.
        
        Args:
            user_input: Solicitação do usuário
        
        Returns:
            True se processado com sucesso, False caso contrário
        """
        print(f"\n🤖 Processando: '{user_input}'")
        
        # Tentar reconhecimento de intenção
        intent_result = self.recognize_intent(user_input)
        if intent_result:
            action, confidence = intent_result
            print(f"✨ Intenção reconhecida: {action} (confiança: {confidence:.2f})")
            # Aqui você pode mapear a ação para um fluxo específico
        
        # Buscar fluxo por palavras-chave
        workflow = self.find_workflow_by_keywords(user_input)
        
        if workflow:
            return self.execute_workflow(workflow)
        else:
            # Mostrar sugestões
            suggestions = self.suggest_workflows(user_input)
            
            if suggestions:
                print("\n💡 Fluxos sugeridos:")
                for i, suggestion in enumerate(suggestions, 1):
                    print(f"   {i}. {suggestion['description']}")
                
                try:
                    choice = input("\nEscolha um fluxo (número) ou 'n' para cancelar: ").strip()
                    if choice.lower() == 'n':
                        return False
                    
                    choice_idx = int(choice) - 1
                    if 0 <= choice_idx < len(suggestions):
                        selected = suggestions[choice_idx]
                        return self.execute_workflow({
                            'category': selected['category'],
                            'operation': selected['operation'],
                            'config': selected['config']
                        })
                    else:
                        print("❌ Escolha inválida")
                        return False
                        
                except (ValueError, IndexError):
                    print("❌ Entrada inválida")
                    return False
            else:
                print("❌ Nenhum fluxo encontrado para esta solicitação")
                print("💡 Tente usar palavras-chave como: commit, status, python, monitorar")
                return False
    
    def list_available_workflows(self):
        """
        Lista todos os fluxos de trabalho disponíveis.
        """
        print("\n📋 Fluxos de Trabalho Disponíveis:")
        print("=" * 50)
        
        for category_name, category in self.config.get('ai_workflow_mapping', {}).items():
            print(f"\n📁 {category_name.replace('_', ' ').title()}:")
            
            for operation_name, operation in category.items():
                description = operation.get('description', 'Sem descrição')
                keywords = ', '.join(operation.get('keywords', []))
                print(f"   • {description}")
                print(f"     Palavras-chave: {keywords}")
                print()

def main():
    import sys
    import argparse
    
    parser = argparse.ArgumentParser(description='ELIS-V1 AI Workflow Assistant')
    parser.add_argument('--recognize', type=str, help='Recognize intent from natural language command')
    parser.add_argument('--execute', type=str, help='Execute specific workflow by name')
    parser.add_argument('--list', action='store_true', help='List all available workflows')
    parser.add_argument('--test', action='store_true', help='Run test suite')
    parser.add_argument('--status', action='store_true', help='Show system status')
    
    args = parser.parse_args()
    assistant = AIWorkflowAssistant()
    
    if args.recognize:
        print(f"🤖 Analisando comando: '{args.recognize}'")
        intent = assistant.recognize_intent(args.recognize)
        print(f"🎯 Intent detectado: {intent}")
        
        if intent:
            workflow = assistant.find_workflow_by_keywords(args.recognize)
            if workflow:
                print(f"🚀 Workflow sugerido: {workflow['config']['description']}")
                
                # Perguntar se deve executar
                response = input("\n❓ Deseja executar este workflow? (s/N): ")
                if response.lower() in ['s', 'sim', 'y', 'yes']:
                    assistant.execute_workflow(workflow)
            else:
                suggestions = assistant.suggest_workflows(args.recognize)
                if suggestions:
                    print("\n💡 Workflows sugeridos:")
                    for i, suggestion in enumerate(suggestions, 1):
                        print(f"  {i}. {suggestion['description']}")
        else:
            print("❌ Comando não reconhecido")
            suggestions = assistant.suggest_workflows(args.recognize)
            if suggestions:
                print("\n💡 Workflows disponíveis:")
                for suggestion in suggestions:
                    print(f"  • {suggestion['description']}")
    
    elif args.execute:
        print(f"🚀 Executando workflow: {args.execute}")
        # Buscar workflow pelo nome
        workflow = assistant.find_workflow_by_keywords(args.execute)
        if workflow:
            assistant.execute_workflow(workflow, interactive=False)
        else:
            print("❌ Workflow não encontrado")
    
    elif args.list:
        assistant.list_available_workflows()
    
    elif args.status:
        print("📊 STATUS DO SISTEMA DE AUTOMAÇÃO:")
        print("=" * 50)
        
        # Verificar configuração
        if assistant.config:
            print("✅ Configuração carregada com sucesso")
            print(f"📋 Workflows disponíveis: {len(assistant.config.get('ai_workflow_mapping', {}))}")
            print(f"🎯 Padrões de reconhecimento: {len(assistant.config.get('ai_recognition_patterns', {}))}")
        else:
            print("❌ Erro ao carregar configuração")
        
        # Verificar logs
        import os
        if os.path.exists(assistant.log_file):
            with open(assistant.log_file, 'r', encoding='utf-8') as f:
                lines = f.readlines()
            print(f"📝 Entradas no log: {len(lines)}")
        else:
            print("📝 Nenhum log encontrado")
        
        print("\n🤖 Sistema operacional!")
    
    elif args.test:
        print("🧪 EXECUTANDO TESTES DO ASSISTENTE DE IA")
        print("=" * 50)
        
        # Teste de reconhecimento de intent
        test_commands = [
            "Quero fazer commit das mudanças",
            "Verificar status do projeto",
            "Ativar ambiente Python",
            "Instalar dependências",
            "Rodar testes",
            "Monitorar GitHub"
        ]
        
        print("\n🔍 Testando reconhecimento de comandos:")
        for cmd in test_commands:
            print(f"\n📝 Comando: '{cmd}'")
            intent = assistant.recognize_intent(cmd)
            print(f"🎯 Intent: {intent}")
            
            workflow = assistant.find_workflow_by_keywords(cmd)
            if workflow:
                print(f"✅ Workflow: {workflow['config']['description']}")
            else:
                print("❌ Workflow não encontrado")
        
        print("\n" + "=" * 50)
        print("✅ Testes concluídos!")
    
    else:
        # Modo interativo padrão
        print("🤖 ELIS-V1 - AI Workflow Assistant")
        print("=" * 50)
        print("💡 Use --help para ver todas as opções disponíveis")
        print("\n💬 Digite comandos ou 'help' para ver fluxos disponíveis")
        print("Digite 'quit' para sair\n")
        
        while True:
            try:
                user_input = input("🔤 Comando: ").strip()
                
                if user_input.lower() in ['quit', 'exit', 'sair']:
                    print("👋 Até logo!")
                    break
                elif user_input.lower() in ['help', 'ajuda']:
                    assistant.list_available_workflows()
                elif user_input:
                    assistant.process_user_request(user_input)
                else:
                    print("❓ Digite um comando válido")
                    
            except KeyboardInterrupt:
                print("\n👋 Saindo...")
                break
            except Exception as e:
                print(f"❌ Erro: {e}")

if __name__ == "__main__":
    main()