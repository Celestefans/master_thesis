#figure(
  caption: [不同模块（MPGM 与 MGRM）消融实验结果分析],
  kind: table,
)[
  #set text(size: 9pt)
  #table(
    // 11列：2列模块标识 + 9列数据
    columns: (auto, auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    stroke: none, 
    
    // --- 竖线分隔 ---
    table.vline(x: 2, stroke: 0.5pt), // 模块列之后
    table.vline(x: 5, stroke: 0.5pt), // Pansharpening 之后
    table.vline(x: 8, stroke: 0.5pt), // MR Image SR 之后
    // ----------------------------

    // 顶部粗线
    table.hline(stroke: 1.2pt),
    
    // 表头第一行：任务分类
    table.header(
      table.cell(colspan: 2)[*Module*],
      table.cell(colspan: 3)[*Pansharpening*], 
      table.cell(colspan: 3)[*MR Image SR*], 
      table.cell(colspan: 3)[*Depth Image SR*],
      
      // 表头第二行：具体模块与倍率指标
      [*MPGM*], [*MGRM*],
      [*WV4*], [*QB*], [*GF1*],
      [*2$times$*], [*4$times$*], [*8$times$*],
      [*4$times$*], [*8$times$*], [*16$times$*],
    ),
    table.hline(stroke: 0.6pt),
    
    // 数据行 1
    [*$times$*], [*$times$*], 
    [43.68], [49.94], [51.60], 
    [44.32], [38.92], [35.29], 
    [1.50], [2.79], [5.12],

    // 数据行 2 (次优)
    [*$checkmark$*], [*$times$*], 
    [#underline[43.83]], [#underline[50.09]], [#underline[52.34]], 
    [#underline[44.46]], [#underline[39.16]], [#underline[35.35]], 
    [#underline[1.41]], [#underline[2.63]], [#underline[4.75]],

    // 数据行 3
    [*$times$*], [*$checkmark$*], 
    [43.71], [50.00], [51.71], 
    [44.13], [38.96], [35.31], 
    [1.47], [2.69], [4.88],

    // 数据行 4 (最优)
    [*$checkmark$*], [*$checkmark$*], 
    [*44.01*], [*50.15*], [*52.52*], 
    [*44.64*], [*39.21*], [*35.60*], 
    [*1.29*], [*2.47*], [*4.45*],
    
    // 底部粗线
    table.hline(stroke: 1.2pt),
  )
] <tab:ablation_modules>