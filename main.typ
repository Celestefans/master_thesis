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
  degree: "professional",
  // anonymous: true,  // 盲审模式
  twoside: false, // 双面模式，会加入空白页，便于打印。双面模式下 front matter 部分页码始终在右侧。
  // 可自定义字体，先英文字体后中文字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」。
  fonts: (
    宋体: ("Times New Roman", "SimSun", "Songti SC", "STSong"),
    黑体: ("Times New Roman", "SimHei", "Heiti SC", "STHeiti"),
    楷体: ("Times New Roman", "KaiTi", "Kaiti SC", "STKaiti"),
    仿宋: ("Times New Roman", "FangSong", "FangSong SC", "STFangsong"),
    等宽: ("Times New Roman", "Consolas", "Courier New", "Menlo", "SimSun", "Songti SC", "STSong"),
  ),
  info: (
    // 如有需要，title 与 department 均支持多行。可以使用 \n 来分行或使用列表。
    title: ("基于动态路由与多模态提示\n的一体化引导式图像超分"),
    title-en: "All-in-One Guided Image Super-Resolution Based on Dynamic Routing and Multi-modal Prompting",
    grade: "2026",
    student-id: "51265901080",
    author: "王君",
    author-en: "Jun Wang",
    department: ("计算机科学与技术学院"),
    department-en: "School of Computer Science and Technology",
    // 专业 / 专业学位类别
    major: "电子信息",
    major-en: "Computer Science",

    // 研究生相关：研究方向 / 专业学位领域
    field: "计算机技术",
    field-en: "Image Processing",
    supervisor: ("方发明", "教授"),
    // supervisor: ("", ""),
    supervisor-en: ("Prof.", "Faming Fang"),
    // supervisor-en: ("", ""),
    // supervisor-ii: ("王五", "副教授"),
    // supervisor-ii-en: ("Assoc. Prof.", "Wu Wang"),
    submit-date: datetime.today(),
    // 密级与分类号，按照教务要求，可留白
    secret-level: "",
    clc: "",
    // 答辩委员会成员
    committee-members: (("王妍", "青年研究院", "华东师范大学", "主席"),
    ("刘丛", "副教授","上海理工大学","委员"),
    ("袁怡婷","高级工程师","思爱普（中国）有限公司","委员"),
    ),
  ),
  // 参考文献源
  bibliography: bibliography.with("ref.bib"),
)

// 文稿设置。fix-cjk 用于修复中文字符的换行问题。
#show: doc.with(fix-cjk: true)

// #set page(numbering: "I")
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
#set page(numbering: "I")
// 前言
#show: preface

// 中文摘要
#abstract(
  keywords: ("引导式图像超分", "一体化模型", "动态路由", "多模态融合")
)[
  引导式图像超分旨在利用高分辨率的辅助图像（如全色图像、RGB图像等）来提升低分辨率目标图像的空间分辨率，被广泛应用于遥感监测、医学成像及深度估计等领域。然而，现有的引导超分方法主要针对单一领域的特定任务设计，由于不同任务间存在巨大的模态差异和成像机理鸿沟，导致模型在跨任务场景下泛化能力不足，且面临着任务间相互干扰的挑战。为打破“一任务一模型”的传统范式，实现多模态任务的高效协同与通用重建，深度挖掘不同任务之间的潜在关联，本文基于提示学习与混合专家机制，提出了层层递进的两种一体化引导式图像超分方法，具体如下：

  （1）针对一体化引导式图像超分任务中存在的参数干扰与负迁移问题，提出了一种基于视觉感知动态路由的图像重建方法（VP-Net）。该方法创新性地引入混合专家（MoE）架构，利用引导图像的纹理、边缘等底层视觉特征作为隐式路由信号，动态激活特定任务的专家网络。这种基于视觉特征的“物理隔离”策略，有效缓解了多任务间的优化冲突，在不显著增加计算成本的前提下实现了对不同模态数据的差异化处理。

  （2）针对纯视觉感知路由机制存在的语义缺失问题，提出了一种融合多模态语义提示的图像重建方法（MAG-Net）。该方法在动态路由架构的基础上引入文本语义先验，设计了多模态提示生成模块（MPGM），利用预训练视觉-语言模型将任务描述转化为高维语义锚点，并注入到路由决策过程中。通过视觉感知+语义引导的双重驱动机制，该方法消除了视觉特征的歧义性，实现了像素级与任务级的精细化调控，显著提升了模型在全色锐化、深度图超分及磁共振重建等任务上的性能。
  
  （3）针对现有先进深度学习模型多以代码脚本形式存在、使用门槛高且难以直接服务于垂直领域专家的问题，设计并实现了一体化引导式图像超分演示系统。该系统基于 B/S 架构，集成了本文提出的核心算法模型，通过封装复杂的模型推理与环境配置过程，为医学、遥感及测绘等领域的非技术用户提供了一个零代码、可视化的高质量图像增强平台，有效缩短了从算法研究到实际应用的距离。
]

