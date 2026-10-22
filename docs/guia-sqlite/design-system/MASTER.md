# Design System — SQLite: Fundamentos e Manual

> **Lógica:** este arquivo é a fonte única de verdade visual do projeto.
> Se existir `design-system/pages/<pagina>.md`, as regras dele substituem as deste arquivo para aquela página.
> Caso contrário, siga estritamente as regras abaixo.

---

**Projeto:** SQLite: Fundamentos e Manual
**Gerado com:** skill `ui-ux-pro-max` (`search.py --design-system`), consulta *"developer documentation reference manual technical education content-first"*
**Categoria indicada pela skill:** API Developer Portal / Knowledge Base-Documentation
**Padrão de página da skill:** FAQ/Documentation Landing (busca em destaque, categorias, seções expansíveis)
**Dials:** Variance 3/10 (centrado, mínimo) · Motion 2/10 (sutil) · Density 6/10 (padrão)
**Âncora visual:** imagem de referência (logotipo SQLite): quadrado de cantos arredondados em degradê de azul-céu para azul, pena e letreiro serifado em azul-marinho sobre fundo branco.

---

## 1. Análise da imagem de referência

| Aspecto | Observação | Decisão no sistema |
|---|---|---|
| Paleta | Azul-marinho profundo no letreiro e na pena (`#003B57`); quadrado com degradê de azul-céu (`#97D9F6`) para azul médio (`#0F80CC`); fundo branco | Marinho vira a cor de tinta (títulos, navegação ativa); o degradê vira assinatura de marca; branco domina |
| Tipografia | Serifa clássica, de contraste moderado, com ar editorial | Títulos em serifa; corpo em sans legível; código em mono |
| Densidade | Muito respiro, poucos elementos | Densidade padrão (6/10), com margens generosas entre seções |
| Formas | Quadrado com cantos arredondados (~12% do lado), curva orgânica da pena | Raios de 6–16 px; cartões e blocos arredondados; nada de cantos vivos |
| Tom | Sóbrio, técnico, confiável, clássico | Sem cores quentes dominantes; acentos frios; ênfase em legibilidade |

**Ajuste sobre a saída da skill:** a skill sugeriu paleta neutra cinza + azul de link (`#475569` / `#2563EB`) e títulos em JetBrains Mono. A imagem de referência pede um azul-marinho e um azul-céu próprios e títulos serifados; por isso a paleta foi substituída pelos tons da imagem e os títulos usam a dupla serifada "News Editorial" da própria base da skill (Newsreader). O corpo (IBM Plex Sans) e o código (JetBrains Mono) seguem a recomendação original.

---

## 2. Cores

Todos os pares de texto foram verificados contra WCAG 2.1 (mínimo AA = 4,5:1 para texto normal, 3:1 para componentes de interface).

### 2.1 Superfícies e texto

| Papel | Hex | Variável CSS | Contraste / uso |
|---|---|---|---|
| Tinta (primária) | `#003B57` | `--color-ink` | 11,9:1 no branco. Títulos, item ativo da navegação, botão primário |
| Marca | `#0F80CC` | `--color-brand` | 4,2:1 no branco: **só** em bordas, ícones, anéis de foco e decoração (≥3:1), nunca em texto corrido |
| Link / ação | `#0A6AAD` | `--color-link` | 5,7:1 no branco, 5,4:1 na superfície. Links, botões secundários, chips ativos |
| Céu | `#97D9F6` | `--color-sky` | Degradês, sublinhado de marcadores no código. Nunca como fundo de texto escuro pequeno sem verificação |
| Céu claro | `#E8F5FC` | `--color-sky-tint` | Fundo do item ativo da navegação e de chips selecionados (tinta sobre ele: 10,7:1) |
| Fundo | `#FFFFFF` | `--color-bg` | Fundo da página |
| Superfície | `#F5F9FC` | `--color-surface` | Barra lateral, cartões de conceito |
| Borda | `#D5E3EC` | `--color-border` | Divisórias, contorno de cartões e campos |
| Texto | `#16313F` | `--color-text` | 13,6:1. Corpo de texto |
| Texto suave | `#4A6372` | `--color-text-muted` | 6,3:1 no branco, 6,0:1 na superfície. Legendas, descrições, selos |
| Sobre primária | `#FFFFFF` | `--color-on-ink` | Texto sobre `--color-ink` e `--color-link` |
| Sucesso | `#1F7A4D` | `--color-success` | 5,3:1. Confirmação "Copiado" |

### 2.2 Notas e selos

