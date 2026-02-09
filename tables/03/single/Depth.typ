#figure(
  caption: [不同one-by-one方法在Depth Image SR 任务上的对比结果，最优结果用 #strong[粗体]表示，次优结果用 #underline[下划线]表示],
  kind: table,
)[
#set text(size: 9pt)
  #table(
    columns: (auto, 1fr, 1fr, 1fr),
    align: center + horizon,
    stroke: none, 
    
    // 竖线分隔
    table.vline(x: 1, stroke: 0.5pt), 
    table.vline(x: 2, stroke: 0.5pt), 
    table.vline(x: 3, stroke: 0.5pt), 

    // 表头横线
    table.hline(stroke: 1.2pt),
    table.header(
      table.cell(rowspan: 2)[*Method*],
      table.cell(colspan: 1)[*4x*], 
      table.cell(colspan: 1)[*8x*], 
      table.cell(colspan: 1)[*16x*],
      [RMSE↓], 
      [RMSE↓], 
      [RMSE↓],
    ),
    table.hline(stroke: 0.6pt),
    
    // 数据行
    [GeoDSR], [1.42], [#underline[2.62]], [4.86],
    [DAGF],   [1.36], [2.87], [6.06],
    [AHMF],   [1.40], [2.89], [5.64],
    [DCTNet], [1.59], [3.16], [5.84],
    [DKN],    [1.62], [3.26], [6.51],
    [FDKN],   [1.86], [3.58], [6.69],
    [SGNet],  [*1.10*], [*2.44*], [#underline[4.77]],
    [VPNet],  [#underline[1.32]], [*2.44*], [*4.67*],
    
    table.hline(stroke: 1.2pt),
  )
] <tab:VPNet_one-by-one_depth>