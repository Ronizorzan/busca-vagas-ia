#!/bin/bash

# Script wrapper para buscar vagas usando múltiplos termos de busca.
# Executa o buscar_vagas.py para cada termo e combina os resultados.

# Diretório de trabalho
DIR="$(dirname "$0")"

# Cria um ambiente virtual se não existir
VENV_DIR="$DIR/venv"
if [ ! -d "$VENV_DIR" ]; then
    echo "🔧 Criando ambiente virtual em $VENV_DIR"
    python3 -m venv "$VENV_DIR"
fi

# Ativa o ambiente virtual e instala dependências
source "$VENV_DIR/bin/activate"
if ! pip show python-dotenv > /dev/null 2>&1; then
    echo "🔧 Instalando dependências no ambiente virtual"
    pip install python-dotenv requests
fi

# Termos de busca (vagas remotas internacionais)
TERMOS=(
    "Data Scientist"
    "Machine Learning Engineer"
    "AI Engineer"
    "Data Analyst"
    "Junior Data Scientist"
    "ML Engineer Junior"
    "Junior Data Analyst"
    "Data Science Intern"
)

# Arquivos de saída combinados
OUTPUT_JSON="vagas_combinadas.json"
OUTPUT_MD="vagas_combinadas.md"

# Limpar arquivos antigos
> "$OUTPUT_JSON"
> "$OUTPUT_MD"

# Cabeçalho do Markdown
echo "# 🌍 Vagas Remotas Internacionais" > "$OUTPUT_MD"
echo "" >> "$OUTPUT_MD"
echo "Atualizado em: $(date '+%d/%m/%Y %H:%M')" >> "$OUTPUT_MD"
echo "" >> "$OUTPUT_MD"
echo "---" >> "$OUTPUT_MD"
echo "" >> "$OUTPUT_MD"

# Limpar arquivos antigos
> "$OUTPUT_JSON"
> "$OUTPUT_MD"

# Cabeçalho do Markdown
echo "# 🌍 Vagas Remotas Internacionais" > "$OUTPUT_MD"
echo "" >> "$OUTPUT_MD"
echo "Atualizado em: $(date '+%d/%m/%Y %H:%M')" >> "$OUTPUT_MD"
echo "" >> "$OUTPUT_MD"
echo "---" >> "$OUTPUT_MD"
echo "" >> "$OUTPUT_MD"

# Loop para cada termo
for termo in "${TERMOS[@]}"; do
    echo "🔍 Buscando vagas para: $termo"
    
    # Buscar no Adzuna (API)
    python3 "$DIR/buscar_vagas.py" --query "$termo" --max_results 10 --output_json "temp_adzuna_$termo.json" --output_md "temp_adzuna_$termo.md"
    
    # Buscar no LinkedIn (scraping)
    python3 "$DIR/buscar_vagas_linkedin.py" --query "$termo" --max_results 10 --output_json "temp_linkedin_$termo.json" --output_md "temp_linkedin_$termo.md"
    
    # Buscar no Indeed (scraping)
    python3 "$DIR/buscar_vagas_indeed.py" --query "$termo" --max_results 10 --output_json "temp_indeed_$termo.json" --output_md "temp_indeed_$termo.md"
    
    # Combinar resultados do Adzuna
    if [ -f "temp_adzuna_$termo.json" ] && [ -s "temp_adzuna_$termo.json" ]; then
        jq -s '.[0] + .[1]' "$OUTPUT_JSON" "temp_adzuna_$termo.json" > "temp_combined.json" && mv "temp_combined.json" "$OUTPUT_JSON"
        cat "temp_adzuna_$termo.md" | tail -n +3 >> "$OUTPUT_MD"
    fi
    
    # Combinar resultados do LinkedIn
    if [ -f "temp_linkedin_$termo.json" ] && [ -s "temp_linkedin_$termo.json" ]; then
        jq -s '.[0] + .[1]' "$OUTPUT_JSON" "temp_linkedin_$termo.json" > "temp_combined.json" && mv "temp_combined.json" "$OUTPUT_JSON"
        cat "temp_linkedin_$termo.md" | tail -n +2 >> "$OUTPUT_MD"
    fi
    
    # Combinar resultados do Indeed
    if [ -f "temp_indeed_$termo.json" ] && [ -s "temp_indeed_$termo.json" ]; then
        jq -s '.[0] + .[1]' "$OUTPUT_JSON" "temp_indeed_$termo.json" > "temp_combined.json" && mv "temp_combined.json" "$OUTPUT_JSON"
        cat "temp_indeed_$termo.md" | tail -n +2 >> "$OUTPUT_MD"
    fi
    
    # Remove arquivos temporários
    rm -f "temp_adzuna_$termo.json" "temp_adzuna_$termo.md"
    rm -f "temp_linkedin_$termo.json" "temp_linkedin_$termo.md"
    rm -f "temp_indeed_$termo.json" "temp_indeed_$termo.md"
done

# Verifica se o arquivo JSON final está vazio
if [ ! -s "$OUTPUT_JSON" ]; then
    echo "[]" > "$OUTPUT_JSON"
    echo "### Nenhuma vaga encontrada para os termos de busca." >> "$OUTPUT_MD"
fi

# Verifica se o arquivo JSON final está vazio
if [ ! -s "$OUTPUT_JSON" ]; then
    echo "{}" > "$OUTPUT_JSON"
    echo "### Nenhuma vaga encontrada para os termos de busca." >> "$OUTPUT_MD"
fi

echo "✅ Busca concluída. Resultados salvos em $OUTPUT_JSON e $OUTPUT_MD"