| Papel | Hex | Variável CSS | Uso |
|---|---|---|---|
| Nota de divergência — fundo | `#FFF7E6` | `--color-note-bg` | Caixa lateral "Divergência com a documentação oficial" |
| Nota de divergência — borda | `#C58A1B` | `--color-note-border` | Filete esquerdo de 3 px |
| Nota de divergência — texto | `#5A3B00` | `--color-note-text` | 9,6:1 sobre o fundo da nota |
| Selo de complemento | `--color-text-muted` sobre `--color-bg`, borda `--color-border` | — | Selo discreto "complemento da documentação oficial" |

### 2.3 Blocos de código (tema escuro marinho)

| Token | Hex | Variável CSS | Contraste sobre `--code-bg` |
|---|---|---|---|
| Fundo do bloco | `#052638` | `--code-bg` | — |
| Cabeçalho do bloco | `#0A3349` | `--code-header-bg` | — |
| Texto base | `#E3F1F8` | `--code-fg` | 13,6:1 |
| Rótulo do cabeçalho | `#B5CCD8` | `--code-label` | 8,0:1 sobre o cabeçalho |
| Palavra-chave SQL | `#7FCDF5` | `--syn-keyword` | 8,9:1 (negrito 600) |
| Função | `#B8E4FA` | `--syn-function` | 11,6:1 |
| Texto entre aspas simples | `#9FE3C8` | `--syn-string` | 10,7:1 |
| Número | `#F7C97E` | `--syn-number` | 10,2:1 |
| Comentário | `#8FAFC0` | `--syn-comment` | 6,8:1 (itálico) |
| Comando de ponto / terminal | `#FFD27A` | `--syn-command` | 11,0:1 |
| Marcador a substituir | `#FFFFFF` sobre `rgba(151,217,246,.16)` | `--syn-placeholder` / `--syn-placeholder-bg` | ≥12:1; sublinhado tracejado `--color-sky` |

**Degradê de marca** (do quadrado do logotipo): `--gradient-brand: linear-gradient(180deg, #97D9F6 0%, #0F80CC 100%)`. Uso restrito à marca no cabeçalho, ao filete do topo e aos marcadores das partes na navegação.

---

## 3. Tipografia

| Papel | Fonte web | Pilha com fontes do sistema (alternativa obrigatória) | Variável |
|---|---|---|---|
| Títulos | Newsreader 500–700 | `"Newsreader", "Iowan Old Style", "Palatino Linotype", Palatino, "Book Antiqua", Georgia, serif` | `--font-heading` |
| Corpo e interface | IBM Plex Sans 400–600 | `"IBM Plex Sans", system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif` | `--font-body` |
| Código | JetBrains Mono 400–600 | `"JetBrains Mono", ui-monospace, "SF Mono", Menlo, Consolas, "Liberation Mono", monospace` | `--font-mono` |

As fontes web aparecem primeiro em cada pilha e são usadas quando estão instaladas no sistema do leitor. A página **não** as baixa de servidores externos: ela precisa abrir direto do disco, sem rede e sem erros no console. Na ausência delas, as fontes do sistema listadas assumem sem quebra de layout. (Se um dia a página for publicada on-line, o link do Google Fonts com `display=swap` pode ser acrescentado sem mudar nenhum outro token.)

### Escala

| Token | Valor | Uso |
|---|---|---|
| `--text-xs` | 0.8125rem (13 px) | Selos, rótulos de bloco de código |
| `--text-sm` | 0.875rem (14 px) | Navegação lateral, legendas, notas |
| `--text-base` | 1rem (16 px) | Corpo (mínimo absoluto para texto corrido) |
| `--text-code` | 0.875rem (14 px) | Código |
| `--text-lg` | 1.125rem (18 px) | Introdução de seção |
| `--text-xl` | 1.375rem (22 px) | Título de entrada (h3) |
| `--text-2xl` | 1.75rem (28 px) | Título de seção (h2) |
| `--text-3xl` | clamp(2.25rem, 5vw, 3.25rem) | Título de parte (h1 de parte / herói) |

- Altura de linha: 1.6 no corpo, 1.25 nos títulos, 1.55 no código.
- Comprimento de linha do texto corrido: máximo de 72 caracteres (`max-width: 72ch`).
- Títulos de parte usam peso 600 e `letter-spacing: -0.01em` (versão contida do "Exaggerated Minimalism" sugerido pela skill: tamanho grande só no herói; nada de peso 900 ou tipos gigantes no conteúdo).

---

## 4. Espaçamento, raios e sombras

### Espaçamento (densidade 6/10, saída da skill)

| Token | Valor | Uso |
|---|---|---|
| `--space-xs` | 4px | Folgas mínimas |
| `--space-sm` | 8px | Espaço entre ícone e texto, chips |
| `--space-md` | 16px | Preenchimento padrão, margem lateral no celular |
| `--space-lg` | 24px | Preenchimento de cartões |
| `--space-xl` | 32px | Espaço entre entradas |
| `--space-2xl` | 48px | Espaço entre seções |
| `--space-3xl` | 64px | Espaço entre as duas partes e no herói |

