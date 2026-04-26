#figure(
  caption: [不同一体化方法在全色锐化任务上的对比结果，最优结果用 #strong[粗体]表示，次优结果用 #underline[下划线]表示],
  kind: table,
)[
  #set text(size: 9pt)
  #table(
    columns: (auto, auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    stroke: none,

    table.vline(x: 1, stroke: 0.5pt),
    table.vline(x: 2, stroke: 0.5pt),
    table.vline(x: 5, stroke: 0.5pt),
    table.vline(x: 8, stroke: 0.5pt),

    table.hline(stroke: 1.2pt),
    table.header(
      table.cell(rowspan: 2)[*Method*],
      table.cell(rowspan: 2)[*Parameters*],
      table.cell(colspan: 3)[*WV4*],
      table.cell(colspan: 3)[*QB*],
      table.cell(colspan: 3)[*GF1*],
      [PSNR↑], [SAM↓], [ERGAS↓],
      [PSNR↑], [SAM↓], [ERGAS↓],
      [PSNR↑], [SAM↓], [ERGAS↓],
    ),
    table.hline(stroke: 0.6pt),

    [Gridformer],   [6.8M],  [40.49], [1.42], [1.19], [47.72], [0.96], [0.70], [45.59], [0.98], [0.97],
    [Transweather], [38.0M], [39.54], [1.67], [1.39], [46.26], [1.14], [0.80], [43.99], [1.22], [1.18],
    [CAPTNet],      [8.0M],  [41.10], [1.38], [1.15], [47.92], [0.94], [0.68], [48.94], [0.70], [0.77],
    [AdaIR],        [10.2M], [#underline[43.46]], [#underline[1.06]], [#underline[0.85]], [#underline[49.90]], [#underline[0.75]], [#underline[0.54]], [51.80], [0.47], [0.54],
    [PromptIR],     [28.5M], [43.34], [1.08], [0.88], [49.76], [0.76], [0.55], [#underline[52.20]], [#underline[0.46]], [#underline[0.53]],
    [MAGNet],       [5.1M],  [*44.01*], [*0.99*], [*0.81*], [*50.15*], [*0.74*], [*0.53*], [*52.52*], [*0.44*], [*0.52*],
    
    table.hline(stroke: 1.2pt),
  )
] <MAGNet_all-in-one_pansharpening>