// 英文摘要
#abstract-en(
  keywords: ("Guided Image Super-Resolution", "All-in-One Model", "Dynamic Routing", "Multi-modal Fusion")
)[
  Guided image super-resolution aims to enhance the spatial resolution of low-resolution target images using high-resolution auxiliary images (such as panchromatic images, RGB images, etc.), and is widely used in remote sensing monitoring, medical imaging, and depth estimation. However, existing guided super-resolution methods are mainly designed for single specific tasks. Due to the huge modal differences and imaging mechanism gaps between different tasks, models lack generalization capability in cross-task scenarios and face the challenge of mutual interference between tasks. To break the traditional paradigm of "one model for one task" and achieve efficient collaboration and general reconstruction for multi-modal tasks, this thesis proposes two progressive All-in-One guided image super-resolution methods based on prompt learning and Mixture-of-Experts (MoE) mechanism, specifically as follows:

  (1) Addressing the problems of parameter interference and negative transfer in All-in-One guided image super-resolution tasks, a dynamic routing image reconstruction method based on visual perception (VP-Net) is proposed. This method innovatively introduces the Mixture-of-Experts (MoE) architecture, using low-level visual features such as textures and edges of the guidance image as implicit routing signals to dynamically activate task-specific expert networks. This "physical isolation" strategy based on visual features effectively alleviates optimization conflicts between multi-tasks and achieves differentiated processing of multi-modal data without significantly increasing computational costs.

  (2) Addressing the problems of "visual ambiguity" and "semantic absence" existing in pure visual perception routing mechanisms, an image reconstruction method integrating multi-modal semantic prompts (MAG-Net) is proposed. Based on the dynamic routing architecture, this method introduces textual semantic priors and designs a Multi-modal Prompt Generation Module (MPGM), which utilizes a pre-trained vision-language model to transform task descriptions into high-dimensional semantic anchors and injects them into the routing decision process. Through the dual-drive mechanism of visual perception + semantic guidance, this method eliminates the ambiguity of visual features, achieves refined control at both pixel and task levels, and significantly improves the model's performance on tasks such as pansharpening, depth map super-resolution, and MRI reconstruction.

  (3) Addressing the problem that existing advanced deep learning models mostly exist in the form of code scripts, have high barriers to use, and are difficult to directly serve experts in vertical fields, an All-in-One guided image super-resolution demonstration system is designed and implemented. Based on the B/S architecture, this system integrates the core algorithm models proposed in this thesis. By encapsulating complex model inference and environment configuration processes, it provides a zero-code, visual, and high-quality image enhancement platform for non-technical users in fields such as medicine, remote sensing, and surveying, effectively shortening the distance from algorithm research to practical application.
]

// 目录。preface 中的项目均可以通过可选的 outlined 属性控制是否在目录中显示
#outline-page(outlined: false)

// 修复插图和表格目录中英文字体不一致的问题（强制英文使用 Times New Roman，中文使用宋体）
#show outline: set text(font: ("Times New Roman", "SimSun", "Songti SC", "STSong"))

// 插图目录
#list-of-figures()

// 表格目录
#list-of-tables()

// // 符号表
// #notation[
//   / DFT: 密度泛函理论 (Density functional theory)
//   / DMRG: 密度矩阵重正化群密度矩阵重正化群密度矩阵重正化群 (Density-Matrix Reformation-Group)
//   / RAII: 资源获取即初始化 (Resource Acquisition Is Initialization)
// ]

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

时光荏苒，转眼间硕士研究生阶段的学习与科研生活即将画上句号。回首这段充实而难忘的岁月，心中满怀感恩。

首先，我要向我的导师方发明教授致以最诚挚的感谢。方老师严谨的治学态度、敏锐的学术洞察力和深厚的专业素养，始终是我学习和研究的标杆。从课题的选定、研究方案的设计到论文的撰写与修改，方老师都给予了悉心的指导与耐心的帮助。每当我在研究中遇到困惑与瓶颈时，方老师总能以其丰富的经验为我指明方向，帮助我拨云见日。方老师不仅教会了我如何做学术研究，更教会了我如何以踏实认真的态度面对工作与生活，这些宝贵的品质将使我终身受益。

同时，我要衷心感谢汪婷婷老师在研究生期间对我的关心与指导。汪老师在实验方法、论文写作等方面给予了许多宝贵的建议和细致的帮助，让我在科研道路上少走了很多弯路。汪老师亲切温和的为人处世方式也让我在求学过程中倍感温暖。

感谢实验室的各位同学，感谢你们在学习和生活中给予的陪伴和帮助。与大家一起讨论问题、分享思路的时光，是我研究生生涯中最珍贵的回忆之一。

最后，感谢我的家人一直以来无条件的支持与鼓励。正是你们的理解与付出，让我能够心无旁骛地投入到学业之中。

谨以此文，献给所有关心和帮助过我的人。
]

// 手动分页
#if twoside {
  pagebreak() + " "
}

// 附录。可选地，可以重置标题 counter
#show: appendix.with(reset-counter: false)



= 攻读硕士学位期间科研情况

#text(font: ("Times New Roman", "SimHei"), size: 12pt)[论文发表情况]
  - WANG T, #strong[WANG J], YAN Q, et al. Task-aware All-in-One Guided Image Super-Resolution[J]. Pattern Recognition, 2026: 11348（SCI 1区）

#v(2em)

#text(font: ("Times New Roman", "SimHei"), size: 12pt)[发明专利]

  - 申请人：#text(font: "SimHei")[王君]，方发明，汪婷婷。《基于多模态提示与自适应路由的一体化引导式图像超分方法》。申请号: 2026100492687

#v(1em)

// #[
//   #set par(justify: false)
//   #set list(indent: 3em)
//   - 基于多模态提示与自适应路由的一体化引导式图像超分方法。申请号: 2026100492687

// ]

