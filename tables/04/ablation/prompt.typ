#figure(
  caption: [不同模态（Text 与 Image）对联合任务性能的消融实验结果分析],
  kind: table,
)[
  #set text(size: 9pt)
  #table(
    // 11列：2列模态标识 + 9列数据
    columns: (auto, auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    stroke: none, 
    
    // --- 竖线分隔 ---
    table.vline(x: 2, stroke: 0.5pt), // Modality 列之后
    table.vline(x: 5, stroke: 0.5pt), // Pansharpening 之后
    table.vline(x: 8, stroke: 0.5pt), // MR Image SR 之后
    // ----------------------------

    // 顶部粗线
    table.hline(stroke: 1.2pt),
    
    // 表头第一行：分类
    table.header(
      table.cell(colspan: 2)[*Modality*],
      table.cell(colspan: 3)[*Pansharpening*], 
      table.cell(colspan: 3)[*MR Image SR*], 
      table.cell(colspan: 3)[*Depth Image SR*],
      
      // 表头第二行：具体模态与倍率指标
      [Text], [Image],
      [*WV4*], [*QB*], [*GF1*],
      [2$times$], [4$times$], [8$times$],
      [4$times$], [8$times$], [16$times$],
    ),
    table.hline(stroke: 0.6pt),
    
    // 数据行 1 (x, x)
    [*$times$*], [*$times$*], 
    [#underline[43.81]], [50.01], [50.73], 
    [44.19], [39.02], [35.56], 
    [1.47], [2.72], [4.91],

    // 数据行 2 (check, x)
    [*$checkmark$*], [*$times$*], 
    [43.74], [*50.17*], [52.31], 
    [44.10], [38.92], [35.57], 
    [#underline[1.46]], [2.75], [#underline[4.84]],

    // 数据行 3 (x, check)
    [*$times$*], [*$checkmark$*], 
    [43.73], [50.09], [#underline[52.43]], 
    [#underline[44.22]], [#underline[39.04]], [*35.61*], 
    [1.48], [#underline[2.68]], [4.91],

    // 数据行 4 (check, check)
    [*$checkmark$*], [*$checkmark$*], 
    [*44.01*], [#underline[50.15]], [*52.52*], 
    [*44.64*], [*39.21*], [#underline[35.60]], 
    [*1.29*], [*2.47*], [*4.45*],
    
    // 底部粗线
    table.hline(stroke: 1.2pt),
  )
] <tab:ablation_prompt>