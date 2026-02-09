#import "@preview/modern-ecnu-thesis:0.3.0": documentclass, indent, no-indent, word-count-cjk, total-words, bilingual-figure

// 模板用到的主要字体：https://github.com/jtchen2k/modern-ecnu-thesis/tree/main/fonts/
// 如果是在 Web App 上编辑，你应该手动上传上述字体文件，否则不能正常使用「楷体」和「仿宋」。
// 如果在本地编辑，将使用 Windows / macOS 内置的宋体、黑体、楷体、仿宋字体。

#set figure(numbering: "1.1")




#let (
  // 布局函数
  twoside, doc, preface, mainmatter, mainmatter-end, appendix,
  // 页面函数
  fonts-display-page, cover, decl-page, committee, abstract, abstract-en, bilingual-bibliography,
  outline-page, list-of-figures, list-of-tables, notation, acknowledgement,
  academic-integrity,
) = documentclass(
  // doctype: "bachelor",  // "bachelor" | "master" | "doctor", 文档类型，默认为硕士生 master
  doctype: "master",
  // degree: "academic",  // "academic" | "professional", 学位类型，默认为学术型 academic
  degree: "academic",
  // anonymous: true,  // 盲审模式
  twoside: false, // 双面模式，会加入空白页，便于打印。双面模式下 front matter 部分页码始终在右侧。
  // 可自定义字体，先英文字体后中文字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」。
  // fonts: (楷体: ("Times New Roman", "FZKai-Z03S"))
  info: (
    // 如有需要，title 与 department 均支持多行。可以使用 \n 来分行或使用列表。
    title: ("基于动态路由与多模态提示的一体化引导图像超分辨率研究"),
    title-en: "Research on All-in-One Guided Image Super-Resolution Based on Dynamic Routing and Multi-modal Prompting",
    grade: "2026",
    student-id: "51265901080",
    author: "王君",
    author-en: "Jun Wang",
    department: ("计算机科学与技术学院"),
    department-en: "School of Computer Science and Technology",
    // 专业 / 专业学位类别
    major: "计算机技术",
    major-en: "Computer Science",

    // 研究生相关：研究方向 / 专业学位领域
    field: "图像处理",
    field-en: "Image Processing",
    supervisor: ("方发明", "教授"),
    supervisor-en: ("Prof.", "Faming Fang"),
    // supervisor-ii: ("王五", "副教授"),
    // supervisor-ii-en: ("Assoc. Prof.", "Wu Wang"),
    submit-date: datetime.today(),
    // 密级与分类号，按照教务要求，可留白
    secret-level: "",
    clc: "",
    // 答辩委员会成员
    committee-members: (("赵六", "教授", "华东师范大学", "主席")),
  ),
  // 参考文献源
  bibliography: bibliography.with("ref.bib"),
)

// 文稿设置。fix-cjk 用于修复中文字符的换行问题。
#show: doc.with(fix-cjk: true)

// 字体展示测试页
// #fonts-display-page()

// 封面页
#cover(
  // 这里的可选参数可以用于调整封面字段每一行的长度
  title-line-length: 320pt,
  title-line-length-en: 300pt,
  meta-info-line-length: 200pt,
  meta-info-line-length-en: 230pt,
)

// 学位论文原创性声明
#decl-page()

// 答辩委员会页（仅研究生）
#committee()

// 前言
#show: preface

// 中文摘要
#abstract(
  keywords: ("引导图像超分辨率", "一体化模型", "动态路由", "多模态融合")
)[
  引导图像超分辨率旨在利用高分辨率的辅助图像（如全色图像、RGB图像等）来提升低分辨率目标图像的空间分辨率，被广泛应用于遥感监测、医学成像及深度估计等领域。然而，现有的引导超分辨率方法主要针对单一特定任务设计，由于不同任务间存在巨大的模态差异和成像机理鸿沟，导致模型在跨任务场景下泛化能力不足，且面临着任务间相互干扰的挑战。为打破“一任务一模型”的传统范式，实现多模态任务的高效协同与通用重建，本文基于提示学习与混合专家机制，提出了层层递进的两种一体化引导图像超分辨率方法，具体如下：

  （1）提出一种基于视觉特征引导的动态路由重建方法。 针对现有单一网络在处理多任务时易产生特征冲突与负迁移，且未能充分解耦不同任务特性的问题，本文提出了一种基于视觉感知的动态路由机制。该方法引入混合专家架构（MoE），构建多引导路由模块，利用图像自身的视觉特征作为隐式引导信号，自适应地激活适合当前输入的专家网络路径。该方法在不显著增加计算成本的前提下，实现了对不同任务特征的差异化处理，有效缓解了多任务学习中的干扰问题，为一体化模型的构建奠定了结构基础。

  （2）提出一种融合文本语义的多模态提示驱动重建方法。 针对仅依赖视觉特征进行引导时对任务意图理解不足，且难以应对复杂模态差异的瓶颈，本文在动态路由的基础上，引入文本语义先验，构建了多模态提示生成模块。该方法创新性地将任务描述文本（Textual Description）映射至语义空间，并与视觉特征深度融合，生成显式的多模态任务指令（Prompts）。这些指令如同“导航员”一般，精准调控网络内部的特征流向与交互方式。实验表明，该方法实现了领域视觉信息与高层语义知识的深度融合，显著提升了模型在全色锐化、深度图超分及磁共振重建等多个任务上的性能与泛化能力。
  
  （3）设计并实现了一体化引导图像超分辨率算法验证与可视化系统。 针对现有理论研究缺乏统一的评估平台，且难以直观展示模型内部动态机制与多任务处理效果的问题，本文基于所提出的算法模型，研发了一个集算法验证、对比分析与可视化展示于一体的实验系统。该系统完整集成了本文提出的两种核心算法，支持多源异构数据的统一接入与一键处理，并特别设计了中间特征（如动态路由分布、多模态提示热力图）的可视化模块。通过该系统，不仅直观验证了所提算法在实际应用场景下的有效性与鲁棒性，也增强了深度模型的透明度与可解释性，为相关技术的工程化应用提供了有力的工具支撑。
]

