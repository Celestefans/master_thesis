#figure(
  caption: [不同one-by-one方法在Pansharpening任务上的对比结果，最优结果用 #strong[粗体]表示，次优结果用 #underline[下划线]表示],
  kind: table,
)[
  #set text(size: 9pt)
  #table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    stroke: none, 
    
    // 竖线分隔
    table.vline(x: 1, stroke: 0.5pt), 
    table.vline(x: 4, stroke: 0.5pt), 
    table.vline(x: 7, stroke: 0.5pt), 

    // 表头横线
    table.hline(stroke: 1.2pt),
    table.header(
      table.cell(rowspan: 2)[*Method*],
      table.cell(colspan: 3)[*WV4*], 
      table.cell(colspan: 3)[*QB*], 
      table.cell(colspan: 3)[*GF1*],
      [PSNR↑], [SAM↓], [ERGAS↓], 
      [PSNR↑], [SAM↓], [ERGAS↓], 
      [PSNR↑], [SAM↓], [ERGAS↓],
    ),
    table.hline(stroke: 0.6pt),
    
    // 数据行
    [AWFLN],        [42.13], [1.23], [0.98], [49.14], [0.82], [0.60], [49.70], [0.62], [0.64],
    [DISPNet],      [40.79], [1.43], [1.15], [48.18], [0.93], [0.70], [46.61], [0.86], [0.84],
    [LAGConv],      [41.54], [1.33], [1.07], [47.89], [0.96], [0.71], [47.66], [0.79], [0.79],
    [M3DNet],       [42.27], [1.20], [0.97], [49.45], [0.80], [0.58], [49.80], [0.62], [0.64],
    [FusionMamba],  [42.84], [#underline[1.15]], [#underline[0.92]], [49.50], [0.81], [0.59], [50.79], [#underline[0.55]], [0.60],
    [DifPan],       [*43.89*], [*1.03*], [*0.83*], [*50.22*], [*0.72*], [*0.53*], [*52.33*], [*0.46*], [*0.51*],
    [VPNet],        [#underline[43.57]], [*1.06*], [*0.87*], [#underline[49.77]], [#underline[0.75]], [#underline[0.56]], [#underline[52.14]], [*0.50*], [#underline[0.56]],
    
    // 底部横线
    table.hline(stroke: 1.2pt),
  )
] <tab:VPNet_one-by-one_pansharpening>