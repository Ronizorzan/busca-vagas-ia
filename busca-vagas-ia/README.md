# 🚀 Busca-Vagas-IA: Automação de Busca de Vagas em Ciência de Dados, IA e Machine Learning

![GitHub Actions](https://github.com/Ronizorzan/busca-vagas-ia/actions/workflows/job_search.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Python](https://img.shields.io/badge/python-3.11+-blue.svg)

## 📌 Descrição
Este projeto automatiza a **busca diária de vagas** nas áreas de **Ciência de Dados, Inteligência Artificial (IA) e Machine Learning**, combinando resultados de múltiplas fontes (Adzuna, LinkedIn, Indeed) e entregando um resumo estruturado em **Markdown e JSON**.

Ideal para:
- **Profissionais** que buscam oportunidades no mercado de IA/ML.
- **Estudantes** que querem acompanhar vagas de estágio e nível júnior.
- **Recrutadores** que desejam monitorar tendências do mercado.

> **⚠️ Nota:** Este projeto foi **estruturado e otimizado** com o auxílio da **OpenClaw AI**, uma assistente de automação e produtividade. O código e a documentação foram criados para garantir eficiência, escalabilidade e facilidade de uso.

## 🛠️ Tecnologias
- **Python 3.11+** (scripts de busca e automação).
- **GitHub Actions** (execução diária automatizada).
- **APIs e Scraping** (Adzuna, LinkedIn, Indeed).
- **Bash** (wrapper para combinar resultados).
- **Markdown/JSON** (formato de saída dos resultados).

## 📥 Instalação
1. Clone o repositório:
   ```bash
   git clone https://github.com/Ronizorzan/busca-vagas-ia.git
   cd busca-vagas-ia
   ```

2. Instale as dependências:
   ```bash
   pip install -r requirements.txt
   ```

3. Configure as credenciais da API do Adzuna no arquivo `.env`:
   ```env
   ADZUNA_APP_ID="sua_app_id"
   ADZUNA_APP_KEY="sua_app_key"
   ```

## ▶️ Como Usar
### Execução Local
Execute o wrapper para buscar vagas:
```bash
chmod +x buscar_vagas_wrapper.sh
./buscar_vagas_wrapper.sh
```

Os resultados serão salvos em:
- `vagas_combinadas.md` (formato Markdown).
- `vagas_combinadas.json` (formato JSON).

### Execução Automatizada (GitHub Actions)
O workflow `.github/workflows/job_search.yml` executa a busca **diariamente às 09:00 UTC** e atualiza os arquivos no repositório.

## 📊 Exemplo de Saída
### `vagas_combinadas.md`
```markdown
# 🌍 Vagas Remotas Internacionais

Atualizado em: 10/05/2026 09:00 UTC

---

## Cientista de Dados (Pleno)
- **Empresa:** TechCorp
- **Local:** Remoto
- **Salário:** R$ 15.000 - R$ 18.000
- **Link:** [Ver Vaga](https://www.linkedin.com/jobs/view/123456789)
```

### `vagas_combinadas.json`
```json
[
  {
    "titulo": "Cientista de Dados (Pleno)",
    "empresa": "TechCorp",
    "local": "Remoto",
    "salario": "R$ 15.000 - R$ 18.000",
    "url": "https://www.linkedin.com/jobs/view/123456789"
  }
]
```

## 🔍 Termos de Busca
O script busca vagas para os seguintes termos:
- **Cientista de Dados** (Júnior, Pleno, Sênior).
- **Engenheiro de Machine Learning** (Júnior, Pleno, Sênior).
- **Engenheiro de IA** (Pleno, Sênior).
- **Analista de Dados** (Júnior, Pleno).
- **Estágio em Ciência de Dados / Machine Learning / IA**.

## 🤝 Contribuição
Contribuições são bem-vindas! Siga os passos:
1. Faça um **fork** do projeto.
2. Crie uma **branch** para sua feature (`git checkout -b feature/nova-feature`).
3. Faça **commit** das suas alterações (`git commit -m 'Adiciona nova feature'`).
4. Faça **push** para a branch (`git push origin feature/nova-feature`).
5. Abra um **Pull Request**.

## 📜 Licença
Este projeto está licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🤖 Créditos
Este projeto foi **estruturado e otimizado** com o auxílio da **[OpenClaw AI](https://github.com/openclaw/openclaw)**, uma assistente de automação e produtividade focada em **ciência de dados e IA**.