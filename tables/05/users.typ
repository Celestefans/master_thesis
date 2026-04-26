#figure(
  caption: [用户信息表 (#text(font: "Times New Roman")[`users`])],
  kind: table,
)[
  #table(
    columns: (1.5fr, 1.5fr, 2fr, 2fr),
    align: (left, left, left, left),
    stroke: none,
    table.hline(stroke: 1.5pt),
    table.header([*字段名*], [*类型*], [*约束*], [*说明*]),
    table.hline(stroke: 0.75pt),
    [id], [INT], [PRIMARY KEY], [用户 ID],
    [username], [VARCHAR(50)], [UNIQUE, NOT NULL], [用户名],
    [password], [VARCHAR(255)], [NOT NULL], [加密存储的密码],
    [role], [ENUM], [NOT NULL], [用户角色],
    [name], [VARCHAR(50)], [], [真实姓名],
    [created_at], [TIMESTAMP], [DEFAULT], [创建时间],
    [last_login], [TIMESTAMP], [], [最后登录时间],
    table.hline(stroke: 1.5pt),
  )
] <users>
