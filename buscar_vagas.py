#!/usr/bin/env python3
"""
Script para buscar vagas no Google Jobs usando a API de busca do Google.
Salva os resultados em um arquivo JSON e retorna um resumo em Markdown.
"""

import requests
import json
import argparse
import os
import re
from datetime import datetime
from dotenv import load_dotenv

# Carrega variáveis de ambiente do arquivo .env
load_dotenv()


def buscar_vagas_adzuna(query, max_results=10):
    """Busca vagas no Adzuna usando a API."""
    app_id = os.getenv("ADZUNA_APP_ID")
    app_key = os.getenv("ADZUNA_APP_KEY")
    
    if not app_id or not app_key:
        raise ValueError("As variáveis ADZUNA_APP_ID e ADZUNA_APP_KEY devem ser definidas no arquivo .env")
    
    url = "https://api.adzuna.com/v1/api/jobs/us/search/1"
    params = {
        "app_id": app_id,
        "app_key": app_key,
        "results_per_page": max_results,
        "what": query,
        "content-type": "application/json",
    }
    
    response = requests.get(url, params=params)
    response.raise_for_status()
    vagas = response.json().get("results", [])[:max_results]
    
    resultados = []
    for vaga in vagas:
        resultados.append({
            "titulo": vaga.get("title", "Sem título"),
            "empresa": vaga.get("company", {}).get("display_name", "Desconhecida"),
            "local": vaga.get("location", {}).get("display_name", "Remoto"),
            "url": vaga.get("redirect_url", "#"),
            "data_publicacao": vaga.get("created", "Data não informada"),
        })
    
    return resultados


def salvar_resultados(vagas, arquivo_saida):
    """Salva os resultados em um arquivo JSON."""
    with open(arquivo_saida, "w", encoding="utf-8") as f:
        json.dump(vagas, f, ensure_ascii=False, indent=2)


def gerar_resumo_markdown(vagas, arquivo_markdown):
    """Gera um resumo das vagas em Markdown."""
    with open(arquivo_markdown, "w", encoding="utf-8") as f:
        f.write("# 📌 Vagas Encontradas\n\n")
        f.write(f"Atualizado em: {datetime.now().strftime('%d/%m/%Y %H:%M')}\n\n")
        for vaga in vagas:
            f.write(f"## {vaga['titulo']}\n")
            f.write(f"- **Empresa:** {vaga['empresa']}\n")
            f.write(f"- **Local:** {vaga['local']}\n")
            f.write(f"- **Data de Publicação:** {vaga['data_publicacao']}\n")
            f.write(f"- [Ver Vaga]({vaga['url']})\n\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Buscar vagas no Adzuna.")
    parser.add_argument("--query", type=str, required=True, help="Termo de busca para vagas.")
    parser.add_argument("--max_results", type=int, default=10, help="Número máximo de resultados.")
    parser.add_argument("--output_json", type=str, default="vagas.json", help="Arquivo de saída JSON.")
    parser.add_argument("--output_md", type=str, default="vagas.md", help="Arquivo de saída Markdown.")
    args = parser.parse_args()
    
    vagas = buscar_vagas_adzuna(args.query, args.max_results)
    salvar_resultados(vagas, args.output_json)
    gerar_resumo_markdown(vagas, args.output_md)
    print(f"✅ Vagas salvas em {args.output_json} e {args.output_md}")