### Raios (derivados do quadrado arredondado do logotipo)

| Token | Valor | Uso |
|---|---|---|
| `--radius-sm` | 6px | Chips internos, marcadores no código, botões pequenos |
| `--radius-md` | 10px | Blocos de código, campos, botões |
| `--radius-lg` | 16px | Cartões de entrada, herói |
| `--radius-pill` | 999px | Chips de filtro, selos |

### Sombras (tingidas de marinho)

| Token | Valor | Uso |
|---|---|---|
| `--shadow-sm` | `0 1px 2px rgba(0,59,87,.06)` | Cartões em repouso |
| `--shadow-md` | `0 4px 12px rgba(0,59,87,.08)` | Cabeçalho fixo, gaveta de navegação |
| `--shadow-lg` | `0 12px 28px rgba(0,59,87,.14)` | Gaveta no celular |

---

## 5. Layout

- **Estrutura:** cabeçalho fixo (marca, busca, alternância "Fundamentos | Manual") + barra lateral fixa à esquerda (≥ 1024 px) + coluna de conteúdo com `max-width: 820px`.
- **Breakpoints:** 375 px (base, *mobile-first*), 768 px, 1024 px (barra lateral fixa aparece), 1440 px.
- **Celular:** barra lateral vira gaveta aberta por botão "Menu" (rótulo visível + `aria-expanded`); margem lateral de 16 px; nenhuma rolagem horizontal da página (blocos de código rolam internamente).
- **Âncoras:** `scroll-margin-top` igual à altura do cabeçalho fixo, para nada ficar escondido sob ele.

---

## 6. Componentes

### 6.1 Bloco de código (copiável)

```css
.code-block { background: var(--code-bg); border-radius: var(--radius-md); overflow: hidden; }
.code-head  { background: var(--code-header-bg); color: var(--code-label);
              font: 500 var(--text-xs)/1 var(--font-body); padding: 8px 8px 8px 16px;
              display: flex; justify-content: space-between; align-items: center; }
.code-block pre { margin: 0; padding: 16px; overflow-x: auto;
                  font: var(--text-code)/1.55 var(--font-mono); color: var(--code-fg); }
.ph { color: var(--syn-placeholder); background: var(--syn-placeholder-bg);
      border-bottom: 1px dashed var(--color-sky); border-radius: 3px; padding: 0 2px; font-style: italic; }
```

- Um bloco = um comando ou uma sequência curta e coesa. Variações da mesma sintaxe ficam em blocos separados.
- O rótulo do cabeçalho diz onde digitar: **Terminal**, **sqlite3 · comando de ponto**, **SQL** ou **Sintaxe**.
- Nunca exibir prompt (`sqlite>`, `$`), numeração de linhas nem saída dentro do bloco. A saída esperada vai em parágrafo "Resultado esperado" abaixo.
- Marcadores a substituir aparecem com a classe `.ph` (sublinhado tracejado céu + fundo translúcido + itálico).

### 6.2 Botão "Copiar"

```css
.copy-btn { min-height: 32px; min-width: 88px; padding: 4px 12px; border-radius: var(--radius-sm);
            border: 1px solid rgba(151,217,246,.35); background: transparent; color: var(--code-fg);
            font: 600 var(--text-xs)/1 var(--font-body); cursor: pointer; transition: background 150ms ease; }
.copy-btn:hover { background: rgba(151,217,246,.14); }
.copy-btn:focus-visible { outline: 2px solid var(--color-sky); outline-offset: 2px; }
.copy-btn.is-copied { background: var(--color-success); border-color: var(--color-success); color: #fff; }
```

- Copia exatamente o texto do comando (sem prompt, sem numeração, sem saída).
- Confirmação: o rótulo muda para "Copiado" com ícone de check por 1,6 s e é anunciado por região `aria-live="polite"`.
- Área de toque: 44 px de altura efetiva no celular (`min-height: 44px` abaixo de 768 px).

### 6.3 Campo de busca

```css
.search { height: 44px; padding: 0 12px 0 40px; border: 1px solid var(--color-border);
          border-radius: var(--radius-md); font: var(--text-base) var(--font-body);
          background: var(--color-bg); color: var(--color-text); transition: border-color 150ms ease, box-shadow 150ms ease; }
.search:focus { border-color: var(--color-link); box-shadow: 0 0 0 3px rgba(15,128,204,.25); outline: none; }
```

- Rótulo acessível ("Buscar conceitos e comandos"), atalho de teclado `/` para focar e `Esc` para limpar.
- Filtragem instantânea; contador de resultados anunciado em `aria-live`; estado vazio com sugestões clicáveis (nunca só "0 resultados").

### 6.4 Chips de filtro por categoria

