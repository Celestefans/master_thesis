#figure(
  caption: [不同all-in-one方法在Depth Image SR 任务上的对比结果，最优结果用 #strong[粗体]表示，次优结果用 #underline[下划线]表示],
  kind: table,
)[
  #set text(size: 9pt)
  #table(
    columns: (auto, 1fr, 1fr, 1fr),
    align: center + horizon,
    stroke: none, 
    
    table.vline(x: 1, stroke: 0.5pt), 
    table.vline(x: 2, stroke: 0.5pt), 
    table.vline(x: 3, stroke: 0.5pt), 

    table.hline(stroke: 1.2pt),
    table.header(
      table.cell(rowspan: 2)[*Method*],
      table.cell(colspan: 1)[*X4*], 
      table.cell(colspan: 1)[*X8*], 
      table.cell(colspan: 1)[*X16*],
      [RMSE↓], 
      [RMSE↓], 
      [RMSE↓],
    ),
    table.hline(stroke: 0.6pt),
    
    [Gridformer],   [1.67], [3.04], [5.72],
    [Transweather], [2.97], [4.14], [6.20],
    [CAPTNet],      [1.64], [2.88], [5.13],
    [AdaIR],        [1.53], [#underline[2.79]], [5.09],
    [PromptIR],     [#underline[1.48]], [*2.69*], [#underline[4.89]],
    [VPNet],        [*1.47*], [*2.69*], [*4.88*],
    
    table.hline(stroke: 1.2pt),
  )
] <tab:VPNet_all-in-one_depth>