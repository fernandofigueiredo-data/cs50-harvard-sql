"""Mede as 7 consultas de your.harvard antes e depois dos índices e gera o gráfico.

Uso:
    python3 scripts/grafico_harvard.py            # mede e gera CSV + SVGs
    python3 scripts/grafico_harvard.py --so-svg   # só redesenha a partir do CSV

Saídas em docs/:
    harvard_benchmark.csv         medianas em milissegundos
    harvard_benchmark.svg         gráfico (tema claro)
    harvard_benchmark-dark.svg    gráfico (tema escuro)

Requer apenas a biblioteca padrão do Python e o banco baixado por baixar_dados.sh.
"""

import csv
import math
import sqlite3
import statistics
import sys
import time
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
PASTA = RAIZ / "06-otimizacao" / "harvard"
DOCS = RAIZ / "docs"
CSV = DOCS / "harvard_benchmark.csv"
REPETICOES = 5

ROTULOS = [
    "Disciplinas de um aluno",
    "Alunos de CS50 no Fall 2023",
    "Matrículas por disciplina",
    "Disciplinas de CS no Spring 2024",
    "Requisito de uma disciplina",
    "Disciplinas por requisito",
    "Busca por prefixo de título",
]

TEMAS = {
    "claro": {
        "surface": "#fcfcfb", "primary": "#0b0b0b", "secondary": "#52514e",
        "muted": "#898781", "grid": "#e1e0d9", "connector": "#c3c2b7",
        "antes": "#86b6ef", "depois": "#1c5cab",
    },
    "escuro": {
        "surface": "#1a1a19", "primary": "#f0efec", "secondary": "#c3c2b7",
        "muted": "#898781", "grid": "#2c2c2a", "connector": "#383835",
        "antes": "#256abf", "depois": "#9ec5f4",
    },
}


def consultas():
    texto = (PASTA / "consultas.sql").read_text()
    return [q.strip() for q in texto.split(";") if "SELECT" in q]


def medir(com_indices):
    origem = sqlite3.connect(f"file:{PASTA / 'harvard.db'}?mode=ro", uri=True)
    banco = sqlite3.connect(":memory:")
    origem.backup(banco)
    origem.close()
    if com_indices:
        banco.executescript((PASTA / "indexes.sql").read_text())
    tempos = []
    for q in consultas():
        amostras = []
        for _ in range(REPETICOES):
            inicio = time.perf_counter()
            banco.execute(q).fetchall()
            amostras.append(time.perf_counter() - inicio)
        tempos.append(statistics.median(amostras) * 1000)
    return tempos