```css
.chip { min-height: 36px; padding: 6px 14px; border-radius: var(--radius-pill);
        border: 1px solid var(--color-border); background: var(--color-bg); color: var(--color-text);
        font: 500 var(--text-sm) var(--font-body); cursor: pointer; transition: background 150ms ease, border-color 150ms ease; }
.chip[aria-pressed="true"] { background: var(--color-link); border-color: var(--color-link); color: var(--color-on-ink); }
```

### 6.5 Navegação lateral

- Itens com `font-size: var(--text-sm)`, padding 6px 12px, raio `--radius-sm`.
- Item da seção atual: fundo `--color-sky-tint`, texto `--color-ink`, filete esquerdo de 3 px `--color-brand`, `aria-current="true"`.
- Cabeçalho de cada parte com pequeno quadrado em `--gradient-brand` (eco do logotipo).

### 6.6 Cartão de entrada (conceito ou comando)

```css
.entry { background: var(--color-bg); border: 1px solid var(--color-border);
         border-radius: var(--radius-lg); padding: var(--space-lg); box-shadow: var(--shadow-sm); }
```

- Comando: título em mono (`--font-mono`, cor `--color-ink`), selo de categoria, rótulos "Sintaxe", "Finalidade", "Exemplo", "Resultado esperado".
- Sem efeito de elevação no *hover* (cartões não são clicáveis).

### 6.7 Selo "complemento da documentação oficial"

```css
.badge-doc { display: inline-flex; gap: 4px; align-items: center; padding: 2px 8px;
             border: 1px solid var(--color-border); border-radius: var(--radius-pill);
             font: 500 var(--text-xs)/1.4 var(--font-body); color: var(--color-text-muted); }
```

- Aparece junto ao título do item (ou do parágrafo) que não vem do material do curso e leva link para a página correspondente em sqlite.org.

### 6.8 Nota de divergência

```css
.note-diverge { background: var(--color-note-bg); border-left: 3px solid var(--color-note-border);
                color: var(--color-note-text); border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
                padding: 12px 16px; font-size: var(--text-sm); }
```

- Fica ao lado (desktop ≥ 1280 px, em coluna flutuante) ou logo abaixo (telas menores) do trecho do curso que diverge da documentação oficial.

### 6.9 Seção expansível

- `<details>`/`<summary>` nativos; resumo com seta SVG que gira 90° em 150 ms; foco visível; usado em exemplos longos (mais de ~8 linhas).

---

## 7. Movimento

- Transições de 150–250 ms, `ease` / `ease-out`; só cor, opacidade e `transform` (nunca largura/altura).
- A skill sugeriu *scroll reveal* com GSAP; **substituído** por nenhum efeito de revelação: a página precisa abrir sem bibliotecas externas e o conteúdo de referência deve estar sempre visível.
- `@media (prefers-reduced-motion: reduce)`: desliga todas as transições e a rolagem suave.

---

## 8. Ícones

- SVG inline com traço de 2 px no estilo Lucide (busca, copiar, check, menu, seta, link externo). Nada de emoji como ícone.
- Ícones decorativos com `aria-hidden="true"`; botões só com ícone sempre com `aria-label`.

---

## 9. Acessibilidade (obrigatório)

- Contraste AA em todos os textos (ver tabelas acima).
- Foco visível em tudo que é interativo: `outline: 2px solid var(--color-brand); outline-offset: 2px`.
- Link "Pular para o conteúdo" como primeiro elemento focável.
- Navegação por teclado completa: `Tab` por todos os controles; `/` foca a busca; `Esc` limpa a busca e fecha a gaveta.
- `cursor: pointer` em todo elemento clicável.
- `lang="pt-BR"` e marcos semânticos (`header`, `nav`, `main`).

---

## 10. Antipadrões (não usar)

- ❌ Emoji como ícone
- ❌ Cor de marca `#0F80CC` em texto pequeno (falha AA)
- ❌ Cores quentes como cor de destaque principal (fogem do tom da referência), exceto a nota de divergência
- ❌ Prompt, numeração ou saída dentro do texto copiável
- ❌ Animações de revelação que escondem conteúdo
- ❌ Estados sem transição ou *hover* que desloca o layout
- ❌ Rolagem horizontal da página no celular

---

## 11. Checklist antes da entrega

- [ ] Sem emoji como ícone; ícones SVG consistentes
- [ ] `cursor: pointer` em clicáveis; transições de 150–250 ms
- [ ] Contraste de texto ≥ 4,5:1
- [ ] Foco visível e navegação completa por teclado
- [ ] `prefers-reduced-motion` respeitado
- [ ] Responsivo em 375, 768, 1024 e 1440 px; sem rolagem horizontal
- [ ] Conteúdo não fica escondido sob o cabeçalho fixo
- [ ] Todo bloco de código com botão "Copiar" funcional
