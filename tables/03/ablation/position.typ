#figure(
  caption: [不同模块位置（Encoder/Decoder）对各任务性能的影响分析],
  kind: table,
)[
  #set text(size: 9pt)
  #table(
    // 定义10列，第一列自适应，其余平分
    columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    stroke: none, 
    
    // --- 竖线分隔 (仿照图二布局) ---
    table.vline(x: 1, stroke: 1pt), // Position 后
    table.vline(x: 4, stroke: 0.5pt), // Pansharpening 后
    table.vline(x: 7, stroke: 0.5pt), // MR Image SR 后
    // ----------------------------

    // 顶部粗线
    table.hline(stroke: 1.2pt),
    
    // 表头第一行：任务分类
    table.header(
      table.cell(rowspan: 2)[*Position*],
      table.cell(colspan: 3)[*Pansharpening*], 
      table.cell(colspan: 3)[*MR Image SR*], 
      table.cell(colspan: 3)[*Depth Image SR*],
      
      // 表头第二行：具体指标/倍率
      [*WV4*], [*QB*], [*GF1*],
      [*2$times$*], [*4$times$*], [*8$times$*],
      [*4$times$*], [*8$times$*], [*16$times$*],
    ),
    table.hline(stroke: 0.6pt),
    
    // 数据行 2: Decoder
    [Decoder], 
    [43.53], [49.97], [51.93], 
    [44.20], [39.01], [35.59], 
    [1.50], [2.74], [4.94],


    // 数据行 1: Encoder
    [Encoder(VPNet)], 
    [#underline[44.01]], [#underline[50.15]], [#underline[52.52]], // Pan (2nd)
    [#underline[44.64]], [#underline[39.21]], [#underline[35.60]], // MR (2nd)
    [*1.29*], [*2.47*], [*4.45*],                                   // Depth (1st, RMSE lower is better)

    // 数据行 3: Both
    [Both],    
    [*44.03*], [*50.16*], [*52.57*], // Pan (1st)
    [*44.65*], [*39.23*], [*35.63*], // MR (1st)
    [*1.29*], [#underline[2.48]], [#underline[4.47]], // Depth (Tie 1st / 2nd)
    
    // 底部粗线
    table.hline(stroke: 1.2pt),
  )
] <tab:VPNet_ablation_position>