def gravar_csv(antes, depois):
    DOCS.mkdir(exist_ok=True)
    with CSV.open("w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["consulta", "descricao", "antes_ms", "depois_ms"])
        for i, (a, d) in enumerate(zip(antes, depois), 1):
            w.writerow([f"Q{i}", ROTULOS[i - 1], f"{a:.6f}", f"{d:.6f}"])


def ler_csv():
    with CSV.open() as f:
        linhas = list(csv.DictReader(f))
    return [float(l["antes_ms"]) for l in linhas], [float(l["depois_ms"]) for l in linhas]


def ganho(a, d):
    r = a / d
    if r < 1.5:
        return "sem ganho"
    if r >= 100:
        r = round(r, -1)
    return f"{r:,.0f}× mais rápida".replace(",", ".")


def svg(antes, depois, t):
    largura, esq, dir_ = 760, 250, 600
    topo, linha = 112, 38
    altura = topo + linha * len(antes) + 56
    lo, hi = -3, 3  # 1 µs a 1 s, em escala log10 de milissegundos

    maior = int(round(max(a / d for a, d in zip(antes, depois)), -1))

    def x(ms):
        return esq + (math.log10(ms) - lo) / (hi - lo) * (dir_ - esq)

    p = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{largura}" height="{altura}" '
        f'viewBox="0 0 {largura} {altura}" font-family="system-ui, -apple-system, '
        f"'Segoe UI', sans-serif\" role=\"img\" aria-labelledby=\"t d\">",
        '<title id="t">your.harvard: tempo das 7 consultas antes e depois dos índices</title>',
        '<desc id="d">' + "; ".join(
            f"Q{i}: {a:.2f} ms antes, {d:.3f} ms depois" for i, (a, d) in enumerate(zip(antes, depois), 1)
        ) + "</desc>",
        f'<rect width="{largura}" height="{altura}" rx="8" fill="{t["surface"]}"/>',
        f'<text x="24" y="36" font-size="17" font-weight="600" fill="{t["primary"]}">'
        f"Índices no your.harvard: até {maior:,}× mais rápido".replace(",", ".") + "</text>",
        f'<text x="24" y="58" font-size="13" fill="{t["secondary"]}">'
        "Mediana de 5 execuções por consulta · 1,6 milhão de matrículas · escala logarítmica</text>",
    ]

    # legenda
    for i, (nome, cor) in enumerate([("Sem índices", t["antes"]), ("Com indexes.sql", t["depois"])]):
        lx = 24 + i * 150
        p.append(f'<circle cx="{lx + 5}" cy="84" r="5" fill="{cor}"/>')
        p.append(f'<text x="{lx + 16}" y="88.5" font-size="12.5" fill="{t["secondary"]}">{nome}</text>')

    # grade e eixo
    base = topo + linha * len(antes) - 12
    ticks = {-3: "1 µs", -2: "10 µs", -1: "0,1 ms", 0: "1 ms", 1: "10 ms", 2: "100 ms", 3: "1 s"}
    for e, rotulo in ticks.items():
        gx = esq + (e - lo) / (hi - lo) * (dir_ - esq)
        p.append(f'<line x1="{gx:.1f}" y1="{topo - 16}" x2="{gx:.1f}" y2="{base}" '
                 f'stroke="{t["grid"]}" stroke-width="1"/>')
        p.append(f'<text x="{gx:.1f}" y="{base + 18}" font-size="11.5" fill="{t["muted"]}" '
                 f'text-anchor="middle">{rotulo}</text>')
    p.append(f'<text x="{(esq + dir_) / 2}" y="{base + 38}" font-size="11.5" fill="{t["muted"]}" '
             'text-anchor="middle">tempo por consulta</text>')

    # halteres
    for i, (a, d) in enumerate(zip(antes, depois)):
        y = topo + i * linha + 8
        p.append(f'<text x="24" y="{y + 4.5}" font-size="13" fill="{t["primary"]}">'
                 f'<tspan font-weight="600">Q{i + 1}</tspan>  {ROTULOS[i]}</text>')
        xa, xd = x(a), x(d)
        p.append(f'<line x1="{xa:.1f}" y1="{y}" x2="{xd:.1f}" y2="{y}" stroke="{t["connector"]}" '
                 'stroke-width="2" stroke-linecap="round"/>')
        for cx, cor in ((xa, t["antes"]), (xd, t["depois"])):
            p.append(f'<circle cx="{cx:.1f}" cy="{y}" r="5.5" fill="{cor}" '
                     f'stroke="{t["surface"]}" stroke-width="2"/>')
        g = ganho(a, d)
        cor = t["muted"] if g == "sem ganho" else t["primary"]
        peso = "400" if g == "sem ganho" else "600"
        p.append(f'<text x="{dir_ + 20}" y="{y + 4.5}" font-size="13" font-weight="{peso}" '
                 f'fill="{cor}">{g}</text>')

    p.append("</svg>")
    return "\n".join(p)


def main():
    if "--so-svg" in sys.argv:
        antes, depois = ler_csv()
    else:
        if not (PASTA / "harvard.db").exists():
            sys.exit("harvard.db não encontrado: rode ./scripts/baixar_dados.sh")
        gravar_csv(medir(False), medir(True))
        antes, depois = ler_csv()
    DOCS.mkdir(exist_ok=True)
    (DOCS / "harvard_benchmark.svg").write_text(svg(antes, depois, TEMAS["claro"]))
    (DOCS / "harvard_benchmark-dark.svg").write_text(svg(antes, depois, TEMAS["escuro"]))
    for i, (a, d) in enumerate(zip(antes, depois), 1):
        print(f"Q{i}: {a:9.3f} ms → {d:7.3f} ms  ({ganho(a, d)})")


if __name__ == "__main__":
    main()
