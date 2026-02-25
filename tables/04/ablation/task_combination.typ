#figure(
  caption: [不同任务组合（Task P, M, D）消融实验结果分析],
  kind: table,
)[
  #set text(size: 9pt)
  #table(
    // 12列：3列任务标识 + 9列数据
    columns: (auto, auto, auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    stroke: none, 
    
    // --- 竖线分隔 ---
    table.vline(x: 3, stroke: 0.5pt), // Task 列之后
    table.vline(x: 6, stroke: 0.5pt), // Pansharpening 之后
    table.vline(x: 9, stroke: 0.5pt), // MR Image SR 之后
    // ----------------------------

    // 顶部粗线
    table.hline(stroke: 1.2pt),
    
    // 表头第一行：任务分类
    table.header(
      table.cell(colspan: 3)[*Task*],
      table.cell(colspan: 3)[*Pansharpening*], 
      table.cell(colspan: 3)[*MR Image SR*], 
      table.cell(colspan: 3)[*Depth Image SR*],
      
      // 表头第二行：具体任务标识与倍率指标
      [*P*], [*M*], [*D*],
      [*WV4*], [*QB*], [*GF1*],
      [2$times$], [4$times$], [8$times$],
      [4$times$], [8$times$], [16$times$],
    ),
    table.hline(stroke: 0.6pt),
    
    // 数据行 1
    [*$checkmark$*], [*$times$*], [*$times$*], 
    [43.73], [49.89], [51.98], 
    [$-$], [$-$], [$-$], 
    [$-$], [$-$], [$-$],

    // 数据行 2
    [*$times$*], [*$checkmark$*], [*$times$*], 
    [$-$], [$-$], [$-$], 
    [*45.03*], [39.02], [35.62], 
    [$-$], [$-$], [$-$],

    // 数据行 3
    [*$times$*], [*$times$*], [*$checkmark$*], 
    [$-$], [$-$], [$-$], 
    [$-$], [$-$], [$-$], 
    [*1.21*], [*2.40*], [*4.39*],

    // 数据行 4
    [*$checkmark$*], [*$checkmark$*], [*$times$*], 
    [#underline[44.01]], [50.00], [52.41], 
    [#underline[44.88]], [#underline[39.25]], [35.66], 
    [$-$], [$-$], [$-$],

    // 数据行 5
    [*$checkmark$*], [*$times$*], [*$checkmark$*], 
    [*44.09*], [#underline[50.05]], [*52.59*], 
    [$-$], [$-$], [$-$], 
    [1.28], [2.48], [4.50],

    // 数据行 6
    [*$times$*], [*$checkmark$*], [*$checkmark$*], 
    [$-$], [$-$], [$-$], 
    [44.83], [*39.28*], [*35.70*], 
    [#underline[1.27]], [#underline[2.47]], [4.48],

    // 数据行 7
    [*$checkmark$*], [*$checkmark$*], [*$checkmark$*], 
    [#underline[44.01]], [*50.15*], [#underline[52.52]], 
    [44.64], [39.21], [35.60], 
    [1.29], [#underline[2.47]], [#underline[4.45]],
    
    // 底部粗线
    table.hline(stroke: 1.2pt),
  )
] <tab:ablation_task_combination>