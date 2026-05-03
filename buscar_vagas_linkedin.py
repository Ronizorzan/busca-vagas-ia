#!/usr/bin/env python3
"""
Script para buscar vagas no LinkedIn usando scraping público.
Salva os resultados em um arquivo JSON e retorna um resumo em Markdown.
"""

import requests
from bs4 import BeautifulSoup
import json
import argparse
from datetime import datetime


def buscar_vagas_linkedin(query, max_results=10):
    """Busca vagas no LinkedIn usando scraping público."""
    url = "https://www.linkedin.com/jobs/search/"
    params = {
        "keywords": query,
        "location": "Worldwide",
        "f_TPR": "r86400",  # Publicadas nas últimas 24h
        "f_JT": "R",       # Remotas
        "sortBy": "DD",   # Mais recentes
        "start": 0,
    }
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
    
    try:
        response = requests.get(url, params=params, headers=headers, timeout=10)
        response.raise_for_status()
    except requests.RequestException as e:
        print(f"⚠️ Erro ao buscar vagas no LinkedIn: {e}")
        return []
    
    soup = BeautifulSoup(response.text, 'html.parser')
    vagas = []
    
    # Extrair vagas da página (estrutura pode mudar com o tempo)
    for vaga in soup.select("li.jobs-search-results__list-item")[:max_results]:
        titulo = vaga.select_one("h3.base-search-card__title")
        empresa = vaga.select_one("h4.base-search-card__subtitle")
        local = vaga.select_one("span.job-search-card__location")
        url_vaga = vaga.select_one("a.base-card__full-link")
        
        if titulo and empresa and url_vaga:
            vagas.append({
                "titulo": titulo.get_text(strip=True),
                "empresa": empresa.get_text(strip=True),
                "local": local.get_text(strip=True) if local else "Remoto",
                "url": url_vaga.get("href"),
                "data_publicacao": datetime.now().strftime("%Y-%m-%d"),
            })
    
    return vagas


def salvar_resultados(vagas, arquivo_saida):
    """Salva os resultados em um arquivo JSON."""
    with open(arquivo_saida, "w", encoding="utf-8") as f:
        json.dump(vagas, f, ensure_ascii=False, indent=2)


def gerar_resumo_markdown(vagas, arquivo_markdown):
    """Gera um resumo das vagas em Markdown."""
    with open(arquivo_markdown, "w", encoding="utf-8") as f:
        f.write(f"# 🔗 Vagas no LinkedIn - {datetime.now().strftime('%d/%m/%Y %H:%M')}\n\n")
        for vaga in vagas:
            f.write(f"## {vaga['titulo']}\n")
            f.write(f"- **Empresa:** {vaga['empresa']}\n")
            f.write(f"- **Local:** {vaga['local']}\n")
            f.write(f"- **Data de Publicação:** {vaga['data_publicacao']}\n")
            f.write(f"- [Ver Vaga]({vaga['url']})\n\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Buscar vagas no LinkedIn.")
    parser.add_argument("--query", type=str, required=True, help="Termo de busca para vagas.")
    parser.add_argument("--max_results", type=int, default=10, help="Número máximo de resultados.")
    parser.add_argument("--output_json", type=str, default="vagas_linkedin.json", help="Arquivo de saída JSON.")
    parser.add_argument("--output_md", type=str, default="vagas_linkedin.md", help="Arquivo de saída Markdown.")
    args = parser.parse_args()
    
    vagas = buscar_vagas_linkedin(args.query, args.max_results)
    salvar_resultados(vagas, args.output_json)
    gerar_resumo_markdown(vagas, args.output_md)
    print(f"✅ Vagas salvas em {args.output_json} e {args.output_md}")