// 英文摘要
#abstract-en(
  keywords: ("To", "be", "or", "not", "to", "be")
)[
  #lorem(100)
]

// 目录。preface 中的项目均可以通过可选的 outlined 属性控制是否在目录中显示
#outline-page(outlined: false)

// 插图目录
#list-of-figures()

// 表格目录
#list-of-tables()

// 符号表
#notation[
  / DFT: 密度泛函理论 (Density functional theory)
  / DMRG: 密度矩阵重正化群密度矩阵重正化群密度矩阵重正化群 (Density-Matrix Reformation-Group)
  / RAII: 资源获取即初始化 (Resource Acquisition Is Initialization)
]

// 正文
// 可选的，可以通过 #show: mainmatter.with(figure-clearance: 0pt) 来设置浮动图表的间距或其他参数
#show: mainmatter.with(
  caption-mode: "standard", // caption 模式，standard 或 bilingual
)

// 字数统计开始
#show: word-count-cjk

// = 绪　论
#include "chapters/01-introduction.typ"

#include "chapters/02-related-work.typ"

#include "chapters/03-VPNet.typ"

#include "chapters/04-MAGNet.typ"

#include "chapters/05-system.typ"

#include "chapters/06-summarize.typ"






















// 中英双语参考文献
// 默认使用修改后的 gb-7714-2015-numeric-nosup.csl 样式（引用文字非上标格式）。该文件嵌入在模板内。如需使用上标格式，使用 Typst 自带的 gb-t-7714-2015-numeric 即可。
// 将 full 设置为 false 可以只显示正文中引用的文献。
#bilingual-bibliography(full: true, style: "./gb-t-7714-2015-numeric-nosup.csl")

// 致谢
#acknowledgement[

_感谢以下模板提供的参考：_


- #link("https://github.com/nju-lug/modern-nju-thesis")[modern-nju-thesis] by #link("https://github.com/Orangex4")[OrangeX4]
- #link("https://github.com/YijunYuan/ECNU-Undergraduate-LaTeX")[ECNU-Undergraduate-LaTeX] by #link("https://github.com/YijunYuan")[YijunYuan]
- #link("https://www.overleaf.com/latex/templates/hua-dong-shi-fan-da-xue-shuo-shi-lun-wen-mo-ban-2023/ctvnwyqtsbbz")[华东师范大学硕士论文模板-2023] by ivyee17
- #link("https://github.com/ECNU-ICA/ECNU_graduation_thesis_template")[ECNU_graduation_thesis_template] by #link("https://github.com/ECNU-ICA")[ECNU-ICA]
- #link("https://github.com/DeepTrial/ECNU-Dissertations-Latex-Template")[ECNU-Dissertations-Latex-Template] by #link("https://github.com/DeepTrial")[Karl Xing]
]

// 手动分页
#if twoside {
  pagebreak() + " "
}

// 附录。可选地，可以重置标题 counter
#show: appendix.with(reset-counter: false)

= 附录

== 附录子标题

=== 附录子子标题

附录内容，这里也可以加入图片，例如@fig:appendix-img。

#figure(
  caption: [图片测试],
)[
#image("images/ecnu-emblem.svg", width: 20%)
] <appendix-img>

= 攻读硕/博士学位期间科研情况

#[
// Typst 暂不支持多 bibliography 功能。因此需用有序列表来手动列出参考文献。
#set enum(numbering: "[1]")
#set par(justify: false)

+ J. von Neumann, "First draft of a report on the EDVAC," IEEE Annals of the History of Computing, vol. 15, no. 4, pp. 27–75, 1993, doi: 10.1109/85.238389.
+ A. M. Turing, "On Computable Numbers, with an Application to the Entscheidungsproblem," Proceedings of the London Mathematical Society, vol. s2-42, no. 1, pp. 230–265, 1937, doi: 10.1112/plms/s2-42.1.230.
]

