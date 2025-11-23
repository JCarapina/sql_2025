# Análise de Dados - Sistema de Fidelidade (Loyalty System) - SQL

## Sobre o Projeto
Este repositório contém scripts SQL e análises desenvolvidas para explorar o comportamento de clientes em um sistema de pontuação e fidelidade. O objetivo é simular cenários reais de análise de dados, extraindo insights sobre retenção, vendas e possíveis fraudes.

O projeto utiliza o dataset público **"Teo Me Why - Loyalty System"**.

## Objetivos
* Realizar limpeza e padronização de dados brutos.
* Criar análises de comportamento de compra (RFM - Recência, Frequência, Valor).
* Identificar padrões suspeitos ou anomalias nas transações.
* Gerar KPIs para acompanhamento de performance do programa de fidelidade.

## 📋 Funcionalidades e Métricas (Feature Engineering)
O projeto foca na construção de uma **ABT (Analytical Base Table)**, calculando métricas de comportamento do usuário em diferentes janelas de tempo (Histórico completo, 7, 14, 28 e 56 dias).

As principais variáveis desenvolvidas incluem:

* **Comportamento Transacional:**
    * Quantidade de transações (Visão Vida e janelas deslizantes).
    * Saldo atual de pontos e histórico de acúmulo (pontos ganhos) vs. resgate (pontos gastos).
    * Engajamento recente (D28) versus histórico (Vida).
* **Recência e Tempo:**
    * Dias desde a última transação (Recência).
    * Idade do cliente na base (Tempo de vida/Tenure).
* **Preferências e Hábitos:**
    * Produto favorito (Moda estatística) por janela de tempo.
    * Dia da semana e período do dia com maior atividade (D28).
      
## Fonte dos Dados
**Nota Importante:** Os arquivos de dados (`.csv`) **não** estão incluídos neste repositório por questões de boas práticas e tamanho de arquivos.

Para reproduzir este projeto:
1.  Acesse o dataset no Kaggle: [Teo Me Why - Loyalty System](https://www.kaggle.com/datasets/teocalvo/teomewhy-loyalty-system)
2.  Faça o download dos arquivos.
3.  Coloque os arquivos descompactados na raiz deste projeto ou em uma pasta `/data` (certifique-se de que o `.gitignore` está configurado).

## Tecnologias Utilizadas
* **Linguagem:** SQL (SQLite)
* **Versionamento:** Git & GitHub
* **IDE:** VS Code

## Como Executar
1.  Clone este repositório:
    ```bash
    git clone https://github.com/JCarapina/sql_2025.git
    ```
2.  Baixe os dados conforme instruído na seção "Fonte dos Dados".
3.  Execute os scripts na ordem numérica (ex: `01_criacao_tabelas.sql`, `02_carga_dados.sql`...).
