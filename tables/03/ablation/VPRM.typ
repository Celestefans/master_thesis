#figure(
  caption: [VPRM 模块有效性消融实验结果分析],
  kind: table,
)[
  #set text(size: 9pt)
  #table(
    // 定义10列，第一列自适应，其余平分
    columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    stroke: none, 
    
    // --- 竖线分隔 ---
    table.vline(x: 1, stroke: 0.5pt), // Method 后
    table.vline(x: 4, stroke: 0.5pt), // Pansharpening 后
    table.vline(x: 7, stroke: 0.5pt), // MR Image SR 后
    // ----------------------------

    // 顶部粗线
    table.hline(stroke: 1.2pt),
    
    // 表头第一行：任务分类
    table.header(
      table.cell(rowspan: 2)[*Method*],
      table.cell(colspan: 3)[*Pansharpening*], 
      table.cell(colspan: 3)[*MR Image SR*], 
      table.cell(colspan: 3)[*Depth Image SR*],
      
      // 表头第二行：具体指标/倍率
      [*WV4*], [*QB*], [*GF1*],
      [2$times$], [4$times$], [8$times$],
      [4$times$], [8$times$], [16$times$],
    ),
    table.hline(stroke: 0.6pt),
    
    // 数据行 1: w/o VPRM (次优 - 下划线)
    [w/o VPRM], 
    [#underline[43.23]], [#underline[49.55]], [#underline[51.29]], 
    [#underline[43.77]], [#underline[38.03]], [#underline[34.87]], 
    [#underline[1.58]], [#underline[2.85]], [#underline[4.97]],

    // 数据行 2: VPNet (最优 - 粗体)
    [VPNet], 
    [*43.71*], [*50.00*], [*52.24*], 
    [*44.34*], [*39.02*], [*35.59*], 
    [*1.47*], [*2.69*], [*4.88*],
    
    // 底部粗线
    table.hline(stroke: 1.2pt),
  )
] <tab:VPNet_ablation_VPRM>