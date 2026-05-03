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
    "Remote Data Scientist"
    "Remote Machine Learning Engineer"
    "Remote AI Engineer"
    "Remote Data Analyst"
    "Remote Junior Data Scientist"
    "Remote ML Engineer Junior"
    "Remote Junior Data Analyst"
    "Data Scientist Internship Remote"
)

# Arquivos de saída
OUTPUT_JSON="vagas_remotas.json"
OUTPUT_MD="vagas_remotas.md"

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
    
    # Executa o script Python para o termo atual
    python3 "$DIR/buscar_vagas.py" --query "$termo" --max_results 10 --output_json "temp_$termo.json" --output_md "temp_$termo.md"
    
    # Verifica se o arquivo JSON temporário foi criado e não está vazio
    if [ -f "temp_$termo.json" ] && [ -s "temp_$termo.json" ]; then
        # Adiciona os resultados ao JSON final
        jq -s '.[0] + .[1]' "$OUTPUT_JSON" "temp_$termo.json" > "temp_combined.json" && mv "temp_combined.json" "$OUTPUT_JSON"
        
        # Adiciona os resultados ao Markdown final
        cat "temp_$termo.md" | tail -n +3 >> "$OUTPUT_MD"
    fi
    
    # Remove arquivos temporários
    rm -f "temp_$termo.json" "temp_$termo.md"
done

# Verifica se o arquivo JSON final está vazio
if [ ! -s "$OUTPUT_JSON" ]; then
    echo "{}" > "$OUTPUT_JSON"
    echo "### Nenhuma vaga encontrada para os termos de busca." >> "$OUTPUT_MD"
fi

echo "✅ Busca concluída. Resultados salvos em $OUTPUT_JSON e $OUTPUT_MD"