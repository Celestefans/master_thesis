#figure(
  caption: [不同一体化方法在磁共振图像超分任务上的对比结果，最优结果用 #strong[粗体]表示，次优结果用 #underline[下划线]表示],
  kind: table,
)[
  #set text(size: 9pt)
  #table(
    columns: (auto, auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    stroke: none,

    table.vline(x: 1, stroke: 0.5pt),
    table.vline(x: 2, stroke: 0.5pt),
    table.vline(x: 4, stroke: 0.5pt),
    table.vline(x: 6, stroke: 0.5pt),

    table.hline(stroke: 1.2pt),
    table.header(
      table.cell(rowspan: 2)[*Method*],
      table.cell(rowspan: 2)[*Parameters*],
      table.cell(colspan: 2)[*2x*],
      table.cell(colspan: 2)[*4x*],
      table.cell(colspan: 2)[*8x*],
      [PSNR↑], [SSIM↑],
      [PSNR↑], [SSIM↑],
      [PSNR↑], [SSIM↑],
    ),
    table.hline(stroke: 0.6pt),

    [Gridformer],   [6.8M],  [42.15], [0.9890], [36.70], [0.9662], [33.64], [0.9430],
    [Transweather], [38.0M], [39.91], [0.9821], [36.25], [0.9594], [33.73], [0.9332],
    [CAPTNet],      [8.0M],  [40.43], [0.9872], [35.05], [0.9573], [32.09], [0.9249],
    [AdaIR],        [10.2M], [#underline[44.27]], [#underline[0.9928]], [38.92], [0.9780], [35.56], [#underline[0.9585]],
    [Restormer],    [25.3M],     [43.77], [0.9896], [38.03], [0.9688], [34.87], [0.9491],
    [PromptIR],     [28.5M], [44.16], [0.9926], [#underline[38.97]], [#underline[0.9781]], [#underline[35.58]], [0.9582],
    [MAGNet],       [5.1M],  [*44.64*], [*0.9928*], [*39.21*], [*0.9786*], [*35.69*], [*0.9679*],
    
    table.hline(stroke: 1.2pt),
  )
] <MAGNet_all-in-one_mri>