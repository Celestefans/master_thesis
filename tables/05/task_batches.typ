#figure(
  caption: [任务批次表 (#text(font: "Times New Roman")[`task_batches`])],
  kind: table,
)[
  #table(
    columns: (1.5fr, 1.5fr, 2fr, 2fr),
    align: (left, left, left, left),
    stroke: none,
    table.hline(stroke: 1.5pt),
    table.header([*字段名*], [*类型*], [*约束*], [*说明*]),
    table.hline(stroke: 0.75pt),
    [batch_id], [VARCHAR(64)], [PRIMARY KEY], [批次号],
    [user_id], [INT], [FOREIGN KEY], [创建用户 ID],
    [source_dir], [VARCHAR(512)], [NOT NULL], [源文件目录],
    [target_dir], [VARCHAR(512)], [NOT NULL], [目标输出目录],
    [task_type], [ENUM], [NOT NULL], [任务类型 ],
    [scale_factor], [VARCHAR(10)], [], [缩放倍率],
    [status], [ENUM], [], [批次状态],
    [avg_psnr], [FLOAT], [], [平均 PSNR],
    [created_at], [TIMESTAMP], [DEFAULT], [创建时间],
    table.hline(stroke: 1.5pt),
  )
] <task_batches>
