#figure(
  caption: [不同one-by-one方法在MR Image SR任务上的对比结果，最优结果用 #strong[粗体]表示，次优结果用 #underline[下划线]表示],
  kind: table,
)[
  #set text(size: 9pt)
  #table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    stroke: none, 
    
    // 竖线分隔
    table.vline(x: 1, stroke: 0.5pt), 
    table.vline(x: 3, stroke: 0.5pt), 
    table.vline(x: 5, stroke: 0.5pt), 

    // 表头横线
    table.hline(stroke: 1.2pt),
    table.header(
      table.cell(rowspan: 2)[*Method*],
      table.cell(colspan: 2)[*2x*], 
      table.cell(colspan: 2)[*4x*], 
      table.cell(colspan: 2)[*8x*],
      [PSNR↑], [SSIM↑], 
      [PSNR↑], [SSIM↑], 
      [PSNR↑], [SSIM↑],
    ),
    table.hline(stroke: 0.6pt),
    
    // 数据行
    [MGDUN],   [40.97], [#underline[0.9893]], [35.34], [0.9632], [32.61], [0.9361],
    [MADUNet], [38.94], [0.9843], [34.09], [0.9548], [30.18], [0.9114],
    [MINet],   [38.84], [0.9788], [35.62], [0.9625], [32.38], [0.9335],
    [MASA],    [40.37], [0.9883], [34.93], [0.9590], [30.41], [0.8954],
    [McMRSR],  [40.96], [#underline[0.9893]], [35.20], [0.9596], [30.55], [0.8985],
    [SANet],   [42.36], [0.9881], [36.56], [0.9583], [33.53], [0.9419],
    [DuDoNet], [#underline[44.96]], [*0.9919*], [*38.99*], [*0.9744*], [#underline[35.43]], [#underline[0.9533]],
    [VPNet],   [*44.98*], [*0.9919*], [#underline[38.95]], [#underline[0.9742]], [*35.47*], [*0.9550*],
    
    // 底部横线
    table.hline(stroke: 1.2pt),
  )
] <tab:VPNet_one-by-one_mri>