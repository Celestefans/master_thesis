#figure(
  caption: [系统日志表 (`system_logs`)],
  kind: table,
)[
  #table(
    columns: (1.5fr, 1.5fr, 2fr, 2fr),
    align: (left, left, left, left),
    stroke: none,
    table.hline(stroke: 1.5pt),
    table.header([*字段名*], [*类型*], [*约束*], [*说明*]),
    table.hline(stroke: 0.75pt),
    [id], [BIGINT], [PRIMARY KEY], [日志 ID],
    [user_id], [INT], [FOREIGN KEY], [操作用户 ID],
    [action], [VARCHAR(50)], [NOT NULL], [操作动作],
    [ip_address], [VARCHAR(45)], [], [客户端 IP],
    [timestamp], [TIMESTAMP], [DEFAULT], [发生时间],
    table.hline(stroke: 1.5pt),
  )
] <system_logs>
